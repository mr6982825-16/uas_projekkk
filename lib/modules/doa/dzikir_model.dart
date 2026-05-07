class Dzikir {
  final String judul;
  final String arab;
  final String latin;
  final String terjemahan;
  final String fadhilah;
  final int target;
  final String? audioUrl;

  Dzikir({
    required this.judul,
    required this.arab,
    required this.latin,
    required this.terjemahan,
    required this.fadhilah,
    required this.target,
    this.audioUrl,
  });
}

class DzikirData {
  static List<Dzikir> dzikirPagi = [
    Dzikir(
      judul: "Membaca Ta'awudz",
      arab: "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ",
      latin: "A'udzu billahi minasy syaithonir rajiim.",
      terjemahan: "Aku berlindung kepada Allah dari godaan setan yang terkutuk.",
      fadhilah: "Perlindungan dari setan sebelum memulai dzikir.",
      target: 1,
      audioUrl: "taawudz.mp3",
    ),
    Dzikir(
      judul: "Ayat Kursi",
      arab: "ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلۡحَيُّ ٱلۡقَيُّومُۚ لَا تَأۡخُذُهُۥ سِنَةٌ وَلَا نَوۡمٌۚ لَّهُۥ مَا فِي ٱلسَّمَٰوَٰتِ وَمَا فِي ٱلۡأَرۡضِۗ مَن ذَا ٱلَّذِي يَشۡفَعُ عِندَهُۥٓ إِلَّا بِإِذۡنِهِۦۚ يَعۡلَمُ مَا بَيۡنَ أَيۡدِيهِمۡ وَمَا خَلۡفَهُمۡۖ وَلَا يُحِيطُونَ بِشَيۡءٍ مِّنۡ عِلۡمِهِۦٓ إِلَّا بِمَا شَآءَۚ وَسِعَ كُرۡسِيُّهُ ٱلسَّمَٰوَٰتِ وَٱلۡأَرۡضَۖ وَلَا يَـُٔودُهُۥ حِفۡظُهُمَاۚ وَهُوَ ٱلۡعَلِيُّ ٱلۡعَظِيمُ",
      latin: "Alloohu laa ilaaha illaa Huwal Hayyul Qoyyuum...",
      terjemahan: "Allah, tidak ada Tuhan (yang berhak disembah) melainkan Dia Yang Hidup kekal...",
      fadhilah: "Dilindungi dari gangguan setan hingga sore hari.",
      target: 1,
      audioUrl: "ayat_kursi.mp3",
    ),
    Dzikir(
      judul: "Al-Ikhlas, Al-Falaq, An-Naas",
      arab: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ (3x)",
      latin: "Membaca Al-Ikhlas, Al-Falaq, dan An-Naas.",
      terjemahan: "Masing-masing dibaca tiga kali.",
      fadhilah: "Dicukupkan dari segala sesuatu.",
      target: 3,
      audioUrl: "3_qul.mp3",
    ),
    Dzikir(
      judul: "Dzikir Pagi (Ashbahna...)",
      arab: "أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
      latin: "Ashbahna wa ashbahal mulku lillah, walhamdulillah...",
      terjemahan: "Kami berpagi hari dan pagi ini kerajaan milik Allah...",
      fadhilah: "Pengakuan tauhid dan syukur di pagi hari.",
      target: 1,
      audioUrl: "ashbahna.mp3",
    ),
    Dzikir(
      judul: "Sayyidul Istighfar",
      arab: "اَللَّهُمَّ أَنْتَ رَبِّيْ لَا إِلٰهَ إِلَّا أَنْتَ، خَلَقْتَنِيْ وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوْذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوْءُ لَكَ بِنِعْمَتِكَ عَلَيَّ، وَأَبُوْءُ بِذَنْبِيْ فَاغْفِرْ لِيْ فَإِنَّهُ لَا يَغْفِرُ الذُّنُوْبَ إِلَّا أَنْتَ",
      latin: "Allahumma anta rabbii laa ilaaha illaa anta...",
      terjemahan: "Ya Allah, Engkau adalah Rabbku...",
      fadhilah: "Jaminan surga bagi yang membacanya dengan yakin lalu wafat.",
      target: 1,
      audioUrl: "sayyidul_istighfar.mp3",
    ),
    Dzikir(
      judul: "Ridha Allah sebagai Rabb",
      arab: "رَضِيتُ بِاللَّهِ رَبًّا، وَبِالْإِسْلَامِ دِينًا، وَبِمُحَمَّدٍ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ نَبِيًّا",
      latin: "Radhiitu billahi rabba, wabil Islami diina...",
      terjemahan: "Aku ridha Allah sebagai Tuhanku, Islam agamaku...",
      fadhilah: "Allah pasti akan meridhai orang tersebut pada hari kiamat.",
      target: 3,
      audioUrl: "radhiitu.mp3",
    ),
    Dzikir(
      judul: "Memohon Ilmu & Rezeki",
      arab: "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا، وَرِزْقًا طَيِّبًا، وَعَمَلًا مُتَقَبَّلًا",
      latin: "Allahumma inni as-aluka 'ilman naafi'an...",
      terjemahan: "Ya Allah, aku memohon ilmu yang bermanfaat...",
      fadhilah: "Doa agar hari ini penuh berkah dan amal diterima.",
      target: 1,
      audioUrl: "ilmu_rezeki.mp3",
    ),
    Dzikir(
      judul: "Tasbih 100x",
      arab: "سُبْحَانَ اللَّهِ وَبِحَمْدِهِ",
      latin: "Subhanallahi wa bihamdihi.",
      terjemahan: "Maha Suci Allah dan dengan memuji-Nya.",
      fadhilah: "Dihapuskan dosa-dosanya meskipun sebanyak buih di lautan.",
      target: 100,
      audioUrl: "subhanallah_100.mp3",
    ),
  ];

