class Dzikir {
  final String judul;
  final String arab;
  final String latin;
  final String terjemahan;
  final String fadhilah;
  final int target;
  final String? audioUrl;
  final String category; // Added category field

  Dzikir({
    required this.judul,
    required this.arab,
    required this.latin,
    required this.terjemahan,
    required this.fadhilah,
    required this.target,
    required this.category,
    this.audioUrl,
  });
}

class DzikirData {
  static List<Dzikir> allData = [
    // FAJAR
    Dzikir(
      judul: "Doa Bangun Tidur",
      arab: "اَلْحَمْدُ لِلَّهِ الَّذِيْ أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُوْرُ",
      latin: "Alhamdu lillahil ladzii ahyaanaa ba'da maa amaatanaa wa ilaihin nusyuur.",
      terjemahan: "Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami dan kepada-Nya lah kami kembali.",
      fadhilah: "Sunnah Nabi SAW saat terbangun dari tidur.",
      target: 1,
      category: "Fajar",
    ),
    // PAGI
    Dzikir(
      judul: "Ayat Kursi",
      arab: "ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلۡحَيُّ ٱلۡقَيُّومُۚ...",
      latin: "Alloohu laa ilaaha illaa Huwal Hayyul Qoyyuum...",
      terjemahan: "Allah, tidak ada Tuhan (yang berhak disembah) melainkan Dia Yang Hidup kekal...",
      fadhilah: "Dilindungi dari gangguan setan hingga sore hari.",
      target: 1,
      category: "Pagi",
    ),
    Dzikir(
      judul: "Sayyidul Istighfar",
      arab: "اَللَّهُمَّ أَنْتَ رَبِّيْ لَا إِلٰهَ إِلَّا أَنْتَ...",
      latin: "Allahumma anta rabbii laa ilaaha illaa anta...",
      terjemahan: "Ya Allah, Engkau adalah Rabbku...",
      fadhilah: "Jaminan surga bagi yang membacanya dengan yakin lalu wafat.",
      target: 1,
      category: "Pagi",
    ),
    // SIANG
    Dzikir(
      judul: "Doa Setelah Shalat Dzuhur",
      arab: "اَللَّهُمَّ أَعِنِّي عَلَى ذِكْرِكَ وَشُكْرِكَ وَحُسْنِ عِبَادَتِكَ",
      latin: "Allahumma a'inni 'ala dzikrika wa syukrika wa husni 'ibadatika.",
      terjemahan: "Ya Allah, tolonglah aku untuk selalu mengingat-Mu, bersyukur kepada-Mu, dan beribadah dengan baik kepada-Mu.",
      fadhilah: "Memohon pertolongan Allah dalam beribadah.",
      target: 1,
      category: "Siang",
    ),
    Dzikir(
      judul: "Doa Sebelum Makan",
      arab: "اللَّهُمَّ بَارِكْ لَنَا فِيْمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ",
      latin: "Allahumma barik lana fima razaqtana waqina 'adzaban-nar.",
      terjemahan: "Ya Allah, berkahilah kami atas rezeki yang telah Engkau berikan dan jagalah kami dari siksa api neraka.",
      fadhilah: "Memohon keberkahan pada makanan.",
      target: 1,
      category: "Siang",
    ),
    // SORE
    Dzikir(
      judul: "Doa Perlindungan dari Kejahatan",
      arab: "أَعُوْذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
      latin: "A'udzu bi kalimatillahit tammaati min syarri maa khalaq.",
      terjemahan: "Aku berlindung dengan kalimat-kalimat Allah yang sempurna dari kejahatan makhluk-Nya.",
      fadhilah: "Perlindungan di sore hari.",
      target: 3,
      category: "Sore",
    ),
    // MALAM
    Dzikir(
      judul: "Doa Sebelum Tidur",
      arab: "بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا",
      latin: "Bismika Allahumma amuutu wa ahyaa.",
      terjemahan: "Dengan nama-Mu ya Allah, aku mati dan aku hidup.",
      fadhilah: "Sunnah Nabi SAW sebelum istirahat malam.",
      target: 1,
      category: "Malam",
    ),
    // RUMAH
    Dzikir(
      judul: "Doa Masuk Rumah",
      arab: "اَللّٰهُمَّ اِنِّىْ اَسْأَلُكَ خَيْرَالْمَوْلِجِ وَخَيْرَالْمَخْرَجِ",
      latin: "Allahumma innii as-aluka khairal mawliji wa khairal makhraji.",
      terjemahan: "Ya Allah, aku memohon kebaikan tempat masuk dan kebaikan tempat keluar.",
      fadhilah: "Keluarga akan dilindungi dan diberkahi.",
      target: 1,
      category: "Rumah",
    ),
    // BELAJAR
    Dzikir(
      judul: "Doa Sebelum Belajar",
      arab: "رَبِّ زِدْنِي عِلْمًا وَارْزُقْنِي فَهْمًا",
      latin: "Rabbi zidnii 'ilman warzuqnii fahmaa.",
      terjemahan: "Ya Tuhanku, tambahkanlah kepadaku ilmu dan berilah aku pengertian yang baik.",
      fadhilah: "Memohon kemudahan dalam memahami ilmu.",
      target: 1,
      category: "Belajar",
    ),
    // SAKIT
    Dzikir(
      judul: "Doa Menjenguk Orang Sakit",
      arab: "لَا بَأْسَ طَهُورٌ إِنْ شَاءَ اللَّهُ",
      latin: "Laa ba'sa thahuurun in syaa Allah.",
      terjemahan: "Tidak mengapa, semoga sakitmu ini menjadi pembersih dosa, insya Allah.",
      fadhilah: "Memberikan semangat dan doa kesembuhan.",
      target: 1,
      category: "Sakit",
    ),
    // MASJID
    Dzikir(
      judul: "Doa Masuk Masjid",
      arab: "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
      latin: "Allahummaf-tah lii abwaaba rahmatik.",
      terjemahan: "Ya Allah, bukakanlah bagiku pintu-pintu rahmat-Mu.",
      fadhilah: "Adab memasuki rumah Allah.",
      target: 1,
      category: "Masjid",
    ),
    // SUNNAH
    Dzikir(
      judul: "Doa Setelah Shalat Tahajjud",
      arab: "اَللَّهُمَّ لَكَ الْحَمْدُ أَنْتَ نُوْرُ السَّمَاوَاتِ وَاْلأَرْضِ",
      latin: "Allahumma lakal hamdu anta nuurus samawaati wal ardh...",
      terjemahan: "Ya Allah, bagi-Mu segala puji. Engkau adalah cahaya langit dan bumi...",
      fadhilah: "Kepasrahan total kepada Allah di sepertiga malam.",
      target: 1,
      category: "Sunnah",
    ),
  ];

  static List<Dzikir> get dzikirPagi =>
      allData.where((d) => d.category == "Pagi").toList();

  static List<Dzikir> get dzikirPetang =>
      allData.where((d) => d.category == "Sore").toList();
}
