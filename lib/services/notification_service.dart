import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../models/prayer_time.dart';

/// Arka planda bildirim üzerindeki "KILDIM" butonuna basıldığında tetiklenir.
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  if (notificationResponse.actionId == NotificationService.actionKildimId) {
    final payload = notificationResponse.payload;
    if (payload != null) {
      NotificationService().cancelPrayerReminders(payload);
    }
  }
}

/// Akıllı Bildirim Servisi (Faz 6).
///
/// BENZERSİZ BİLDİRİM ID ŞEMASI (GÖREV 4):
/// Her vakit için 10'un katları kullanılır:
///   Sabah (fajr):   Primary=10, Reminder1=11 (Güneş'e 30dk kala)
///   Öğle  (dhuhr):  Primary=20, Reminder1=21 (45dk sonra)
///   İkindi(asr):    Primary=30, Reminder1=31 (45dk sonra)
///   Akşam (maghrib):Primary=40, Reminder1=41 (45dk sonra)
///   Yatsı (isha):   Primary=50, Reminder1=51 (1s sonra), Reminder2=52 (2s sonra)
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String actionKildimId = 'ACTION_KILDIM';
  static const String notificationCategoryKey = 'PRAYER_NOTIFICATION_CATEGORY';

  // Sadece hatırlatıcıların (reminder) ID'leri — KILDIM bunları iptal eder
  static const Map<String, List<int>> _reminderIds = {
    'fajr':    [11],
    'dhuhr':   [21],
    'asr':     [31],
    'maghrib': [41],
    'isha':    [51, 52],
  };

  bool _initialized = false;

  /// Servisi ve yerel saat dilimini (TimeZone) başlatır.
  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    // Varsayılan ve zorunlu taban: Türkiye saati
    String timezoneName = 'Europe/Istanbul';

    try {
      final String deviceTimezone = await FlutterTimezone.getLocalTimezone();
      // Cihaz 'GMT', 'UTC' veya boş dönerse YOK SAY — 3 saatlik kaymayı önler
      if (deviceTimezone.isNotEmpty &&
          deviceTimezone != 'GMT' &&
          deviceTimezone != 'UTC') {
        timezoneName = deviceTimezone;
        debugPrint('🕐 Cihaz timezone\'u geçerli: $deviceTimezone');
      } else {
        debugPrint('⚠️ Cihaz timezone\'u geçersiz ($deviceTimezone), Europe/Istanbul kullanılıyor.');
      }
    } catch (e) {
      debugPrint('⚠️ Timezone alınamadı, varsayılan kullanılıyor: $e');
    }

    // Kesin sabitleme — tek bir setLocalLocation çağrısı
    tz.setLocalLocation(tz.getLocation(timezoneName));
    debugPrint('🕐 Kilitlenmiş Aktif Timezone: $timezoneName');

    // GÖREV 2: Renkli ikonların beyaz kare olmasını önleyen transparan bildirim ikonu
    const androidInit = AndroidInitializationSettings('@drawable/ic_notification');

    final darwinInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [
        DarwinNotificationCategory(
          notificationCategoryKey,
          actions: [
            DarwinNotificationAction.plain(
              actionKildimId,
              'KILDIM',
              options: {DarwinNotificationActionOption.foreground},
            ),
          ],
        ),
      ],
    );

    await _notificationsPlugin.initialize(
      InitializationSettings(android: androidInit, iOS: darwinInit),
      onDidReceiveNotificationResponse: (response) {
        if (response.actionId == actionKildimId && response.payload != null) {
          cancelPrayerReminders(response.payload!);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    _initialized = true;
  }

  /// Konum izni bittikten SONRA çağrılmalıdır — izin çakışmasını önler.
  Future<void> requestAllPermissions() async {
    final android = _notificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (android != null) {
      await android.requestNotificationsPermission();
      await android.requestExactAlarmsPermission();
    }

    final ios = _notificationsPlugin
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();

    await ios?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Namaz vakitlerine göre SADECE GELECEKTEKİ vakitlere bildirim kurar.
  ///
  /// GÖREV 2: Her bildirim kurulmadan önce `isAfter(now)` kontrolü yapılır.
  /// Geçmiş vakitler için hiçbir zonedSchedule çağrısı yapılmaz — hayalet bildirim olmaz.
  ///
  /// GÖREV 4: Her bildirim benzersiz ID alır, hiçbiri birbirini ezmez.
  Future<void> schedulePrayerNotifications(PrayerTime prayerTime) async {
    await cancelAllNotifications();

    final now = tz.TZDateTime.now(tz.local);
    debugPrint('⏰ Bildirim zamanlama başlıyor.');
    debugPrint('   Şu anki TZ zamanı : $now');
    debugPrint('   Aktif timezone     : ${tz.local.name}');

    /// GÖREV 2: "HH:mm" string'ini güvenli TZDateTime'a çevirir.
    /// Önce plain DateTime oluşturur, ardından tz.TZDateTime.from() ile
    /// timezone'a dönüştürür — DST (yaz/kış saati) geçişlerini otomatik yönetir.
    tz.TZDateTime parseTime(String timeStr, {int addMinutes = 0, int addHours = 0}) {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      // Adım 1: Saf DateTime (timezone-naive)
      final plainDt = DateTime(now.year, now.month, now.day, hour, minute);
      // Adım 2: GÖREV 2 → TZDateTime.from() ile timezone-aware'e dönüştür
      var tzDt = tz.TZDateTime.from(plainDt, tz.local);
      // Adım 3: Offset varsa uygula
      if (addMinutes != 0 || addHours != 0) {
        tzDt = tzDt.add(Duration(hours: addHours, minutes: addMinutes));
      }
      return tzDt;
    }

    final androidDetails = AndroidNotificationDetails(
      'prayer_times_channel',
      'Namaz Vakitleri & Hatırlatıcılar',
      channelDescription: 'Ezan vakitleri ve akıllı namaz hatırlatıcı bildirimleri',
      icon: '@drawable/ic_notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      actions: const [
        AndroidNotificationAction(actionKildimId, 'KILDIM', showsUserInterface: true),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: notificationCategoryKey,
      interruptionLevel: InterruptionLevel.critical,
    );

    final details = NotificationDetails(android: androidDetails, iOS: iosDetails);

    int scheduled = 0;

    // ── Yardımcı: GÖREV 3 → Geçmişse/şu ansa atla, gelecekteyse logla ve zamanla ──
    Future<void> schedule(int id, String title, String body, tz.TZDateTime when,
        {String? payload}) async {
      final now = tz.TZDateTime.now(tz.local);
      // GÖREV 3: Geçmiş veya tam şu anki vakit filtresi — geçmiş bildirim ekrana DÜŞMEZ
      if (when.isBefore(now) || when.isAtSameMomentAs(now)) {
        debugPrint('  ⏭️ [ID:$id] "$title" → $when (geçmiş/şu anki vakit, atlandı)');
        return;
      }
      // Gelecekteki bildirim kuruluyor
      debugPrint('  🔔 Bildirim Kuruluyor: ID $id, Zaman: $when');
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        when,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
      scheduled++;
      debugPrint('  ✅ [ID:$id] başarıyla zamanlandı.');
    }
    // ─────────────────────────────────────────────────────────────────────────

    // 1. SABAH (Fajr): Güneş'e 30dk kala uyarı (ID:11)
    //    Not: Sabah'ın tam vakti için primary bildirim yok (imsak bildirimi değil,
    //    sadece "daralan vakit" uyarısı istenmişti).
    await schedule(11, 'Sabah Namazı - Daralan Vakit',
        'Güneşin doğuşuna 30 dakika kaldı! Sabah namazını eda etmeyi unutmayın.',
        parseTime(prayerTime.sunrise, addMinutes: -30),
        payload: 'fajr');

    // 2. ÖĞLE (Dhuhr): Vakit (ID:20) + 45dk Hatırlatıcı (ID:21)
    await schedule(20, 'Öğle Vakti Girdi',
        'Öğle namazı vakti girdi. Haydi namaza!',
        parseTime(prayerTime.dhuhr),
        payload: 'dhuhr');
    await schedule(21, 'Öğle Namazı Hatırlatıcısı',
        'Öğle vaktinin çıkmasına az kaldı, namazınızı kıldınız mı?',
        parseTime(prayerTime.dhuhr, addMinutes: 45),
        payload: 'dhuhr');

    // 3. İKİNDİ (Asr): Vakit (ID:30) + 45dk Hatırlatıcı (ID:31)
    await schedule(30, 'İkindi Vakti Girdi',
        'İkindi namazı vakti girdi. Haydi namaza!',
        parseTime(prayerTime.asr),
        payload: 'asr');
    await schedule(31, 'İkindi Namazı Hatırlatıcısı',
        'İkindi vaktinin çıkmasına az kaldı, namazınızı kıldınız mı?',
        parseTime(prayerTime.asr, addMinutes: 45),
        payload: 'asr');

    // 4. AKŞAM (Maghrib): Vakit (ID:40) + 45dk Hatırlatıcı (ID:41)
    await schedule(40, 'Akşam Vakti Girdi',
        'Akşam namazı vakti girdi. Haydi namaza!',
        parseTime(prayerTime.maghrib),
        payload: 'maghrib');
    await schedule(41, 'Akşam Namazı Hatırlatıcısı',
        'Akşam vaktinin çıkmasına az kaldı, namazınızı kıldınız mı?',
        parseTime(prayerTime.maghrib, addMinutes: 45),
        payload: 'maghrib');

    // 5. YATSI (Isha): Vakit (ID:50) + 1s Hatırlatıcı (ID:51) + 2s Hatırlatıcı (ID:52)
    await schedule(50, 'Yatsı Vakti Girdi',
        'Yatsı namazı vakti girdi. Haydi namaza!',
        parseTime(prayerTime.isha),
        payload: 'isha');
    await schedule(51, 'Yatsı Namazı Hatırlatıcısı',
        'Yatsı namazını eda etmeyi unutmayın.',
        parseTime(prayerTime.isha, addHours: 1),
        payload: 'isha');
    await schedule(52, 'Yatsı Namazı Son Hatırlatma',
        'Gece istirahatine çekilmeden önce yatsı namazınızı kıldınız mı?',
        parseTime(prayerTime.isha, addHours: 2),
        payload: 'isha');

    debugPrint('🔔 Toplam $scheduled bildirim zamanlandı.');
  }

  /// Kullanıcı "KILDIM" butonuna bastığında o vakte ait hatırlatıcıları iptal eder.
  Future<void> cancelPrayerReminders(String prayerTag) async {
    final idsToCancel = _reminderIds[prayerTag];
    if (idsToCancel != null) {
      for (final id in idsToCancel) {
        await _notificationsPlugin.cancel(id);
        debugPrint('🚫 Bildirim iptal edildi: ID=$id ($prayerTag)');
      }
    }
  }

  /// Tüm zamanlanmış bildirimleri iptal eder.
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  /// GÖREV 1: Zaman Makinesi (Hızlı Test) Fonksiyonu.
  /// 1. Tüm eski bildirimleri temizler.
  /// 2. Tam 15 saniye sonrasına zonedSchedule ile test bildirimi kurar.
  Future<void> scheduleQuickTestNotification() async {
    await cancelAllNotifications();

    final scheduledTime = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 15));
    debugPrint('⏰ Hızlı Test Bildirimi Kuruluyor (15 sn sonra): $scheduledTime');

    final androidDetails = AndroidNotificationDetails(
      'prayer_times_channel',
      'Namaz Vakitleri & Hatırlatıcılar',
      channelDescription: 'Ezan vakitleri ve akıllı namaz hatırlatıcı bildirimleri',
      icon: '@drawable/ic_notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      interruptionLevel: InterruptionLevel.critical,
    );

    await _notificationsPlugin.zonedSchedule(
      999,
      '🔔 Test Vakti Girdi',
      '15 saniyelik zaman makinesi testi başarıyla çalıştı! Zamanlanmış alarmlar aktif.',
      scheduledTime,
      NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint('✅ [ID:999] Hızlı test bildirimi 15 sn sonrasına kuruldu.');
  }

  /// GÖREV 3: Anında test bildirimi — zonedSchedule kullanmaz, direkt show() ile.
  /// Bildirim altyapısının çalışıp çalışmadığını izole etmek için kullan.
  Future<void> showTestNotification() async {
    final androidDetails = AndroidNotificationDetails(
      'prayer_times_channel',
      'Namaz Vakitleri & Hatırlatıcılar',
      channelDescription: 'Ezan vakitleri ve akıllı namaz hatırlatıcı bildirimleri',
      icon: '@drawable/ic_notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
    );

    const iosDetails = DarwinNotificationDetails(
      interruptionLevel: InterruptionLevel.critical,
    );

    await _notificationsPlugin.show(
      999,
      '🔔 Bildirim Testi',
      'Bu bildirim altyapısının çalıştığını doğrular. Bildirimleri aldıysanız sistem hazır!',
      NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
    debugPrint('🔔 Test bildirimi gönderildi (ID:999)');
  }
}