  static List<Dzikir> dzikirPetang = [
    Dzikir(
      judul: "Ayat Kursi",
      arab: "ٱللَّهُ لَآ إِلَٰهَ إِلَّا هُوَ ٱلۡحَيُّ ٱلۡقَيُّومُۚ ...",
      latin: "Alloohu laa ilaaha illaa Huwal Hayyul Qoyyuum...",
      terjemahan: "Allah, tidak ada Tuhan (yang berhak disembah) melainkan Dia Yang Hidup kekal...",
      fadhilah: "Dilindungi dari gangguan setan hingga pagi hari.",
      target: 1,
      audioUrl: "ayat_kursi.mp3",
    ),
    Dzikir(
      judul: "Al-Ikhlas, Al-Falaq, An-Naas",
      arab: "بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ (3x)",
      latin: "Membaca Al-Ikhlas, Al-Falaq, dan An-Naas.",
      terjemahan: "Masing-masing dibaca tiga kali.",
      fadhilah: "Dicukupkan dari segala sesuatu.",
      target: 3,
      audioUrl: "3_qul.mp3",
    ),
    Dzikir(
      judul: "Dzikir Petang (Amsaina...)",
      arab: "أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ، وَالْحَمْدُ لِلَّهِ، لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ...",
      latin: "Amsaina wa amsayal mulku lillah...",
      terjemahan: "Kami berpagi hari dan sore ini kerajaan milik Allah...",
      fadhilah: "Pengakuan tauhid dan syukur di sore hari.",
      target: 1,
      audioUrl: "amsaina.mp3",
    ),
    Dzikir(
      judul: "Sayyidul Istighfar",
      arab: "اَللَّهُمَّ أَنْتَ رَبِّيْ لَا إِلٰهَ إِلَّا أَنْتَ...",
      latin: "Allahumma anta rabbii laa ilaaha illaa anta...",
      terjemahan: "Ya Allah, Engkau adalah Rabbku...",
      fadhilah: "Jaminan surga bagi yang membacanya dengan yakin lalu wafat.",
      target: 1,
      audioUrl: "sayyidul_istighfar.mp3",
    ),
    Dzikir(
      judul: "Doa Perlindungan dari Kejahatan Makhluk",
      arab: "أَعُوْذُ بِكَلِمَاتِ اللهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ",
      latin: "A'udzu bi kalimatillahit tammaati min syarri maa khalaq.",
      terjemahan: "Aku berlindung dengan kalimat-kalimat Allah yang sempurna dari kejahatan makhluk yang diciptakan-Nya.",
      fadhilah: "Tidak akan membahayakan baginya sesuatu pun.",
      target: 3,
    ),
    Dzikir(
      judul: "Doa Memohon Afiyah",
      arab: "اللَّهُمَّ إِنِّي أَسْأَلُكَ الْعَفْوَ وَالْعَافِيَةَ فِي الدُّنْيَا وَالْآخِرَةِ",
      latin: "Allahumma inni as-alukal 'afwa wal 'afiyata fid-dunya wal-akhirah.",
      terjemahan: "Ya Allah, sesungguhnya aku memohon ampunan dan keselamatan di dunia dan akhirat.",
      fadhilah: "Keselamatan di dunia dan akhirat.",
      target: 1,
    ),
    Dzikir(
      judul: "Sayyidul Istighfar",
      arab: "اَللَّهُمَّ أَنْتَ رَبِّيْ لَا إِلٰهَ إِلَّا أَنْتَ، خَلَقْتَنِيْ وَأَنَا عَبْدُكَ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَا اسْتَطَعْتُ، أَعُوْذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ، أَبُوْءُ لَكَ bِنِعْمَتِكَ عَلَيَّ، وَأَبُوْءُ بِذَنْبِيْ فَاغْفِرْ لِيْ فَإِنَّهُ لَا يَغْفِرُ الذُّنُوْبَ إِلَّا أَنْتَ",
      latin: "Allahumma anta rabbii laa ilaaha illaa anta...",
      terjemahan: "Ya Allah, Engkau adalah Rabbku...",
      fadhilah: "Rajanya istighfar, jaminan surga jika wafat di malam itu.",
      target: 1,
    ),
  ];
}
