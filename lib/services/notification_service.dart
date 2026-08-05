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
/// Namaz vakitleri ve akıllı hatırlatıcı bildirimlerini yönetir.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  static const String actionKildimId = 'ACTION_KILDIM';
  static const String notificationCategoryKey = 'PRAYER_NOTIFICATION_CATEGORY';

  /// Her vakit için tanımlanmış hatırlatıcı bildirim ID'leri
  static const Map<String, List<int>> _reminderIds = {
    'fajr': [101],
    'dhuhr': [201],
    'asr': [301],
    'maghrib': [401],
    'isha': [501, 502],
  };

  /// Servisi, yerel saat dilimini (TimeZone) ve hassas alarm (Exact Alarm) izinlerini başlatır.
  Future<void> init() async {
    tz.initializeTimeZones();
    try {
      final String timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (_) {
      // Fallback varsayılan saat dilimi
      tz.setLocalLocation(tz.getLocation('Europe/Istanbul'));
    }

    // Android Başlatma Ayarları
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS Başlatma Ayarları (KILDIM Etkileşimli Butonu)
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

    final initSettings = InitializationSettings(
      android: androidInit,
      iOS: darwinInit,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.actionId == actionKildimId && response.payload != null) {
          cancelPrayerReminders(response.payload!);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // Android 12+ (API 31+) cihazlarda Exact Alarm iznini init'te DEĞİL,
    // konum izni sonuçlandıktan sonra ayrı çağıracağız (izin çakışmasını önlemek için).
  }

  /// Konum izni sonuçlandıktan SONRA çağrılmalıdır.
  /// Exact Alarm ve Bildirim izinlerini sıralı olarak ister.
  Future<void> requestAllPermissions() async {
    final androidImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
      await androidImplementation.requestExactAlarmsPermission();
    }

    final iosImplementation =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }




  /// Namaz vakitlerine göre zamanlanmış bildirimleri ve hatırlatıcıları kurar.
  Future<void> schedulePrayerNotifications(PrayerTime prayerTime) async {
    await cancelAllNotifications();

    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime parseTime(String timeStr, {int addMinutes = 0, int addHours = 0}) {
      final parts = timeStr.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      var dt = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        minute,
      );

      if (addMinutes != 0 || addHours != 0) {
        dt = dt.add(Duration(hours: addHours, minutes: addMinutes));
      }

      return dt;
    }

    final androidDetails = AndroidNotificationDetails(
      'prayer_times_channel',
      'Namaz Vakitleri & Hatırlatıcılar',
      channelDescription: 'Ezan vakitleri ve akıllı namaz hatırlatıcı bildirimleri',
      importance: Importance.max,
      priority: Priority.high,
      actions: const [
        AndroidNotificationAction(
          actionKildimId,
          'KILDIM',
          showsUserInterface: true,
        ),
      ],
    );

    const iosDetails = DarwinNotificationDetails(
      categoryIdentifier: notificationCategoryKey,
    );

    final notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 1. ÖĞLE (Dhuhr): Vakit (ID 200) + 45dk Hatırlatıcı (ID 201)
    final dhuhrTime = parseTime(prayerTime.dhuhr);
    if (dhuhrTime.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        200,
        'Öğle Vakti Girdi',
        'Öğle namazı vakti girdi. Haydi namaza!',
        dhuhrTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'dhuhr',
      );
    }

    final dhuhrReminder = parseTime(prayerTime.dhuhr, addMinutes: 45);
    if (dhuhrReminder.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        201,
        'Öğle Namazı Hatırlatıcısı',
        'Öğle vaktinin çıkmasına az kaldı, namazınızı kıldınız mı?',
        dhuhrReminder,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'dhuhr',
      );
    }

    // 2. İKİNDİ (Asr): Vakit (ID 300) + 45dk Hatırlatıcı (ID 301)
    final asrTime = parseTime(prayerTime.asr);
    if (asrTime.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        300,
        'İkindi Vakti Girdi',
        'İkindi namazı vakti girdi. Haydi namaza!',
        asrTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'asr',
      );
    }

    final asrReminder = parseTime(prayerTime.asr, addMinutes: 45);
    if (asrReminder.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        301,
        'İkindi Namazı Hatırlatıcısı',
        'İkindi vaktinin çıkmasına az kaldı, namazınızı kıldınız mı?',
        asrReminder,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'asr',
      );
    }

    // 3. AKŞAM (Maghrib): Vakit (ID 400) + 45dk Hatırlatıcı (ID 401)
    final maghribTime = parseTime(prayerTime.maghrib);
    if (maghribTime.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        400,
        'Akşam Vakti Girdi',
        'Akşam namazı vakti girdi. Haydi namaza!',
        maghribTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'maghrib',
      );
    }

    final maghribReminder = parseTime(prayerTime.maghrib, addMinutes: 45);
    if (maghribReminder.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        401,
        'Akşam Namazı Hatırlatıcısı',
        'Akşam vaktinin çıkmasına az kaldı, namazınızı kıldınız mı?',
        maghribReminder,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'maghrib',
      );
    }

    // 4. YATSI (Isha): Vakit (ID 500) + 1.saat Hatırlatıcı (ID 501) + 2.saat Hatırlatıcı (ID 502)
    final ishaTime = parseTime(prayerTime.isha);
    if (ishaTime.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        500,
        'Yatsı Vakti Girdi',
        'Yatsı namazı vakti girdi. Haydi namaza!',
        ishaTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'isha',
      );
    }

    final ishaReminder1 = parseTime(prayerTime.isha, addHours: 1);
    if (ishaReminder1.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        501,
        'Yatsı Namazı Hatırlatıcısı',
        'Yatsı namazını eda etmeyi unutmayın.',
        ishaReminder1,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'isha',
      );
    }

    final ishaReminder2 = parseTime(prayerTime.isha, addHours: 2);
    if (ishaReminder2.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        502,
        'Yatsı Namazı Son Hatırlatma',
        'Gece istirahatine çekilmeden önce yatsı namazınızı kıldınız mı?',
        ishaReminder2,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'isha',
      );
    }

    // 5. SABAH (Fajr / Sunrise): Güneş'e 30dk kala Daralan Vakit Uyarısı (ID 101)
    final sunriseTime = parseTime(prayerTime.sunrise, addMinutes: -30);
    if (sunriseTime.isAfter(now)) {
      await _notificationsPlugin.zonedSchedule(
        101,
        'Sabah Namazı - Daralan Vakit',
        'Güneşin doğuşuna 30 dakika kaldı! Sabah namazını eda etmeyi unutmayın.',
        sunriseTime,
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'fajr',
      );
    }
  }

  /// Kullanıcı "KILDIM" butonuna bastığında çağrılır.
  /// O vakte ait bekleyen (pending) hatırlatıcı bildirimlerini iptal eder.
  Future<void> cancelPrayerReminders(String prayerTag) async {
    final idsToCancel = _reminderIds[prayerTag];
    if (idsToCancel != null) {
      for (final id in idsToCancel) {
        await _notificationsPlugin.cancel(id);
      }
    }
  }

  /// Tüm zamanlanmış bildirimleri iptal eder.
  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
