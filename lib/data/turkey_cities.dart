// Türkiye İl ve İlçe Koordinat Veri Seti.
// Ezan Vakti Pro — Manuel Konum Seçimi (Override) için çevrimdışı (offline) veri kaynağı.

class CityDistrict {
  final String name;
  final double latitude;
  final double longitude;

  const CityDistrict({
    required this.name,
    required this.latitude,
    required this.longitude,
  });
}

class TurkeyCity {
  final String name;
  final double latitude;
  final double longitude;
  final List<CityDistrict> districts;

  const TurkeyCity({
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.districts,
  });
}

/// Türkiye 81 İl ve Popüler İlçeleri
abstract class TurkeyCitiesData {
  static const List<TurkeyCity> cities = [
    TurkeyCity(
      name: 'Adana',
      latitude: 37.0000,
      longitude: 35.3213,
      districts: [
        CityDistrict(name: 'Seyhan', latitude: 36.9914, longitude: 35.3308),
        CityDistrict(name: 'Çukurova', latitude: 37.0560, longitude: 35.2630),
        CityDistrict(name: 'Yüreğir', latitude: 36.9833, longitude: 35.3500),
        CityDistrict(name: 'Ceyhan', latitude: 37.0247, longitude: 35.8175),
        CityDistrict(name: 'Kozan', latitude: 37.4553, longitude: 35.8158),
      ],
    ),
    TurkeyCity(
      name: 'Adıyaman',
      latitude: 37.7648,
      longitude: 37.7644,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 37.7648, longitude: 37.7644),
        CityDistrict(name: 'Besni', latitude: 37.6922, longitude: 37.8606),
        CityDistrict(name: 'Kahta', latitude: 37.7842, longitude: 38.6275),
        CityDistrict(name: 'Gölbaşı', latitude: 37.7844, longitude: 37.6347),
      ],
    ),
    TurkeyCity(
      name: 'Afyonkarahisar',
      latitude: 38.7507,
      longitude: 30.5567,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 38.7507, longitude: 30.5567),
        CityDistrict(name: 'Sandıklı', latitude: 38.4625, longitude: 30.2694),
        CityDistrict(name: 'Dinar', latitude: 38.0653, longitude: 30.1656),
        CityDistrict(name: 'Bolvadin', latitude: 38.7119, longitude: 31.0483),
      ],
    ),
    TurkeyCity(
      name: 'Ağrı',
      latitude: 39.7191,
      longitude: 43.0503,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 39.7191, longitude: 43.0503),
        CityDistrict(name: 'Doğubayazıt', latitude: 39.5461, longitude: 44.0839),
        CityDistrict(name: 'Patnos', latitude: 39.2336, longitude: 42.8589),
      ],
    ),
    TurkeyCity(
      name: 'Amasya',
      latitude: 40.6499,
      longitude: 35.8353,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.6499, longitude: 35.8353),
        CityDistrict(name: 'Merzifon', latitude: 40.8731, longitude: 35.4611),
        CityDistrict(name: 'Suluova', latitude: 40.8358, longitude: 35.6558),
      ],
    ),
    TurkeyCity(
      name: 'Ankara',
      latitude: 39.9334,
      longitude: 32.8597,
      districts: [
        CityDistrict(name: 'Çankaya', latitude: 39.9081, longitude: 32.8639),
        CityDistrict(name: 'Keçiören', latitude: 39.9861, longitude: 32.8631),
        CityDistrict(name: 'Yenimahalle', latitude: 39.9678, longitude: 32.8117),
        CityDistrict(name: 'Mamak', latitude: 39.9286, longitude: 32.9097),
        CityDistrict(name: 'Etimesgut', latitude: 39.9483, longitude: 32.6681),
        CityDistrict(name: 'Sincan', latitude: 39.9575, longitude: 32.5767),
        CityDistrict(name: 'Altındağ', latitude: 39.9419, longitude: 32.8650),
        CityDistrict(name: 'Gölbaşı', latitude: 39.7958, longitude: 32.8089),
        CityDistrict(name: 'Polatlı', latitude: 39.5858, longitude: 32.1469),
      ],
    ),
    TurkeyCity(
      name: 'Antalya',
      latitude: 36.8969,
      longitude: 30.7133,
      districts: [
        CityDistrict(name: 'Muratpaşa', latitude: 36.8853, longitude: 30.7075),
        CityDistrict(name: 'Kepez', latitude: 36.9381, longitude: 30.6869),
        CityDistrict(name: 'Konyaaltı', latitude: 36.8778, longitude: 30.6358),
        CityDistrict(name: 'Alanya', latitude: 36.5438, longitude: 31.9998),
        CityDistrict(name: 'Manavgat', latitude: 36.7867, longitude: 31.4422),
        CityDistrict(name: 'Serik', latitude: 36.9169, longitude: 31.0989),
        CityDistrict(name: 'Kemer', latitude: 36.5986, longitude: 30.5594),
        CityDistrict(name: 'Kaş', latitude: 36.2000, longitude: 29.6389),
      ],
    ),
    TurkeyCity(
      name: 'Artvin',
      latitude: 41.1828,
      longitude: 41.8183,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 41.1828, longitude: 41.8183),
        CityDistrict(name: 'Hopa', latitude: 41.4056, longitude: 41.4319),
        CityDistrict(name: 'Borçka', latitude: 41.3583, longitude: 41.6806),
      ],
    ),
    TurkeyCity(
      name: 'Aydın',
      latitude: 37.8560,
      longitude: 27.8416,
      districts: [
        CityDistrict(name: 'Efeler (Merkez)', latitude: 37.8444, longitude: 27.8458),
        CityDistrict(name: 'Nazilli', latitude: 37.9136, longitude: 28.3244),
        CityDistrict(name: 'Söke', latitude: 37.7511, longitude: 27.4042),
        CityDistrict(name: 'Kuşadası', latitude: 37.8578, longitude: 27.2611),
        CityDistrict(name: 'Didim', latitude: 37.3750, longitude: 27.2583),
      ],
    ),
    TurkeyCity(
      name: 'Balıkesir',
      latitude: 39.6484,
      longitude: 27.8826,
      districts: [
        CityDistrict(name: 'Karesi (Merkez)', latitude: 39.6542, longitude: 27.8847),
        CityDistrict(name: 'Altıeylül', latitude: 39.6431, longitude: 27.8764),
        CityDistrict(name: 'Bandırma', latitude: 40.3542, longitude: 27.9769),
        CityDistrict(name: 'Edremit', latitude: 39.5961, longitude: 27.0244),
        CityDistrict(name: 'Ayvalık', latitude: 39.3194, longitude: 26.6944),
        CityDistrict(name: 'Gönen', latitude: 40.1042, longitude: 27.6539),
      ],
    ),
    TurkeyCity(
      name: 'Bilecik',
      latitude: 40.1506,
      longitude: 29.9792,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.1506, longitude: 29.9792),
        CityDistrict(name: 'Bozüyük', latitude: 39.9078, longitude: 30.0433),
      ],
    ),
    TurkeyCity(
      name: 'Bingöl',
      latitude: 38.8854,
      longitude: 40.4980,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 38.8854, longitude: 40.4980),
        CityDistrict(name: 'Genç', latitude: 38.7486, longitude: 40.5608),
      ],
    ),
    TurkeyCity(
      name: 'Bitlis',
      latitude: 38.4006,
      longitude: 42.1095,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 38.4006, longitude: 42.1095),
        CityDistrict(name: 'Tatvan', latitude: 38.5086, longitude: 42.2828),
        CityDistrict(name: 'Ahlat', latitude: 38.7511, longitude: 42.4939),
      ],
    ),
    TurkeyCity(
      name: 'Bolu',
      latitude: 40.7358,
      longitude: 31.6061,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.7358, longitude: 31.6061),
        CityDistrict(name: 'Gerede', latitude: 40.8011, longitude: 32.1978),
      ],
    ),
    TurkeyCity(
      name: 'Burdur',
      latitude: 37.7203,
      longitude: 30.2908,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 37.7203, longitude: 30.2908),
        CityDistrict(name: 'Bucak', latitude: 37.4597, longitude: 30.5950),
      ],
    ),
    TurkeyCity(
      name: 'Bursa',
      latitude: 40.1885,
      longitude: 29.0610,
      districts: [
        CityDistrict(name: 'İnegöl', latitude: 40.0781, longitude: 29.5133),
        CityDistrict(name: 'Osmangazi', latitude: 40.1931, longitude: 29.0628),
        CityDistrict(name: 'Nilüfer', latitude: 40.2189, longitude: 28.9839),
        CityDistrict(name: 'Yıldırım', latitude: 40.1833, longitude: 29.1000),
        CityDistrict(name: 'Gemlik', latitude: 40.4319, longitude: 29.1558),
        CityDistrict(name: 'Mudanya', latitude: 40.3753, longitude: 28.8822),
        CityDistrict(name: 'Mustafakemalpaşa', latitude: 40.0353, longitude: 28.4117),
        CityDistrict(name: 'Karacabey', latitude: 40.2139, longitude: 28.3581),
        CityDistrict(name: 'Orhangazi', latitude: 40.4889, longitude: 29.3094),
      ],
    ),
    TurkeyCity(
      name: 'Çanakkale',
      latitude: 40.1553,
      longitude: 26.4142,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.1553, longitude: 26.4142),
        CityDistrict(name: 'Biga', latitude: 40.2283, longitude: 27.2425),
        CityDistrict(name: 'Gelibolu', latitude: 40.4103, longitude: 26.6706),
        CityDistrict(name: 'Çan', latitude: 40.0333, longitude: 27.0500),
      ],
    ),
    TurkeyCity(
      name: 'Çankırı',
      latitude: 40.6013,
      longitude: 33.6134,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.6013, longitude: 33.6134),
      ],
    ),
    TurkeyCity(
      name: 'Çorum',
      latitude: 40.5506,
      longitude: 34.9556,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.5506, longitude: 34.9556),
        CityDistrict(name: 'Sungurlu', latitude: 40.1667, longitude: 34.3750),
        CityDistrict(name: 'Osmancık', latitude: 40.9708, longitude: 34.8058),
      ],
    ),
    TurkeyCity(
      name: 'Denizli',
      latitude: 37.7765,
      longitude: 29.0864,
      districts: [
        CityDistrict(name: 'Pamukkale', latitude: 37.7833, longitude: 29.0944),
        CityDistrict(name: 'Merkezefendi', latitude: 37.7722, longitude: 29.0833),
        CityDistrict(name: 'Çivril', latitude: 38.2581, longitude: 29.7369),
        CityDistrict(name: 'Acıpayam', latitude: 37.4253, longitude: 29.3517),
      ],
    ),
    TurkeyCity(
      name: 'Diyarbakır',
      latitude: 37.9144,
      longitude: 40.2306,
      districts: [
        CityDistrict(name: 'Kayapınar', latitude: 37.9333, longitude: 40.1833),
        CityDistrict(name: 'Bağlar', latitude: 37.9000, longitude: 40.2000),
        CityDistrict(name: 'Yenişehir', latitude: 37.9250, longitude: 40.2167),
        CityDistrict(name: 'Sur', latitude: 37.9139, longitude: 40.2361),
        CityDistrict(name: 'Ergani', latitude: 37.9258, longitude: 39.7619),
        CityDistrict(name: 'Bismil', latitude: 37.8483, longitude: 40.6653),
      ],
    ),
    TurkeyCity(
      name: 'Edirne',
      latitude: 41.6768,
      longitude: 26.5607,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 41.6768, longitude: 26.5607),
        CityDistrict(name: 'Keşan', latitude: 40.8539, longitude: 26.6322),
        CityDistrict(name: 'Uzunköprü', latitude: 41.2681, longitude: 26.6853),
      ],
    ),
    TurkeyCity(
      name: 'Elazığ',
      latitude: 38.6810,
      longitude: 39.2264,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 38.6810, longitude: 39.2264),
        CityDistrict(name: 'Karakoçan', latitude: 38.9556, longitude: 40.0417),
        CityDistrict(name: 'Kovancılar', latitude: 38.7183, longitude: 39.8569),
      ],
    ),
    TurkeyCity(
      name: 'Erzincan',
      latitude: 39.7500,
      longitude: 39.5000,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 39.7500, longitude: 39.5000),
      ],
    ),
    TurkeyCity(
      name: 'Erzurum',
      latitude: 39.9043,
      longitude: 41.2679,
      districts: [
        CityDistrict(name: 'Yakutiye', latitude: 39.9056, longitude: 41.2722),
        CityDistrict(name: 'Palandöken', latitude: 39.8800, longitude: 41.2600),
        CityDistrict(name: 'Aziziye', latitude: 39.9333, longitude: 41.1333),
        CityDistrict(name: 'Oltu', latitude: 40.5486, longitude: 41.9961),
      ],
    ),
    TurkeyCity(
      name: 'Eskişehir',
      latitude: 39.7667,
      longitude: 30.5256,
      districts: [
        CityDistrict(name: 'Odunpazarı', latitude: 39.7583, longitude: 30.5278),
        CityDistrict(name: 'Tepebaşı', latitude: 39.7833, longitude: 30.5167),
        CityDistrict(name: 'Sivrihisar', latitude: 39.3908, longitude: 31.5369),
      ],
    ),
    TurkeyCity(
      name: 'Gaziantep',
      latitude: 37.0662,
      longitude: 37.3833,
      districts: [
        CityDistrict(name: 'Şahinbey', latitude: 37.0500, longitude: 37.3667),
        CityDistrict(name: 'Şehitkamil', latitude: 37.0833, longitude: 37.3833),
        CityDistrict(name: 'Nizip', latitude: 37.0097, longitude: 37.7944),
      ],
    ),
    TurkeyCity(
      name: 'Giresun',
      latitude: 40.9128,
      longitude: 38.3895,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.9128, longitude: 38.3895),
        CityDistrict(name: 'Bulancak', latitude: 40.9381, longitude: 38.2311),
        CityDistrict(name: 'Görele', latitude: 41.0319, longitude: 39.0386),
      ],
    ),
    TurkeyCity(
      name: 'Gümüşhane',
      latitude: 40.4603,
      longitude: 39.4814,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.4603, longitude: 39.4814),
        CityDistrict(name: 'Kelkit', latitude: 40.1281, longitude: 39.4319),
      ],
    ),
    TurkeyCity(
      name: 'Hakkari',
      latitude: 37.5833,
      longitude: 43.7333,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 37.5833, longitude: 43.7333),
        CityDistrict(name: 'Yüksekova', latitude: 37.5739, longitude: 44.2869),
      ],
    ),
    TurkeyCity(
      name: 'Hatay',
      latitude: 36.4018,
      longitude: 36.3498,
      districts: [
        CityDistrict(name: 'Antakya', latitude: 36.2066, longitude: 36.1572),
        CityDistrict(name: 'İskenderun', latitude: 36.5872, longitude: 36.1733),
        CityDistrict(name: 'Defne', latitude: 36.1700, longitude: 36.1400),
        CityDistrict(name: 'Dörtyol', latitude: 36.8394, longitude: 36.2239),
        CityDistrict(name: 'Samandağ', latitude: 36.0847, longitude: 35.9814),
      ],
    ),
    TurkeyCity(
      name: 'Isparta',
      latitude: 37.7648,
      longitude: 30.5566,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 37.7648, longitude: 30.5566),
        CityDistrict(name: 'Yalvaç', latitude: 38.2947, longitude: 31.1764),
        CityDistrict(name: 'Eğirdir', latitude: 37.8761, longitude: 30.8500),
      ],
    ),
    TurkeyCity(
      name: 'Mersin',
      latitude: 36.8000,
      longitude: 34.6333,
      districts: [
        CityDistrict(name: 'Yenişehir', latitude: 36.7917, longitude: 34.5806),
        CityDistrict(name: 'Toroslar', latitude: 36.8333, longitude: 34.6167),
        CityDistrict(name: 'Akdeniz', latitude: 36.8000, longitude: 34.6333),
        CityDistrict(name: 'Mezitli', latitude: 36.7583, longitude: 34.5361),
        CityDistrict(name: 'Tarsus', latitude: 36.9167, longitude: 34.8944),
        CityDistrict(name: 'Erdemli', latitude: 36.6050, longitude: 34.3072),
        CityDistrict(name: 'Silifke', latitude: 36.3778, longitude: 33.9344),
      ],
    ),
    TurkeyCity(
      name: 'İstanbul',
      latitude: 41.0082,
      longitude: 28.9784,
      districts: [
        CityDistrict(name: 'Fatih', latitude: 41.0186, longitude: 28.9397),
        CityDistrict(name: 'Kadıköy', latitude: 40.9903, longitude: 29.0292),
        CityDistrict(name: 'Üsküdar', latitude: 41.0267, longitude: 29.0153),
        CityDistrict(name: 'Beşiktaş', latitude: 41.0422, longitude: 29.0067),
        CityDistrict(name: 'Beyoğlu', latitude: 41.0369, longitude: 28.9775),
        CityDistrict(name: 'Şişli', latitude: 41.0600, longitude: 28.9872),
        CityDistrict(name: 'Ümraniye', latitude: 41.0256, longitude: 29.0961),
        CityDistrict(name: 'Maltepe', latitude: 40.9242, longitude: 29.1317),
        CityDistrict(name: 'Pendik', latitude: 40.8767, longitude: 29.2333),
        CityDistrict(name: 'Kartal', latitude: 40.8886, longitude: 29.1856),
        CityDistrict(name: 'Bakırköy', latitude: 40.9803, longitude: 28.8722),
        CityDistrict(name: 'Avcılar', latitude: 40.9797, longitude: 28.7217),
        CityDistrict(name: 'Ataşehir', latitude: 40.9833, longitude: 29.1167),
        CityDistrict(name: 'Beylikdüzü', latitude: 40.9908, longitude: 28.6436),
        CityDistrict(name: 'Esenyurt', latitude: 41.0342, longitude: 28.6803),
        CityDistrict(name: 'Başakşehir', latitude: 41.1075, longitude: 28.8028),
        CityDistrict(name: 'Zeytinburnu', latitude: 40.9906, longitude: 28.9042),
        CityDistrict(name: 'Sarıyer', latitude: 41.1667, longitude: 29.0500),
      ],
    ),
    TurkeyCity(
      name: 'İzmir',
      latitude: 38.4192,
      longitude: 27.1287,
      districts: [
        CityDistrict(name: 'Konak', latitude: 38.4189, longitude: 27.1286),
        CityDistrict(name: 'Karşıyaka', latitude: 38.4606, longitude: 27.1147),
        CityDistrict(name: 'Bornova', latitude: 38.4639, longitude: 27.2181),
        CityDistrict(name: 'Buca', latitude: 38.3847, longitude: 27.1644),
        CityDistrict(name: 'Çiğli', latitude: 38.4864, longitude: 27.0864),
        CityDistrict(name: 'Gaziemir', latitude: 38.3183, longitude: 27.1325),
        CityDistrict(name: 'Torbalı', latitude: 38.1506, longitude: 27.3622),
        CityDistrict(name: 'Menemen', latitude: 38.6078, longitude: 27.0706),
        CityDistrict(name: 'Urla', latitude: 38.3236, longitude: 26.7642),
        CityDistrict(name: 'Çeşme', latitude: 38.3239, longitude: 26.3039),
      ],
    ),
    TurkeyCity(
      name: 'Kars',
      latitude: 40.6014,
      longitude: 43.0975,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.6014, longitude: 43.0975),
        CityDistrict(name: 'Sarıkamış', latitude: 40.3347, longitude: 42.5939),
      ],
    ),
    TurkeyCity(
      name: 'Kastamonu',
      latitude: 41.3887,
      longitude: 33.7827,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 41.3887, longitude: 33.7827),
        CityDistrict(name: 'Tosya', latitude: 41.0153, longitude: 34.0400),
        CityDistrict(name: 'Taşköprü', latitude: 41.5086, longitude: 34.2169),
      ],
    ),
    TurkeyCity(
      name: 'Kayseri',
      latitude: 38.7312,
      longitude: 35.4787,
      districts: [
        CityDistrict(name: 'Melikgazi', latitude: 38.7167, longitude: 35.5000),
        CityDistrict(name: 'Kocasinan', latitude: 38.7500, longitude: 35.4833),
        CityDistrict(name: 'Talas', latitude: 38.6908, longitude: 35.5539),
        CityDistrict(name: 'Develi', latitude: 38.3911, longitude: 35.4925),
      ],
    ),
    TurkeyCity(
      name: 'Kırklareli',
      latitude: 41.7333,
      longitude: 27.2167,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 41.7333, longitude: 27.2167),
        CityDistrict(name: 'Lüleburgaz', latitude: 41.4056, longitude: 27.3589),
        CityDistrict(name: 'Babaeski', latitude: 41.4328, longitude: 27.0944),
      ],
    ),
    TurkeyCity(
      name: 'Kırşehir',
      latitude: 39.1425,
      longitude: 34.1709,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 39.1425, longitude: 34.1709),
        CityDistrict(name: 'Kaman', latitude: 39.3564, longitude: 33.7233),
      ],
    ),
    TurkeyCity(
      name: 'Kocaeli',
      latitude: 40.7656,
      longitude: 29.9408,
      districts: [
        CityDistrict(name: 'İzmit', latitude: 40.7656, longitude: 29.9408),
        CityDistrict(name: 'Gebze', latitude: 40.8028, longitude: 29.4306),
        CityDistrict(name: 'Darıca', latitude: 40.7739, longitude: 29.4003),
        CityDistrict(name: 'Körfez', latitude: 40.7761, longitude: 29.7375),
        CityDistrict(name: 'Gölcük', latitude: 40.7181, longitude: 29.8258),
        CityDistrict(name: 'Derince', latitude: 40.7569, longitude: 29.8306),
        CityDistrict(name: 'Çayırova', latitude: 40.8144, longitude: 29.3736),
        CityDistrict(name: 'Kartepe', latitude: 40.7500, longitude: 30.0167),
      ],
    ),
    TurkeyCity(
      name: 'Konya',
      latitude: 37.8667,
      longitude: 32.4833,
      districts: [
        CityDistrict(name: 'Selçuklu', latitude: 37.8833, longitude: 32.4833),
        CityDistrict(name: 'Meram', latitude: 37.8500, longitude: 32.4333),
        CityDistrict(name: 'Karatay', latitude: 37.8667, longitude: 32.5167),
        CityDistrict(name: 'Ereğli', latitude: 37.5133, longitude: 34.0494),
        CityDistrict(name: 'Akşehir', latitude: 38.3575, longitude: 31.4164),
        CityDistrict(name: 'Seydişehir', latitude: 37.4194, longitude: 31.8469),
      ],
    ),
    TurkeyCity(
      name: 'Kütahya',
      latitude: 39.4167,
      longitude: 29.9833,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 39.4167, longitude: 29.9833),
        CityDistrict(name: 'Tavşanlı', latitude: 39.5447, longitude: 29.4939),
        CityDistrict(name: 'Simav', latitude: 39.0883, longitude: 28.9778),
      ],
    ),
    TurkeyCity(
      name: 'Malatya',
      latitude: 38.3552,
      longitude: 38.3095,
      districts: [
        CityDistrict(name: 'Battalgazi', latitude: 38.3500, longitude: 38.3333),
        CityDistrict(name: 'Yeşilyurt', latitude: 38.3000, longitude: 38.2500),
        CityDistrict(name: 'Doğanşehir', latitude: 38.0933, longitude: 37.8789),
      ],
    ),
    TurkeyCity(
      name: 'Manisa',
      latitude: 38.6191,
      longitude: 27.4289,
      districts: [
        CityDistrict(name: 'Yunusemre', latitude: 38.6250, longitude: 27.4167),
        CityDistrict(name: 'Şehzadeler', latitude: 38.6139, longitude: 27.4333),
        CityDistrict(name: 'Akhisar', latitude: 38.9222, longitude: 27.8417),
        CityDistrict(name: 'Turgutlu', latitude: 38.4964, longitude: 27.7019),
        CityDistrict(name: 'Salihli', latitude: 38.4814, longitude: 28.1369),
        CityDistrict(name: 'Soma', latitude: 39.1867, longitude: 27.6094),
      ],
    ),
    TurkeyCity(
      name: 'Kahramanmaraş',
      latitude: 37.5858,
      longitude: 36.9371,
      districts: [
        CityDistrict(name: 'Onikişubat', latitude: 37.6000, longitude: 36.9000),
        CityDistrict(name: 'Dulkadiroğlu', latitude: 37.5833, longitude: 36.9500),
        CityDistrict(name: 'Elbistan', latitude: 38.2047, longitude: 37.1953),
        CityDistrict(name: 'Afşin', latitude: 38.2467, longitude: 36.9142),
      ],
    ),
    TurkeyCity(
      name: 'Mardin',
      latitude: 37.3122,
      longitude: 40.7350,
      districts: [
        CityDistrict(name: 'Artuklu (Merkez)', latitude: 37.3122, longitude: 40.7350),
        CityDistrict(name: 'Kızıltepe', latitude: 37.1942, longitude: 40.5872),
        CityDistrict(name: 'Nusaybin', latitude: 37.0767, longitude: 41.2153),
        CityDistrict(name: 'Midyat', latitude: 37.4189, longitude: 41.3392),
      ],
    ),
    TurkeyCity(
      name: 'Muğla',
      latitude: 37.2153,
      longitude: 28.3636,
      districts: [
        CityDistrict(name: 'Menteşe (Merkez)', latitude: 37.2153, longitude: 28.3636),
        CityDistrict(name: 'Bodrum', latitude: 37.0383, longitude: 27.4292),
        CityDistrict(name: 'Fethiye', latitude: 36.6217, longitude: 29.1164),
        CityDistrict(name: 'Marmaris', latitude: 36.8550, longitude: 28.2742),
        CityDistrict(name: 'Milas', latitude: 37.3164, longitude: 27.7839),
        CityDistrict(name: 'Ortaca', latitude: 36.8389, longitude: 28.7667),
      ],
    ),
    TurkeyCity(
      name: 'Muş',
      latitude: 38.7431,
      longitude: 41.5064,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 38.7431, longitude: 41.5064),
        CityDistrict(name: 'Bulanık', latitude: 39.0964, longitude: 42.2683),
      ],
    ),
    TurkeyCity(
      name: 'Nevşehir',
      latitude: 38.6244,
      longitude: 34.7144,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 38.6244, longitude: 34.7144),
        CityDistrict(name: 'Ürgüp', latitude: 38.6300, longitude: 34.9125),
        CityDistrict(name: 'Avanos', latitude: 38.7161, longitude: 34.8456),
      ],
    ),
    TurkeyCity(
      name: 'Niğde',
      latitude: 37.9667,
      longitude: 34.6833,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 37.9667, longitude: 34.6833),
        CityDistrict(name: 'Bor', latitude: 37.8925, longitude: 34.5606),
      ],
    ),
    TurkeyCity(
      name: 'Ordu',
      latitude: 40.9833,
      longitude: 37.8833,
      districts: [
        CityDistrict(name: 'Altınordu (Merkez)', latitude: 40.9833, longitude: 37.8833),
        CityDistrict(name: 'Ünye', latitude: 41.1306, longitude: 37.2842),
        CityDistrict(name: 'Fatsa', latitude: 41.0319, longitude: 37.5019),
      ],
    ),
    TurkeyCity(
      name: 'Rize',
      latitude: 41.0208,
      longitude: 40.5219,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 41.0208, longitude: 40.5219),
        CityDistrict(name: 'Ardeşen', latitude: 41.1914, longitude: 40.9875),
        CityDistrict(name: 'Çayeli', latitude: 41.0911, longitude: 40.7275),
      ],
    ),
    TurkeyCity(
      name: 'Sakarya',
      latitude: 40.7569,
      longitude: 30.3783,
      districts: [
        CityDistrict(name: 'Adapazarı', latitude: 40.7769, longitude: 30.4000),
        CityDistrict(name: 'Serdivan', latitude: 40.7667, longitude: 30.3667),
        CityDistrict(name: 'Erenler', latitude: 40.7500, longitude: 30.4167),
        CityDistrict(name: 'Akyazı', latitude: 40.6864, longitude: 30.6231),
        CityDistrict(name: 'Hendek', latitude: 40.7981, longitude: 30.7483),
        CityDistrict(name: 'Karasu', latitude: 41.0706, longitude: 30.6908),
      ],
    ),
    TurkeyCity(
      name: 'Samsun',
      latitude: 41.2928,
      longitude: 36.3314,
      districts: [
        CityDistrict(name: 'Atakum', latitude: 41.3208, longitude: 36.2642),
        CityDistrict(name: 'İlkadım', latitude: 41.2858, longitude: 36.3347),
        CityDistrict(name: 'Canik', latitude: 41.2722, longitude: 36.3556),
        CityDistrict(name: 'Bafra', latitude: 41.5678, longitude: 35.9069),
        CityDistrict(name: 'Çarşamba', latitude: 41.1989, longitude: 36.7264),
      ],
    ),
    TurkeyCity(
      name: 'Siirt',
      latitude: 37.9333,
      longitude: 41.9500,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 37.9333, longitude: 41.9500),
        CityDistrict(name: 'Kurtalan', latitude: 37.9272, longitude: 41.7028),
      ],
    ),
    TurkeyCity(
      name: 'Sinop',
      latitude: 42.0231,
      longitude: 35.1531,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 42.0231, longitude: 35.1531),
        CityDistrict(name: 'Boyabat', latitude: 41.4681, longitude: 34.7669),
      ],
    ),
    TurkeyCity(
      name: 'Sivas',
      latitude: 39.7477,
      longitude: 37.0179,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 39.7477, longitude: 37.0179),
        CityDistrict(name: 'Şarkışla', latitude: 39.3517, longitude: 36.4111),
        CityDistrict(name: 'Suşehri', latitude: 40.1639, longitude: 38.0875),
      ],
    ),
    TurkeyCity(
      name: 'Tekirdağ',
      latitude: 40.9833,
      longitude: 27.5167,
      districts: [
        CityDistrict(name: 'Süleymanpaşa (Merkez)', latitude: 40.9781, longitude: 27.5117),
        CityDistrict(name: 'Çorlu', latitude: 41.1594, longitude: 27.8000),
        CityDistrict(name: 'Çerkezköy', latitude: 41.2861, longitude: 28.0014),
        CityDistrict(name: 'Kapaklı', latitude: 41.3197, longitude: 27.9786),
      ],
    ),
    TurkeyCity(
      name: 'Tokat',
      latitude: 40.3167,
      longitude: 36.5500,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.3167, longitude: 36.5500),
        CityDistrict(name: 'Erbaa', latitude: 40.6931, longitude: 36.5683),
        CityDistrict(name: 'Turhal', latitude: 40.3908, longitude: 36.0892),
        CityDistrict(name: 'Niksar', latitude: 40.5906, longitude: 36.9536),
      ],
    ),
    TurkeyCity(
      name: 'Trabzon',
      latitude: 41.0015,
      longitude: 39.7178,
      districts: [
        CityDistrict(name: 'Ortahisar (Merkez)', latitude: 41.0015, longitude: 39.7178),
        CityDistrict(name: 'Akçaabat', latitude: 41.0211, longitude: 39.5708),
        CityDistrict(name: 'Yomra', latitude: 40.9542, longitude: 39.8589),
        CityDistrict(name: 'Of', latitude: 40.9458, longitude: 40.2661),
      ],
    ),
    TurkeyCity(
      name: 'Tunceli',
      latitude: 39.1083,
      longitude: 39.5472,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 39.1083, longitude: 39.5472),
      ],
    ),
    TurkeyCity(
      name: 'Şanlıurfa',
      latitude: 37.1591,
      longitude: 38.7969,
      districts: [
        CityDistrict(name: 'Eyyübiye', latitude: 37.1400, longitude: 38.7900),
        CityDistrict(name: 'Haliliye', latitude: 37.1700, longitude: 38.8100),
        CityDistrict(name: 'Karaköprü', latitude: 37.2000, longitude: 38.7900),
        CityDistrict(name: 'Siverek', latitude: 37.7550, longitude: 39.3167),
        CityDistrict(name: 'Viranşehir', latitude: 37.2342, longitude: 39.7644),
      ],
    ),
    TurkeyCity(
      name: 'Uşak',
      latitude: 38.6822,
      longitude: 29.4082,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 38.6822, longitude: 29.4082),
        CityDistrict(name: 'Banaz', latitude: 38.7369, longitude: 29.7608),
      ],
    ),
    TurkeyCity(
      name: 'Van',
      latitude: 38.4891,
      longitude: 43.4089,
      districts: [
        CityDistrict(name: 'İpekyolu', latitude: 38.5000, longitude: 43.3833),
        CityDistrict(name: 'Tuşba', latitude: 38.5500, longitude: 43.3667),
        CityDistrict(name: 'Edremit', latitude: 38.4167, longitude: 43.2500),
        CityDistrict(name: 'Erciş', latitude: 39.0278, longitude: 43.3603),
      ],
    ),
    TurkeyCity(
      name: 'Yozgat',
      latitude: 39.8181,
      longitude: 34.8147,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 39.8181, longitude: 34.8147),
        CityDistrict(name: 'Sorgun', latitude: 39.8106, longitude: 35.1856),
      ],
    ),
    TurkeyCity(
      name: 'Zonguldak',
      latitude: 41.4564,
      longitude: 31.7987,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 41.4564, longitude: 31.7987),
        CityDistrict(name: 'Ereğli', latitude: 41.2828, longitude: 31.4164),
        CityDistrict(name: 'Çaycuma', latitude: 41.4239, longitude: 32.0786),
      ],
    ),
    TurkeyCity(
      name: 'Aksaray',
      latitude: 38.3687,
      longitude: 34.0370,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 38.3687, longitude: 34.0370),
      ],
    ),
    TurkeyCity(
      name: 'Bayburt',
      latitude: 40.2552,
      longitude: 40.2249,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.2552, longitude: 40.2249),
      ],
    ),
    TurkeyCity(
      name: 'Karaman',
      latitude: 37.1759,
      longitude: 33.2287,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 37.1759, longitude: 33.2287),
      ],
    ),
    TurkeyCity(
      name: 'Kırıkkale',
      latitude: 39.8468,
      longitude: 33.5153,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 39.8468, longitude: 33.5153),
      ],
    ),
    TurkeyCity(
      name: 'Batman',
      latitude: 37.8812,
      longitude: 41.1351,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 37.8812, longitude: 41.1351),
      ],
    ),
    TurkeyCity(
      name: 'Şırnak',
      latitude: 37.5164,
      longitude: 42.4611,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 37.5164, longitude: 42.4611),
        CityDistrict(name: 'Cizre', latitude: 37.3278, longitude: 42.1903),
        CityDistrict(name: 'Silopi', latitude: 37.2483, longitude: 42.4689),
      ],
    ),
    TurkeyCity(
      name: 'Bartın',
      latitude: 41.6358,
      longitude: 32.3375,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 41.6358, longitude: 32.3375),
      ],
    ),
    TurkeyCity(
      name: 'Ardahan',
      latitude: 41.1105,
      longitude: 42.7022,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 41.1105, longitude: 42.7022),
      ],
    ),
    TurkeyCity(
      name: 'Iğdır',
      latitude: 39.9167,
      longitude: 44.0333,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 39.9167, longitude: 44.0333),
      ],
    ),
    TurkeyCity(
      name: 'Yalova',
      latitude: 40.6500,
      longitude: 29.2667,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.6500, longitude: 29.2667),
        CityDistrict(name: 'Çınarcık', latitude: 40.5833, longitude: 29.1167),
      ],
    ),
    TurkeyCity(
      name: 'Karabük',
      latitude: 41.2061,
      longitude: 32.6203,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 41.2061, longitude: 32.6203),
        CityDistrict(name: 'Safranbolu', latitude: 41.2500, longitude: 32.6833),
      ],
    ),
    TurkeyCity(
      name: 'Kilis',
      latitude: 36.7164,
      longitude: 37.1147,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 36.7164, longitude: 37.1147),
      ],
    ),
    TurkeyCity(
      name: 'Osmaniye',
      latitude: 37.0747,
      longitude: 36.2478,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 37.0747, longitude: 36.2478),
        CityDistrict(name: 'Kadirli', latitude: 37.3742, longitude: 36.0964),
      ],
    ),
    TurkeyCity(
      name: 'Düzce',
      latitude: 40.8438,
      longitude: 31.1565,
      districts: [
        CityDistrict(name: 'Merkez', latitude: 40.8438, longitude: 31.1565),
        CityDistrict(name: 'Akçakoca', latitude: 41.0861, longitude: 31.1167),
      ],
    ),
  ];
}
