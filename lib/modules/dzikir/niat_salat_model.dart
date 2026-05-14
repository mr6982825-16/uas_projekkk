class NiatSalat {
  final String nama;
  final String arab;
  final String latin;
  final String icon;

  NiatSalat({
    required this.nama,
    required this.arab,
    required this.latin,
    required this.icon,
  });
}

class NiatData {
  static List<NiatSalat> daftarNiat = [
    NiatSalat(
      nama: "Salat Subuh",
      arab: "أُصَلِّى فَرْضَ الصُّبْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلَّهِ تَعَالَى",
      latin: "Ushalli fardhas subhi rak'ataini mustaqbilal qiblati adaa'an lillaahi ta'aalaa.",
      icon: "wb_sunny_outlined",
    ),
    NiatSalat(
      nama: "Salat Dzuhur",
      arab: "أُصَلِّى فَرْضَ الظُّهْرِأَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلَّهِ تَعَالَى",
      latin: "Ushalli fardhadh dhuhri arba'a raka'aatim mustaqbilal qiblati adaa'an lillaahi ta'aalaa.",
      icon: "wb_sunny",
    ),
    NiatSalat(
      nama: "Salat Ashar",
      arab: "أُصَلِّى فَرْضَ الْعَصْرِأَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلَّهِ تَعَالَى",
      latin: "Ushalli fardhal 'ashri arba'a raka'aatim mustaqbilal qiblati adaa'an lillaahi ta'aalaa.",
      icon: "cloud_outlined",
    ),
    NiatSalat(
      nama: "Salat Maghrib",
      arab: "أُصَلِّى فَرْضَ الْمَغْرِبِ ثَلاَثَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلَّهِ تَعَالَى",
      latin: "Ushalli fardhal maghribi thalaatha raka'aatim mustaqbilal qiblati adaa'an lillaahi ta'aalaa.",
      icon: "nights_stay_outlined",
    ),
    NiatSalat(
      nama: "Salat Isya",
      arab: "أُصَلِّى فَرْضَ الْعِشَاءِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلَّهِ تَعَالَى",
      latin: "Ushalli fardhal 'isyaa-i arba'a raka'aatim mustaqbilal qiblati adaa'an lillaahi ta'aalaa.",
      icon: "brightness_3",
    ),
  ];
}
