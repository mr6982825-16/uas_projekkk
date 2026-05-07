import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uas_projekk/core/constants.dart';

class DoaProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  List<dynamic> _allDoas = [];
  bool _isLoading = false;

  List<dynamic> get allDoas => _allDoas;
  bool get isLoading => _isLoading;

  Future<void> fetchAllDoas() async {
    if (_allDoas.isNotEmpty) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get(AppConstants.doaBaseUrl);
      if (response.statusCode == 200) {
        _allDoas = response.data['data'];
      }
    } catch (e) {
      debugPrint("Error fetching Doas: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  static final List<Map<String, dynamic>> _localSholatDoas = [
    {
      "judul": "Niat Shalat Subuh",
      "arab": "أُصَلِّي فَرْضَ الصُّبْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلَّهِ تَعَالَى",
      "latin": "Ushalli fardhash shubhi rak'ataini mustaqbilal qiblati ada'an lillahi ta'ala.",
      "terjemahan": "Aku niat melakukan shalat fardhu subuh dua rakaat, sambil menghadap kiblat, saat ini, karena Allah ta'ala."
    },
    {
      "judul": "Niat Shalat Dzuhur",
      "arab": "أُصَلِّي فَرْضَ الظُّهْرِ أَرْبَعَ رَكَعَاتٍ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلَّهِ تَعَالَى",
      "latin": "Ushalli fardhadz dzuhri arba'a raka'atin mustaqbilal qiblati ada'an lillahi ta'ala.",
      "terjemahan": "Aku niat melakukan shalat fardhu dzuhur empat rakaat, sambil menghadap kiblat, saat ini, karena Allah ta'ala."
    },
    {
      "judul": "Doa Iftitah",
      "arab": "اللَّهُ أَكْبَرُ كَبِيرًا وَالْحَمْدُ لِلَّهِ كَثِيرًا وَسُبْحَانَ اللَّهِ بُكْرَةً وَأَصِيلاً. إِنِّي وَجَّهْتُ وَجْهِيَ لِلَّذِي فَطَرَ السَّمَاوَاتِ وَالْأَرْضَ حَنِيفًا مُسْلِمًا وَمَا أَنَا مِنَ الْمُشْرِكِينَ",
      "latin": "Allahu akbar kabira walhamdu lillahi katsira wa subhanallahi bukrataw wa ashila...",
      "terjemahan": "Allah Maha Besar dengan sebesar-besarnya. Segala puji yang sebanyak-banyaknya bagi Allah. Dan Maha Suci Allah siang dan malam."
    },
    {
      "judul": "Bacaan Ruku",
      "arab": "سُبْحَانَ رَبِّيَ الْعَظِيمِ وَبِحَمْدِهِ",
      "latin": "Subhana rabbiyal 'adhimi wa bihamdihi (3x).",
      "terjemahan": "Maha Suci Tuhanku Yang Maha Agung dan dengan segala puji bagi-Nya."
    },
    {
      "judul": "Bacaan Sujud",
      "arab": "سُبْحَانَ رَبِّيَ الْأَعْلَى وَبِحَمْدِهِ",
      "latin": "Subhana rabbiyal a'la wa bihamdihi (3x).",
      "terjemahan": "Maha Suci Tuhanku Yang Maha Tinggi dan dengan segala puji bagi-Nya."
    },
    {
      "judul": "Doa Tahiyat Akhir",
      "arab": "التَّحِيَّاتُ الْمُبَارَكَاتُ الصَّلَوَاتُ الطَّيِّبَاتُ لِلَّهِ، السَّلَامُ عَلَيْكَ أَيُّهَا النَّبِيُّ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ...",
      "latin": "At-tahiyyatu al-mubarakatu ash-shalawatu ath-thayyibatu lillah...",
      "terjemahan": "Segala kehormatan, keberkahan, rahmat dan kebaikan adalah milik Allah..."
    },
    {
      "judul": "Doa Setelah Shalat (Istighfar & Salam)",
      "arab": "أَسْتَغْفِرُ اللهَ (3x) . اَللَّهُمَّ أَنْتَ السَّلاَمُ، وَمِنْكَ السَّلاَمُ، تَبَارَكْتَ يَا ذَا الْجَلاَلِ وَاْلإِكْرَامِ",
      "latin": "Astaghfirullah (3x). Allahumma antas salaam wa minkas salaam...",
      "terjemahan": "Aku memohon ampun kepada Allah (3x). Ya Allah, Engkau Mahasejahtera, dari-Mu lah kesejahteraan..."
    },
    {
      "judul": "Dzikir Tahlil Setelah Shalat",
      "arab": "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
      "latin": "La ilaha illallah wahdahu la syarika lah, lahul mulku wa lahul hamdu...",
      "terjemahan": "Tidak ada Tuhan selain Allah semata, tidak ada sekutu bagi-Nya..."
    },
    {
      "judul": "Tasbih, Tahmid, Takbir (33x)",
      "arab": "سُبْحَانَ اللهِ (33x) . اَلْحَمْدُ لِلَّهِ (33x) . اَللهُ أَكْبَرُ (33x)",
      "latin": "Subhanallah (33x), Alhamdulillah (33x), Allahu Akbar (33x).",
      "terjemahan": "Maha Suci Allah, Segala Puji bagi Allah, Allah Maha Besar."
    },
    {
      "judul": "Tahlil Penutup (100x)",
      "arab": "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
      "latin": "La ilaha illallah wahdahu la syarika lah...",
      "terjemahan": "Tidak ada Tuhan selain Allah semata, tidak ada sekutu bagi-Nya, milik-Nya lah kerajaan..."
    }
  ];

  static final List<Map<String, dynamic>> _localMakanDoas = [
    {
      "judul": "Doa Sebelum Makan",
      "arab": "اَللَّهُمَّ بَارِكْ لَنَا فِيْمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ",
      "latin": "Allahumma barik lana fima razaqtana wa qina 'adzaban naar.",
      "terjemahan": "Ya Allah, berkahilah kami atas rezeki yang Engkau berikan dan peliharalah kami dari siksa neraka."
    },
    {
      "judul": "Doa Sesudah Makan",
      "arab": "اَلْحَمْدُ لِلَّهِ الَّذِيْ أَطْعَمَنَا وَسَقَانَا وَجَعَلَنَا مِنَ الْمُسْلِمِيْنَ",
      "latin": "Alhamdulillahilladzi ath'amana wa saqana wa ja'alana minal muslimin.",
      "terjemahan": "Segala puji bagi Allah yang telah memberi kami makan dan minum, serta menjadikan kami muslim."
    },
    {
      "judul": "Doa Ketika Lupa Membaca Bismillah",
      "arab": "بِسْمِ اللهِ فِى اَوَّلِهِ وَاٰخِرِهِ",
      "latin": "Bismillahi fii awwalihi wa aakhirihi.",
      "terjemahan": "Dengan menyebut nama Allah di awal dan di akhirnya."
    },
    {
      "judul": "Doa Setelah Minum Susu",
      "arab": "اَللَّهُمَّ بَارِكْ لَنَا فِيْهِ وَزِدْنَا مِنْهُ",
      "latin": "Allahumma barik lana fiihi wa zidna minhu.",
      "terjemahan": "Ya Allah, berkahilah bagi kami pada susu ini dan tambahkanlah kepada kami darinya."
    }
  ];

  static final List<Map<String, dynamic>> _localRumahSafarDoas = [
    {
      "judul": "Doa Masuk Rumah",
      "arab": "اَللَّهُمَّ إِنِّيْ أَسْأَلُكَ خَيْرَ الْمَوْلِجِ وَخَيْرَ الْمُخْرَجِ بِسْمِ اللهِ وَلَجْنَا وَبِسْم. اللهِ خَرَجْنَا",
      "latin": "Allahumma inni as-aluka khairal maulaji wa khairal mukhraji...",
      "terjemahan": "Ya Allah, aku memohon kepada-Mu sebaik-baik tempat masuk dan sebaik-baik tempat keluar..."
    },
    {
      "judul": "Doa Keluar Rumah",
      "arab": "بِسْمِ اللهِ تَوَكَّلْتُ عَلَى اللهِ لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللهِ",
      "latin": "Bismillahi tawakkaltu 'alallah, laa haula wala quwwata illa billah.",
      "terjemahan": "Dengan nama Allah, aku bertawakkal kepada Allah. Tiada daya dan kekuatan kecuali dengan Allah."
    },
    {
      "judul": "Doa Masuk WC",
      "arab": "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْخُبُثِ وَالْخَبَائِثِ",
      "latin": "Allahumma inni a'udzu bika minal khubutsi wal khaba-its.",
      "terjemahan": "Ya Allah, aku berlindung kepada-Mu dari setan laki-laki dan setan perempuan."
    },
    {
      "judul": "Doa Keluar WC",
      "arab": "غُفْرَانَكَ",
      "latin": "Ghufranak.",
      "terjemahan": "Aku memohon ampunan-Mu."
    },
    {
      "judul": "Doa Naik Kendaraan",
      "arab": "سُبْحَانَ الَّذِي سَخَّرَ لَنَا هَذَا وَمَا كُنَّا لَهُ مُقْرِنِينَ وَإِنَّا إِلَى رَبِّنَا لَمُنْقَلِبُونَ",
      "latin": "Subhanalladzi sakhkhara lana hadza wa ma kunna lahu muqrinin...",
      "terjemahan": "Maha Suci Allah yang telah menundukkan semua ini bagi kami..."
    },
    {
      "judul": "Doa Masuk Pasar",
      "arab": "لاَ إِلَهَ إِلاَّ اللَّهُ وَحْدَهُ لاَ شَرِيكَ لَهُ لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ يُحْيِي وَيُمِيتُ وَهُوَ حَيٌّ لاَ يَمُوتُ بِيَدِهِ الْخَيْرُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
      "latin": "La ilaha illallah wahdahu la syarika lah...",
      "terjemahan": "Tidak ada Tuhan selain Allah semata, tidak ada sekutu bagi-Nya..."
    }
  ];

  static final List<Map<String, dynamic>> _localHatiDoas = [
    {
      "judul": "Doa Saat Sedih & Galau",
      "arab": "اللَّهُمَّ إِنِّي أَعُوْذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ وَالْعَجْزِ وَالْكَسَلِ وَالْبُخْلِ وَالْجُبْنِ وَضَلَعِ الدَّيْنِ وَغَلَبَةِ الرِّجَالِ",
      "latin": "Allahumma inni a'udzu bika minal hammi wal hazani...",
      "terjemahan": "Ya Allah, sesungguhnya aku berlindung kepada-Mu dari keluh kesah dan kesedihan, kelemahan dan kemalasan..."
    },
    {
      "judul": "Doa Memohon Kemudahan",
      "arab": "اللَّهُمَّ لاَ سَهْلَ إِلاَّ مَا جَعَلْتَهُ سَهْلاً وَأَنْتَ تَجْعَلُ الْحَزْنَ إِذَا شِئْتَ سَهْلاً",
      "latin": "Allahumma laa sahla illaa maa ja'altahu sahla...",
      "terjemahan": "Ya Allah, tidak ada kemudahan kecuali apa yang Engkau jadikan mudah..."
    },
    {
      "judul": "Doa Saat Menghadapi Kesulitan",
      "arab": "يَا حَيُّ يَا قَيُّومُ بِرَحْمَتِكَ أَسْتَغِيثُ",
      "latin": "Ya Hayyu Ya Qayyum bi rahmatika astaghits.",
      "terjemahan": "Wahai Rabb Yang Maha Hidup, wahai Rabb Yang Berdiri Sendiri, dengan rahmat-Mu aku memohon pertolongan."
    },
    {
      "judul": "Doa Syukur (Saat Bahagia)",
      "arab": "رَبِّ أَوْزِعْنِي أَنْ أَشْكُرَ نِعْمَتَكَ الَّتِي أَنْعَمْتَ عَلَيَّ",
      "latin": "Rabbi awzi'ni an asykura ni'matakal latii an'amta 'alayya...",
      "terjemahan": "Ya Tuhanku, berilah aku ilham untuk tetap mensyukuri nikmat-Mu yang telah Engkau anugerahkan kepadaku..."
    }
  ];

  static final List<Map<String, dynamic>> _localSakitDoas = [
    {
      "judul": "Doa Menjenguk Orang Sakit",
      "arab": "لاَ بَأْسَ طَهُورٌ إِنْ شَاءَ اللَّهُ",
      "latin": "Laa ba'sa thahurun in syaa Allah.",
      "terjemahan": "Tidak mengapa, semoga sakitmu ini membersihkan dosamu, insya Allah."
    },
    {
      "judul": "Doa Saat Anggota Tubuh Sakit",
      "arab": "بِسْمِ اللَّهِ (3x) . أَعُوذُ بِاللَّهِ وَقُدْرَتِهِ مِنْ شَرِّ مَا أَجِدُ وَأُحَاذِرُ (7x)",
      "latin": "Bismillah (3x). A'udzu billahi wa qudratihi min syarri ma ajidu wa uhadziru (7x).",
      "terjemahan": "Dengan nama Allah (3x). Aku berlindung kepada Allah dan kekuasaan-Nya dari kejahatan yang aku dapati dan aku takuti."
    },
    {
      "judul": "Doa Takziah",
      "arab": "إِنَّ لِلَّهِ مَا أَخَذَ، وَلَهُ مَا أَعْطَى، وَكُلٌّ عِنْدَهُ بِأَجَلٍ مُسَمًّى... فَلْتَصْبِرْ وَلْتَحْتَسِبْ",
      "latin": "Inna lillahi ma akhadza wa lahu ma a'tha...",
      "terjemahan": "Sesungguhnya adalah milik Allah apa yang Dia ambil dan milik-Nya pulalah apa yang Dia berikan..."
    },
    {
      "judul": "Doa Untuk Jenazah (Singkat)",
      "arab": "اللَّهُمَّ اغْفِرْ لَهُ وَارْحَمْهُ وَعَافِهِ وَاعْفُ عَنْهُ",
      "latin": "Allahummaghfir lahu warhamhu wa 'afihi wa'fu 'anhu.",
      "terjemahan": "Ya Allah, ampunilah dia, berilah rahmat kepadanya, selamatkanlah dia, dan maafkanlah dia."
    }
  ];

  static final List<Map<String, dynamic>> _localHajiDoas = [
    {
      "judul": "Doa Keluar Rumah Untuk Haji/Umrah",
      "arab": "بِسْمِ اللهِ تَوَكَّلْتُ عَلَى اللهِ لاَ حَوْلَ وَلاَ قُوَّةَ إِلاَّ بِاللهِ",
      "latin": "Bismillahi tawakkaltu 'alallah, laa haula wala quwwata illa billah.",
      "terjemahan": "Dengan nama Allah, aku bertawakal kepada Allah, tiada daya dan kekuatan kecuali dengan pertolongan Allah."
    },
    {
      "judul": "Niat Umrah (di Miqat)",
      "arab": "لَبَّيْكَ اللَّهُمَّ عُمْرَةً",
      "latin": "Labbaikallahumma 'umratan.",
      "terjemahan": "Aku sambut panggilan-Mu ya Allah untuk berumrah."
    },
    {
      "judul": "Niat Haji",
      "arab": "لَبَّيْكَ اللَّهُمَّ حَجًّا",
      "latin": "Labbaikallahumma hajjan.",
      "terjemahan": "Aku sambut panggilan-Mu ya Allah untuk berhaji."
    },
    {
      "judul": "Bacaan Talbiyah",
      "arab": "لَبَّيْكَ اللَّهُمَّ لَبَّيْكَ، لَبَّيْكَ لاَ شَرِيكَ لَكَ لَبَّيْكَ، إِنَّ الْحَمْدَ وَالنِّعْمَةَ لَكَ وَالْمُلْكَ لاَ شَرِيكَ لَكَ",
      "latin": "Labbaikallahumma labbaik, labbaika laa syariika laka labbaik...",
      "terjemahan": "Aku datang memenuhi panggilan-Mu ya Allah..."
    },
    {
      "judul": "Doa Masuk Masjidil Haram",
      "arab": "اللَّهُمَّ افْتَحْ لِي أَبْوَابَ رَحْمَتِكَ",
      "latin": "Allahummaftahlii abwaaba rahmatik.",
      "terjemahan": "Ya Allah, bukakanlah bagiku pintu-pintu rahmat-Mu."
    },
    {
      "judul": "Doa Melihat Ka'bah",
      "arab": "اللَّهُمَّ زِدْ هَذَا الْبَيْتَ تَشْرِيفًا وَتَعْظِيمًا وَتَكْرِيمًا وَمَهَابَةً",
      "latin": "Allahumma zid hadzal baita tasyrifan wa ta'dziman...",
      "terjemahan": "Ya Allah, tambahkanlah kemuliaan, keagungan, kehormatan dan kehebatan pada Baitullah ini."
    },
    {
      "judul": "Doa Tawaf (Sapu Jagad)",
      "arab": "رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً وَفِي الْآخِرَةِ حَسَنَةً وَقِنَا عَذَابَ النَّارِ",
      "latin": "Rabbana aatina fiddunya hasanah wa fil akhirati hasanah...",
      "terjemahan": "Ya Tuhan kami, berilah kami kebaikan di dunia dan kebaikan di akhirat..."
    },
    {
      "judul": "Doa Minum Air Zam-zam",
      "arab": "اللَّهُمَّ إِنِّي أَسْأَلُكَ عِلْمًا نَافِعًا وَرِزْقًا وَاسِعًا وَشِفَاءً مِنْ كُلِّ دَاءٍ",
      "latin": "Allahumma inni as-aluka 'ilman naafi'an wa rizqan waasi'an...",
      "terjemahan": "Ya Allah, aku mohon kepada-Mu ilmu yang bermanfaat, rezeki yang luas dan kesembuhan dari segala penyakit."
    },
    {
      "judul": "Doa Sa'i (Shafa & Marwah)",
      "arab": "إِنَّ الصَّفَا وَالْمَرْوَةَ مِنْ شَعَائِرِ اللَّهِ",
      "latin": "Innash shafa wal marwata min sya'airillah.",
      "terjemahan": "Sesungguhnya Shafa dan Marwah adalah sebagian dari syiar Allah."
    },
    {
      "judul": "Doa Melempar Jumroh",
      "arab": "اللَّهُ أَكْبَرُ، اللَّهُمَّ اجْعَلْهُ حَجًّا مَبْرُورًا وَذَنْبًا مَغْفُورًا",
      "latin": "Allahu Akbar, Allahummaj'alhu hajjan mabruran...",
      "terjemahan": "Allah Maha Besar, ya Allah jadikanlah ini haji yang mabrur..."
    },
    {
      "judul": "Doa Wukuf di Arafah",
      "arab": "لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ لَا شَرِيكَ لَهُ، لَهُ الْمُلْكُ وَلَهُ الْحَمْدُ وَهُوَ عَلَى كُلِّ شَيْءٍ قَدِيرٌ",
      "latin": "La ilaha illallah wahdahu la syarika lah...",
      "terjemahan": "Tidak ada Tuhan selain Allah semata, tidak ada sekutu bagi-Nya..."
    },
    {
      "judul": "Doa Tahallul (Potong Rambut)",
      "arab": "اللَّهُمَّ اجْعَلْ لِكُلِّ شَعْرَةٍ نُورًا يَوْمَ الْقِيَامَةِ",
      "latin": "Allahummaj'al likulli sya'ratin nuuran yaumal qiyamah.",
      "terjemahan": "Ya Allah, jadikanlah untuk setiap helai rambut ini cahaya pada hari kiamat."
    },
    {
      "judul": "Doa Tawaf Wada' (Perpisahan)",
      "arab": "اللَّهُمَّ لاَ تَجْعَلْ هَذَا آخِرَ الْعَهْدِ بِبَيْتِكَ الْحَرَامِ",
      "latin": "Allahumma laa taj'al haadza aakhiral 'ahdi bibaitikal haraam.",
      "terjemahan": "Ya Allah, janganlah Engkau jadikan saat ini sebagai saat terakhirku mengunjungi Baitullah-Mu yang suci."
    },
    {
      "judul": "Doa Setelah Selesai Haji/Umrah (Kembali ke Rumah)",
      "arab": "آيِبُونَ تَائِبُونَ عَابِدُونَ لِرَبِّنَا حَامِدُونَ",
      "latin": "Aa-ibuuna taa-ibuuna 'aabiduuna lirabbinaa haamiduun.",
      "terjemahan": "Kami kembali dengan bertaubat, beribadah dan memuji Rabb kami."
    }
  ];

  static final List<Map<String, dynamic>> _localAdabDoas = [
    {
      "judul": "Doa Sebelum Belajar",
      "arab": "رَبِّ زِدْنِي عِلْمًا وَارْزُقْنِي فَهْمًا",
      "latin": "Rabbi zidni 'ilman warzuqni fahman.",
      "terjemahan": "Ya Tuhanku, tambahkanlah ilmu kepadaku dan berilah aku pemahaman yang baik."
    },
    {
      "judul": "Doa Menahan Marah",
      "arab": "أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ الرَّجِيمِ",
      "latin": "A'udzu billahi minasy syaithanir rajiim.",
      "terjemahan": "Aku berlindung kepada Allah dari godaan setan yang terkutuk."
    },
    {
      "judul": "Doa Mohon Akhlak yang Baik",
      "arab": "اللَّهُمَّ اهْدِنِي لِأَحْسَنِ الْأَخْلَاقِ لاَ يَهْدِي لِأَحْسَنِهَا إِلاَّ أَنْتَ",
      "latin": "Allahummah dinii li-ahsanil akhlaaqi...",
      "terjemahan": "Ya Allah, tunjukilah aku pada akhlak yang paling baik..."
    },
    {
      "judul": "Doa Saat Bercermin",
      "arab": "اللَّهُمَّ كَمَا حَسَّنْتَ خَلْقِي فَحَسِّنْ خُلُقِي",
      "latin": "Allahumma kama hassanta khalqi fahassin khuluqi.",
      "terjemahan": "Ya Allah, sebagaimana Engkau telah memperbagus penciptaanku, maka perbaguslah akhlakku."
    }
  ];

  List<dynamic> getDoasByCategory(String category) {
    List<dynamic> combined = List.from(_allDoas);
    final query = category.toLowerCase();
    
    if (query == "pagi & petang") {
      return combined.where((d) => 
        d['judul'].toLowerCase().contains('pagi') || 
        d['judul'].toLowerCase().contains('petang')
      ).toList();
    }

    if (query == "sholat & ibadah") {
      return [
        ..._localSholatDoas,
        ...combined.where((d) => 
          d['judul'].toLowerCase().contains('shalat') || 
          d['judul'].toLowerCase().contains('wudhu') || 
          d['judul'].toLowerCase().contains('masjid')
        ).toList()
      ];
    }

    if (query == "makanan & minuman") {
      return [
        ..._localMakanDoas,
        ...combined.where((d) => 
          d['judul'].toLowerCase().contains('makan') || 
          d['judul'].toLowerCase().contains('minum')
        ).toList()
      ];
    }
    
    if (category == "Semua Doa") return combined;

    if (query == "kebahagiaan & kesulitan") {
      return [
        ..._localHatiDoas,
        ...combined.where((d) => 
          d['judul'].toLowerCase().contains('sedih') || 
          d['judul'].toLowerCase().contains('sulit') || 
          d['judul'].toLowerCase().contains('bahagia') || 
          d['judul'].toLowerCase().contains('gelisah') ||
          d['judul'].toLowerCase().contains('hati') ||
          d['judul'].toLowerCase().contains('mudah')
        ).toList()
      ];
    }
    if (query == "sakit & kematian") {
      return [
        ..._localSakitDoas,
        ...combined.where((d) => 
          d['judul'].toLowerCase().contains('sakit') || 
          d['judul'].toLowerCase().contains('mati') || 
          d['judul'].toLowerCase().contains('jenazah') ||
          d['judul'].toLowerCase().contains('kubur') ||
          d['judul'].toLowerCase().contains('taziyah')
        ).toList()
      ];
    }
    if (query == "perjalanan") {
      return [
        ..._localRumahSafarDoas,
        ...combined.where((d) => 
          d['judul'].toLowerCase().contains('safar') || 
          d['judul'].toLowerCase().contains('kendaraan') || 
          d['judul'].toLowerCase().contains('perjalanan') ||
          d['judul'].toLowerCase().contains('wc') ||
          d['judul'].toLowerCase().contains('rumah') ||
          d['judul'].toLowerCase().contains('pasar')
        ).toList()
      ];
    }
    if (query == "haji & umrah") {
      return [
        ..._localHajiDoas,
        ...combined.where((d) => 
          d['judul'].toLowerCase().contains('haji') || 
          d['judul'].toLowerCase().contains('umrah') || 
          d['judul'].toLowerCase().contains('ihram') ||
          d['judul'].toLowerCase().contains('talbiyah') ||
          d['judul'].toLowerCase().contains('tawaf') ||
          d['judul'].toLowerCase().contains('shafa')
        ).toList()
      ];
    }
    if (query == "adab & karakter") {
      return [
        ..._localAdabDoas,
        ...combined.where((d) => 
          d['judul'].toLowerCase().contains('marah') || 
          d['judul'].toLowerCase().contains('sombong') || 
          d['judul'].toLowerCase().contains('syukur') ||
          d['judul'].toLowerCase().contains('belajar') ||
          d['judul'].toLowerCase().contains('akhlak')
        ).toList()
      ];
    }
    
    // Default fallback: search by name
    final filtered = combined.where((d) => d['judul'].toLowerCase().contains(query)).toList();
    return filtered.isNotEmpty ? filtered : combined.take(10).toList();
  }
}
