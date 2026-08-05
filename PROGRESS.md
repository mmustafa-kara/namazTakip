# Ezan Vakti Pro - Geliştirme Süreci ve Faz Planı (PROGRESS.md)

Bu dosya, "Ezan Vakti Pro" uygulamasının geliştirme aşamalarını, tamamlanan ve bekleyen görevleri takip etmek için kullanılacaktır. Proje, yapay zeka destekli geliştirme (vibe coding) prensiplerine uygun olarak modüler fazlara ayrılmıştır.

## 🎯 Proje Özeti
*   **Teknoloji:** Flutter
*   **Mimari:** MVVM (Model-View-ViewModel) / State Management
*   **Tasarım Dili:** Özel tasarım (Vibe coding sıradanlığından uzak), Flat Premium dokunuşları, 1px zarif çerçeveler, gölgesiz modern kartlar (Performans için Glassmorphism'den vazgeçildi).
*   **Renk Paleti:** Premium Yeşil (Dark mode: Antrasit üzeri Zümrüt/Nane, Light mode: Kırık beyaz üzeri Adaçayı/Orman Yeşili).
*   **Tipografi:** Outfit ve Inter (Sistem fontları kullanılmayacak).
*   **Temel Servisler:** Aladhan API (Aylık veri çekimi), Hive/Isar (Yerel Veritabanı), Geolocator, Flutter Compass, Local Notifications.

---

## 🚀 FAZ 1: Proje Kurulumu ve Klasör Mimarisi ✅
- [x] Flutter projesinin oluşturulması.
- [x] Temel bağımlılıkların (dependencies) `pubspec.yaml` dosyasına eklenmesi (State management, HTTP, Hive, Geolocator, Compass, Notifications, Fontlar).
- [x] Proje klasör yapısının MVVM'e göre düzenlenmesi (`/core`, `/models`, `/views`, `/viewmodels`, `/services`, `/utils`).
- [x] Font dosyalarının (Google Fonts: Outfit + Inter) projeye dahil edilmesi.

## 🎨 FAZ 2: Tema ve UI/UX Sisteminin İnşası (Flat Premium) ✅
*(Not: Standart Material bileşenleri veya performans düşüren Glassmorphism yerine tamamen özelleştirilmiş Flat Premium widget'lar yazılacaktır.)*
- [x] Renk paleti sabitlerinin (`constants/colors.dart`) tanımlanması (Açık ve Koyu tema varyasyonları).
- [x] Özel tipografi sınıfının (`constants/typography.dart`) oluşturulması.
- [x] Dark Mode ve Light Mode geçiş mantığının (ThemeMode) ayarlanması.
- [x] Tekrar kullanılabilir UI bileşenlerinin (Özel butonlar, Flat Premium Prayer Card, Timer, BottomNavigationBar) kodlanması.

## 💾 FAZ 3: Veri Katmanı ve API Entegrasyonu ✅
- [x] Aladhan API'den dönecek JSON verisine uygun Model sınıflarının yazılması.
- [x] HTTP isteklerini atacak ve sadece aylık takvimi çekecek `ApiService` sınıfının yazılması.
- [x] Çekilen vakitleri internet olmadan da kullanabilmek için Hive/Isar ile `LocalDatabaseService` kurulumu.
- [x] Geolocator ile cihazın anlık konumunu (Enlem/Boylam) alıp API'ye besleyecek mantığın kurulması.

## ⏱️ FAZ 4: Ana Sayfa (Dashboard) ve Zamanlayıcı Mantığı ✅
- [x] Ana sayfa UI tasarımının koda dökülmesi.
- [x] Günlük 6 vaktin (İmsak, Güneş, Öğle, İkindi, Akşam, Yatsı) listeleneceği yatay/dikey kartların oluşturulması.
- [x] O anki vaktin hesaplanıp UI üzerinde vurgulanması (Highlight).
- [x] Bir sonraki vakte kalan süreyi hesaplayan ve saniye saniye güncellenen dinamik geri sayım sayacının (Timer) ViewModel içerisine yazılması.

## 🧭 FAZ 5: Sensörler ve Kıble Pusulası Modülü ✅
- [x] Pusula sekmesinin arayüzünün (karanlık, minimalist kadran) kodlanması.
- [x] `flutter_compass` paketi ile manyetometre ve jiroskop verilerinin dinlenmesi.
- [x] Cihazın konumuna göre Kabe'nin açısının hesaplanması ve ibrenin bu açıya göre animasyonlu döndürülmesi.
- [x] Hedef açıya ulaşıldığında Haptic Feedback (titreşim) tetiklenmesi.

## 🔔 FAZ 6: Arka Plan İşlemleri ve Bildirimler ✅
- [x] `flutter_local_notifications` paketinin temel konfigürasyonunun (Android/iOS izinleri, etkleşimli KILDIM butonu) yapılması.
- [x] Veritabanındaki namaz vakitlerine göre ileri tarihli zamanlanmış bildirimlerin (Scheduled Notifications) ayarlanması.
- [x] Ayarlar sekmesi UI'ının yapılması (Bildirim sesi seçimi, kerahet vakti uyarısı, konum güncelleme tercihleri).

## 📿 FAZ 7: Zikir ve Kaza Takip (Kişisel Modül) ✅
- [x] Zikirmatik sayfasının UI kodlaması (Büyük dairesel interaktif buton, resetleme seçenekleri).
- [x] Kaza namazı ve orucu takip listesinin UI kodlaması (+/- butonları ile interaktif liste).
- [x] Zikir ve kaza sayılarının yerel veritabanına (SharedPreferences/Hive) anlık kaydedilmesi ve okunması.

## 📦 FAZ 8: Test, Hata Ayıklama ve Yayın Hazırlığı
- [ ] Uygulama ikonunun tasarlanıp entegre edilmesi.
- [ ] Android ve iOS tarafında native izinlerin (Konum, Bildirim) son testlerinin yapılması.
- [ ] Release APK / AppBundle çıktısının alınması.