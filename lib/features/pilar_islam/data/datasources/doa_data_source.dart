import '../models/doa_model.dart';

class PilarIslamDataSource {
  static const List<String> categories = [
    'Pagi',
    'Malam',
    'Shalat',
    'Perjalanan',
    'Fajar',
    'Siang',
    'Sore',
  ];

  static List<DoaModel> get allDoa => [
        DoaModel(
          id: 'pagi_ayat_kursi',
          title: 'Ayat Kursi',
          arabicText:
              'اللَّهُ لَا إِلَهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...',
          transliteration:
              'Alloohu laa ilaaha illaa Huwal Hayyul Qoyyuum...',
          translation:
              'Allah, tidak ada Tuhan (yang berhak disembah) melainkan Dia Yang Hidup kekal...',
          category: 'Pagi',
          target: 1,
          source: 'QS. Al-Baqarah 255',
        ),
        DoaModel(
          id: 'pagi_ikhlas',
          title: 'Surah Al-Ikhlas',
          arabicText:
              'بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيمِ. قُلْ هُوَ اللَّهُ أَحَدٌ...',
          transliteration:
              'Bismillaahir rohmaanir rohiim. Qul huwallaahu ahad...',
          translation:
              'Katakanlah: Dialah Allah, Yang Maha Esa. Allah adalah Tuhan yang bergantung kepada-Nya segala sesuatu...',
          category: 'Pagi',
          target: 3,
          source: 'QS. Al-Ikhlas',
        ),
        DoaModel(
          id: 'malam_tidur',
          title: 'Doa Sebelum Tidur',
          arabicText:
              'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
          transliteration:
              'Bismika Allahumma amootu wa ahyaa.',
          translation:
              'Dengan nama-Mu ya Allah aku mati dan aku hidup kembali.',
          category: 'Malam',
          target: 1,
          source: 'Hadits',
        ),
        DoaModel(
          id: 'malam_lindungi',
          title: 'Doa Perlindungan Malam',
          arabicText:
              'أَعُوذُ بِكَلِمَاتِ اللَّهِ التَّامَّاتِ مِنْ شَرِّ مَا خَلَقَ',
          transliteration:
              'A’udzu bikalimaatillahi atmati min syarri maa khalaq.',
          translation:
              'Aku berlindung dengan kalimat-kalimat Allah yang sempurna dari kejahatan ciptaan-Nya.',
          category: 'Malam',
          target: 3,
          source: 'Hadits',
        ),
        DoaModel(
          id: 'shalat_subuh',
          title: 'Niat Salat Subuh',
          arabicText:
              'أُصَلِّي فَرْضَ الصُّبْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلَّهِ تَعَالَى',
          transliteration:
              'Ushalli fardhas shubhi rak’ataini mustaqbilal qiblati adaa’an lillaahi ta’aalaa.',
          translation:
              'Saya berniat shalat Subuh dua rakaat menghadap Kiblat karena Allah Ta’ala.',
          category: 'Shalat',
          target: 1,
          source: 'Niat',
        ),
        DoaModel(
          id: 'shalat_dzuhur',
          title: 'Niat Salat Dzuhur',
          arabicText:
              'أُصَلِّي فَرْضَ الظُّهْرِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلَّهِ تَعَالَى',
          transliteration:
              'Ushalli fardhol dhuhaari arba’a raka’atim mustaqbilal qiblati adaa’an lillaahi ta’aalaa.',
          translation:
              'Saya berniat shalat Dzuhur empat rakaat menghadap Kiblat karena Allah Ta’ala.',
          category: 'Shalat',
          target: 1,
          source: 'Niat',
        ),
        DoaModel(
          id: 'perjalanan_naik',
          title: 'Doa Naik Kendaraan',
          arabicText:
              'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَلَمْ نَكُن لَهُ مُقْرِنِينَ',
          transliteration:
              'Subhaanalladzii sakhkhara lanaa hadzaa wa maa kunnaa lahuu muqriniin.',
          translation:
              'Maha Suci Allah yang telah menundukkan ini bagi kami, padahal kami sebelumnya tidak mampu menguasainya.',
          category: 'Perjalanan',
          target: 1,
          source: 'Hadits',
        ),
        DoaModel(
          id: 'perjalanan_safar',
          title: 'Doa Safar',
          arabicText:
              'سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ',
          transliteration:
              'Subhaanalladzii sakhkhara lanaa hadzaa wa maa kunnaa lahuu muqriniin.',
          translation:
              'Maha suci Allah yang menundukkan sarana ini bagi kami, padahal kami sebelumnya tidak mampu.',
          category: 'Perjalanan',
          target: 1,
          source: 'Hadits',
        ),
        DoaModel(
          id: 'fajar_bangun',
          title: 'Doa Bangun Tidur',
          arabicText:
              'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُورُ',
          transliteration:
              'Alhamdu lillaahil ladzii ahyaanaa ba’da maa amaatanaa wa ilaihin nusyuur.',
          translation:
              'Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami dan kepada-Nya kami dibangkitkan.',
          category: 'Fajar',
          target: 1,
          source: 'Hadits',
        ),
        DoaModel(
          id: 'siang_setelah_makan',
          title: 'Doa Setelah Makan',
          arabicText:
              'الْحَمْدُ لِلَّهِ الَّذِي أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مُسْلِمِينَ',
          transliteration:
              'Alhamdu lillaahil ladzii ath’amanaa wa saqaanaa wa ja’alanaa muslimiin.',
          translation:
              'Segala puji bagi Allah yang telah memberi kami makan dan minum dan menjadikan kami orang-orang muslim.',
          category: 'Siang',
          target: 1,
          source: 'Hadits',
        ),
        DoaModel(
          id: 'sore_perlindungan',
          title: 'Dzikir Perlindungan',
          arabicText:
              'بِسْمِ اللَّهِ الَّذِي لَا يَضُرُّ مَعَ اسْمِهِ شَيْءٌ فِي الْأَرْضِ وَلَا فِي السَّمَاءِ',
          transliteration:
              'Bismillaahil ladzii laa yadhurru ma’a ismihii syai’un fil ardhi wa laa fis samaa’i.',
          translation:
              'Dengan nama Allah yang bila disebut, tidak ada sesuatu yang membahayakan di bumi dan di langit.',
          category: 'Sore',
          target: 3,
          source: 'Hadits',
        ),
      ];

  static List<DoaModel> getDoaByCategory(String category) {
    return allDoa.where((doa) => doa.category == category).toList();
  }
}
