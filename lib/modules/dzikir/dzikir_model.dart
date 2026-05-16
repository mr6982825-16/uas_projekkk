class Dzikir {
  final String judul;
  final String arab;
  final String latin;
  final String terjemahan;
  final String fadhilah;
  final int target;
  final String? audioUrl;
  final String category;

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

  factory Dzikir.fromJson(Map<String, dynamic> json, String category) {
    int targetValue = 1;
    String dibacaStr = json['dibaca'] ?? "1x";
    final match = RegExp(r'(\d+)').firstMatch(dibacaStr);
    if (match != null) {
      targetValue = int.tryParse(match.group(1)!) ?? 1;
    }

    return Dzikir(
      judul: json['judul'] ?? (category == "pagi" ? "Dzikir Pagi" : "Dzikir Petang"),
      arab: json['ar'] ?? "",
      latin: json['latin'] ?? "",
      terjemahan: json['id'] ?? "",
      fadhilah: json['fadhilah'] ?? "",
      target: targetValue,
      category: category == "pagi" ? "Pagi" : "Sore",
    );
  }
}

class DzikirData {
  static List<Dzikir> allData = [
    // --- DZIKIR PAGI ---
    Dzikir(
      judul: "Ayat Kursi",
      arab: "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ لَا تَأْخُذُهُ سِنَةٌ وَلَا نَوْمٌ لَهُ مَا فِي السَّمَاوَاتِ وَمَا فِي الْأَرْضِ مَنْ ذَا الَّذِي يَشْفَعُ عِنْدَهُ إِلَّا بِإِذْنِهِ يَعْلَمُ مَا بَيْنَ أَيْدِيهِمْ وَمَا خَلْفَهُمْ وَلَا يُحِيطُونَ بِشَيْءٍ مِنْ عِلْمِهِ إِلَّا بِمَا شَاءَ وَسِعَ كُرْسِيُّهُ السَّمَاوَاتِ وَالْأَرْضَ وَلَا يَئُودُهُ حِفْظُهُمَا وَهُوَ الْعَلِيُّ الْعَظِيمُ",
      latin: "Alloohu laa ilaaha illaa Huwal Hayyul Qoyyuum, laa ta’khudzuhuu sinatuw walaa nauum. Lahuu maa fis-samaawaati wa maa fil ardh. Man dzaal-ladzii yasyfa’u ‘indahuu illaa bi idznih. Ya’lamu maa baina aidiihim wa maa kholfahum, walaa yuhiithuuna bi syai’im min ‘ilmihii illaa bimaa syaa’. Wasi’a kursiyyuhus-samaawaati wal ardho, walaa ya’uuduhuu hifzhuhumaa wa Huwal ‘Aliyyul ‘Azhiim.",
      terjemahan: "Allah, tidak ada Tuhan (yang berhak disembah) melainkan Dia Yang Hidup kekal lagi terus menerus mengurus (makhluk-Nya)...",
      fadhilah: "Siapa yang membacanya di pagi hari, akan dilindungi dari gangguan jin hingga petang.",
      target: 1,
      category: "Pagi",
    ),
    Dzikir(
      judul: "Surah Al-Ikhlas",
      arab: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. قُلْ هُوَ اللَّهُ أَحَدٌ. اللَّهُ الصَّمَدُ. لَمْ يَلِدْ وَلَمْ يُولَدْ. وَلَمْ يَكُن لَّهُ كُفُوًا أَحَدٌ",
      latin: "Bismillaahir rohmaanir rohiim. Qul huwallaahu ahad. Allaahush shomad. Lam yalid walam yuulad. Walam yakul lahuu kufuwan ahad.",
      terjemahan: "Katakanlah: Dialah Allah, Yang Maha Esa. Allah adalah Tuhan yang bergantung kepada-Nya segala sesuatu...",
      fadhilah: "Mencukupi segala sesuatu jika dibaca 3x bersama Al-Falaq dan An-Naas.",
      target: 3,
      category: "Pagi",
    ),
    Dzikir(
      judul: "Surah Al-Falaq",
      arab: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ. مِن شَرِّ مَا خَلَقَ. وَمِن شَرِّ غَاسِقٍ إِذَا وَقَبَ. وَمِن شَرِّ النَّفَّاثَاتِ فِي الْعُقَدِ. وَمِن شَرِّ حَاسِدٍ إِذَا حَسَدَ",
      latin: "Bismillaahir rohmaanir rohiim. Qul a'uudzu birobbil falaq. Min syarri maa kholaq. Wamin syarri ghoosiqin idzaa waqob...",
      terjemahan: "Katakanlah: Aku berlindung kepada Tuhan Yang Menguasai subuh, dari kejahatan makhluk-Nya...",
      fadhilah: "Perlindungan dari kejahatan malam dan sihir.",
      target: 3,
      category: "Pagi",
    ),
    Dzikir(
      judul: "Surah An-Naas",
      arab: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. قُلْ أَعُوذُ بِرَبِّ النَّاسِ. مَلِكِ النَّاسِ. إِلَهِ النَّاسِ. مِن شَرِّ الْوَسْوَاسِ الْخَنَّاسِ. الَّذِي يُوَسْوِسُ فِي صُدُورِ النَّاسِ. مِنَ الْجِنَّةِ وَالنَّاسِ",
      latin: "Bismillaahir rohmaanir rohiim. Qul a'uudzu birobbin-naas. Malikin-naas. Ilaahin-naas...",
      terjemahan: "Katakanlah: Aku berlindung kepada Tuhan (yang memelihara dan menguasai) manusia...",
      fadhilah: "Perlindungan dari bisikan setan dan jin.",
      target: 3,
      category: "Pagi",
    ),
    Dzikir(
      judul: "Sayyidul Istighfar",
      arab: "اَللَّهُمَّ أَنْتَ رَبِّيْ لَا إِلٰهَ إِلَّا أَنْتَ، خَلَقْتَنِيْ وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوْذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوْءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوْءُ بِذَنْبِيْ فَاغْفِرْ لِيْ فَإِنَّهُ لَا يَغْفِرُ الذُّنُوْبَ إِلَّا أَنْتَ",
      latin: "Allaahumma Anta Rabbii laa ilaaha illaa Anta, khalaqtanii wa ana 'abduka, wa ana 'alaa 'ahdika wa wa'dika mastatha'tu...",
      terjemahan: "Ya Allah, Engkau adalah Rabbku, tidak ada ilah yang berhak disembah kecuali Engkau. Engkau yang menciptakanku...",
      fadhilah: "Barangsiapa membacanya di pagi hari dengan penuh keyakinan lalu meninggal sebelum petang, maka ia termasuk penghuni surga.",
      target: 1,
      category: "Pagi",
    ),
    Dzikir(
      judul: "Dzikir Perlindungan",
      arab: "بِسْمِ اللَّهِ الَّذِى لاَ يَضُرُّ مَعَ اسْمِهِ شَىْءٌ فِى الأَرْضِ وَلاَ فِى السَّمَاءِ وَهُوَ السَّمِيعُ الْعَلِيمُ",
      latin: "Bismillaahilladzii laa yadhurru ma’asmihii syai-un fil ardhi walaa fis-samaa’i wa huwas-samii’ul ‘aliim.",
      terjemahan: "Dengan nama Allah yang bila disebut, segala sesuatu di bumi dan langit tidak akan berbahaya, Dia-lah Yang Maha Mendengar lagi Maha Mengetahui.",
      fadhilah: "Barangsiapa membacanya 3x di pagi dan petang hari, maka tidak ada sesuatu pun yang membahayakannya.",
      target: 3,
      category: "Pagi",
    ),
    Dzikir(
      judul: "Keridhaan kepada Allah",
      arab: "رَضِيْتُ بِاللهِ رَبًّا، وَبِاْلإِسْلاَمِ دِيْنًا، وَبِمُحَمَّدٍ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا",
      latin: "Radhiitu billaahi Rabba, wabil Islaami diina, wabi Muhammadin shallallaahu ‘alaihi wasallama Nabiyya.",
      terjemahan: "Aku ridha Allah sebagai Tuhanku, Islam sebagai agamaku dan Muhammad sebagai Nabiku.",
      fadhilah: "Barangsiapa membacanya 3x di pagi dan petang, maka Allah wajib memberikan keridhaan kepadanya di hari kiamat.",
      target: 3,
      category: "Pagi",
    ),
    Dzikir(
      judul: "Tasbih (100x)",
      arab: "سُبْحَانَ اللهِ وَبِحَمْدِهِ",
      latin: "Subhaanallaahi wa bihamdih.",
      terjemahan: "Maha Suci Allah dan segala puji bagi-Nya.",
      fadhilah: "Barangsiapa mengucapkannya 100x sehari, maka akan dihapus dosa-dosanya meskipun sebanyak buih di lautan.",
      target: 100,
      category: "Pagi",
    ),

    // --- DZIKIR PETANG ---
    Dzikir(
      judul: "Ayat Kursi",
      arab: "اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...",
      latin: "Alloohu laa ilaaha illaa Huwal Hayyul Qoyyuum...",
      terjemahan: "Allah, tidak ada Tuhan (yang berhak disembah) melainkan Dia Yang Hidup kekal...",
      fadhilah: "Siapa yang membacanya di sore hari, akan dilindungi dari gangguan jin hingga pagi hari.",
      target: 1,
      category: "Sore",
    ),
    Dzikir(
      judul: "Sayyidul Istighfar",
      arab: "اَللَّهُمَّ أَنْتَ رَبِّيْ لَا إِلٰهَ إِلَّا أَنْتَ...",
      latin: "Allaahumma Anta Rabbii laa ilaaha illaa Anta...",
      terjemahan: "Ya Allah, Engkau adalah Rabbku...",
      fadhilah: "Barangsiapa membacanya di petang hari dengan penuh keyakinan lalu meninggal sebelum pagi, maka ia termasuk penghuni surga.",
      target: 1,
      category: "Sore",
    ),
    Dzikir(
      judul: "Dzikir Perlindungan",
      arab: "بِسْم. اللَّهِ الَّذِى لاَ يَضُرُّ مَعَ اسْمِهِ شَىْءٌ...",
      latin: "Bismillaahilladzii laa yadhurru ma’asmihii syai-un...",
      terjemahan: "Dengan nama Allah yang bila disebut, segala sesuatu di bumi dan langit tidak akan berbahaya...",
      fadhilah: "Perlindungan total dari segala bahaya di malam hari.",
      target: 3,
      category: "Sore",
    ),
    Dzikir(
      judul: "Perlindungan dari Kejahatan Makhluk",
      arab: "أَعُوْذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
      latin: "A'uudzu bikalimaatillaahit-taammaati min syarri maa kholaq.",
      terjemahan: "Aku berlindung dengan kalimat-kalimat Allah yang sempurna dari kejahatan makhluk-Nya.",
      fadhilah: "Barangsiapa membacanya di sore hari 3x, maka tidak akan ada racun/bahaya yang mencelakakannya pada malam itu.",
      target: 3,
      category: "Sore",
    ),
  ];

  static List<Dzikir> get dzikirPagi =>
      allData.where((d) => d.category == "Pagi").toList();

  static List<Dzikir> get dzikirPetang =>
      allData.where((d) => d.category == "Sore").toList();
}
