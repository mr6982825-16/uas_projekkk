const hadithBooksData = [
  {
    "id": "bukhari",
    "name": "Bukhari",
    "available": 10,
  },
  {
    "id": "muslim",
    "name": "Muslim",
    "available": 10,
  },
  {
    "id": "abu-dawud",
    "name": "Abu Dawud",
    "available": 10,
  },
  {
    "id": "tirmidzi",
    "name": "Tirmidzi",
    "available": 10,
  },
  {
    "id": "nasai",
    "name": "Nasai",
    "available": 10,
  },
  {
    "id": "ibnu-majah",
    "name": "Ibnu Majah",
    "available": 10,
  },
  {
    "id": "ahmad",
    "name": "Ahmad",
    "available": 10,
  },
  {
    "id": "darimi",
    "name": "Darimi",
    "available": 10,
  },
  {
    "id": "malik",
    "name": "Malik",
    "available": 10,
  },
  {
    "id": "arbain-nawawi",
    "name": "Arba'in Nawawi",
    "available": 10,
  },
  {
    "id": "riyadush-shalihin",
    "name": "Riyadush Shalihin",
    "available": 8,
  },
];

const hadithItemsByBook = {
  "bukhari": [
    {
      "number": 1,
      "arab": "إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى",
      "contents": "Sesungguhnya setiap amalan harus disertai dengan niat, dan setiap orang hanya akan mendapatkan apa yang ia niatkan."
    },
    {
      "number": 2,
      "arab": "بُنِيَ الإِسْلاَمُ عَلَى خَمْسٍ شَهَادَةِ أَنْ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَنَّ مُحَمَّدًا رَسُولُ اللَّهِ وَإِقَامِ الصَّلاَةِ وَإِيتَاءِ الزَّكَاةِ وَالْحَجِّ وَصَوْمِ رَمَضَانَ",
      "contents": "Islam dibangun di atas lima perkara: bersaksi bahwa tidak ada sesembahan yang berhak disembah selain Allah dan Muhammad utusan Allah, mendirikan shalat, menunaikan zakat, haji, dan puasa Ramadhan."
    },
    {
      "number": 3,
      "arab": "آيَةُ الْمُنَافِقِ ثَلاَثٌ إِذَا حَدَّثَ كَذَبَ وَإِذَا وَعَدَ أَخْلَفَ وَإِذَا ائْتُمِنَ خَانَ",
      "contents": "Tanda-tanda orang munafik ada tiga: jika berbicara dia berdusta, jika berjanji dia mengingkari, dan jika dipercaya dia berkhianat."
    },
    {
      "number": 4,
      "arab": "تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ",
      "contents": "Senyummu di hadapan saudaramu adalah sedekah bagimu."
    },
    {
      "number": 5,
      "arab": "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ",
      "contents": "Barangsiapa yang beriman kepada Allah dan hari akhir maka hendaklah dia berkata baik atau diam."
    },
    {
      "number": 6,
      "arab": "لاَ يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ",
      "contents": "Tidak sempurna iman salah seorang di antara kalian hingga ia mencintai saudaranya sebagaimana ia mencintai dirinya sendiri."
    },
    {
      "number": 7,
      "arab": "الإِيمَانُ بِضْعٌ وَسِتُّونَ شُعْبَةً وَالْحَيَاءُ شُعْبَةٌ مِنَ الإِيمَانِ",
      "contents": "Iman itu ada enam puluh lebih cabang, dan malu adalah salah satu cabang dari iman."
    },
    {
      "number": 8,
      "arab": "الْيَدُ الْعُلْيَا خَيْرٌ مِنَ الْيَدِ السُّفْلَى",
      "contents": "Tangan yang di atas (memberi) lebih baik daripada tangan yang di bawah (meminta)."
    },
    {
      "number": 9,
      "arab": "لَوْلاَ أَنْ أَشُقَّ عَلَى أُمَّتِي لأَمَرْتُهُمْ بِالسِّوَاكِ عِنْدَ كُلِّ صَلاَةٍ",
      "contents": "Seandainya tidak memberatkan umatku niscaya akan aku perintahkan mereka untuk bersiwak setiap kali akan shalat."
    },
    {
      "number": 10,
      "arab": "لاَ يَرْحَمُ اللَّهُ مَنْ لاَ يَرْحَمُ النَّاسَ",
      "contents": "Allah tidak akan menyayangi siapa saja yang tidak menyayangi manusia."
    }
  ],
  "muslim": [
    {
      "number": 1,
      "arab": "الدِّينُ النَّصِيحَةُ قُلْنَا لِمَنْ قَالَ لِلَّهِ وَلِكِتَابِهِ وَلِرَسُولِهِ وَلأَئِمَّةِ الْمُسْلِمِينَ وَعَامَّتِهِمْ",
      "contents": "Agama itu adalah nasihat. Kami bertanya: Untuk siapa? Beliau menjawab: Untuk Allah, Kitab-Nya, Rasul-Nya, para pemimpin kaum muslimin, dan seluruh umat Islam."
    },
    {
      "number": 2,
      "arab": "الإِيمَانُ بِضْعٌ وَسَبْعُونَ أَوْ بِضْعٌ وَسِتُّونَ شُعْبَةً فَأَفْضَلُهَا قَوْلُ لاَ إِلَهَ إِلاَّ اللَّهُ وَأَدْنَاهَا إِيمَاطَةُ الأَذَى عَنِ الطَّرِيقِ",
      "contents": "Iman itu ada tujuh puluh atau enam puluh lebih cabang. Yang paling utama adalah ucapan Lailahaillallah, dan yang paling rendah adalah menyingkirkan gangguan dari jalan."
    },
    {
      "number": 3,
      "arab": "لاَ تَحَاسَدُوا وَلاَ تَنَاجَشُوا وَلاَ تَبَاغَضُوا وَلاَ تَدَابَرُوا وَكُونُوا عِبَادَ اللَّهِ إِخْوَانًا",
      "contents": "Janganlah kalian saling mendengki, saling menipu, saling membenci, saling membelakangi, dan jadilah hamba-hamba Allah yang bersaudara."
    },
    {
      "number": 4,
      "arab": "يَسِّرُوا وَلاَ تُعَسِّرُوا وَبَشِّرُوا وَلاَ تُنَفِّرُوا",
      "contents": "Mudahkanlah dan jangan mempersulit, berilah kabar gembira dan jangan membuat orang lari menjauh."
    },
    {
      "number": 5,
      "arab": "إِنَّ اللَّهَ لاَ يَنْظُرُ إِلَى صُوَرِكُمْ وَأَمْوَالِكُمْ وَلَكِنْ يَنْظُرُ إِلَى قُلُوبِكُمْ وَأَعْمَالِكُمْ",
      "contents": "Sesungguhnya Allah tidak melihat kepada rupa dan harta kalian, tetapi Dia melihat kepada hati dan amal perbuatan kalian."
    },
    {
      "number": 6,
      "arab": "اقْرَءُوا الْقُرْآنَ فَإِنَّهُ يَأْتِي يَوْمَ الْقِيَامَةِ شَفِيعًا لأَصْحَابِهِ",
      "contents": "Bacalah Al-Quran, karena ia akan datang pada hari kiamat sebagai pemberi syafaat bagi para pembacanya."
    },
    {
      "number": 7,
      "arab": "الْمُؤْمِنُ الْقَوِيُّ خَيْرٌ وَأَحَبُّ إِلَى اللَّهِ مِنَ الْمُؤْمِنِ الضَّعِيفِ وَفِي كُلٍّ خَيْرٌ",
      "contents": "Mukmin yang kuat lebih baik dan lebih dicintai oleh Allah daripada mukmin yang lemah, namun pada masing-masing ada kebaikan."
    },
    {
      "number": 8,
      "arab": "مَا نَقَصَتْ صَدَقَةٌ مِنْ مَالٍ وَمَا زَادَ اللَّهُ عَبْدًا بِعَفْوٍ إِلاَّ عِزًّا",
      "contents": "Sedekah tidak akan mengurangi harta, dan tidaklah Allah menambah bagi seorang hamba sifat pemaaf melainkan kemuliaan."
    },
    {
      "number": 9,
      "arab": "مَنْ رَأَى مِنْكُمْ مُنْكَرًا فَلْيُغَيِّرْهُ بِيَدِهِ فَإِنْ لَمْ يَسْتَطِعْ فَبِلِسَانِهِ فَإِنْ لَمْ يَسْتَطِعْ فَبِقَلْبِهِ وَذَلِكَ أَضْعَفُ الإِيمَانِ",
      "contents": "Barangsiapa di antara kalian melihat kemungkaran, maka ubahlah dengan tangannya. Jika tidak mampu, maka dengan lisannya. Dan jika tidak mampu, maka dengan hatinya, dan itu adalah selemah-lemah iman."
    },
    {
      "number": 10,
      "arab": "حَقُّ الْمُسْلِمِ عَلَى الْمُسْلِمِ سِتٌّ إِذَا لَقِيتَهُ فَسَلِّمْ عَلَيْهِ وَإِذَا دَعَاكَ فَأَجِبْهُ وَإِذَا اسْتَنْصَحَكَ فَانْصَحْ لَهُ وَإِذَا عَطَسَ فَحَمِدَ اللَّهَ فَشَمِّتْهُ وَإِذَا مَرِضَ فَعُدْهُ وَإِذَا مَاتَ فَاتَّبِعْهُ",
      "contents": "Hak seorang muslim atas muslim lainnya ada enam: jika bertemu ucapkan salam, jika mengundang penuhilah, jika meminta nasihat beri nasihat, jika bersin lalu memuji Allah doakanlah, jika sakit jenguklah, dan jika meninggal antarkan jenazahnya."
    }
  ],
  "abu-dawud": [
    {
      "number": 1,
      "arab": "مَنْ سَلَكَ طَرِيقًا يَطْلُبُ فِيهِ عِلْمًا سَلَكَ اللَّهُ بِهِ طَرِيقًا مِنْ طُرُقِ الْجَنَّةِ",
      "contents": "Barangsiapa menempuh jalan untuk menuntut ilmu, maka Allah akan memudahkan baginya jalan menuju surga."
    },
    {
      "number": 2,
      "arab": "الْمُسْلِمُونَ شُرَكَاءُ فِي ثَلاَثٍ فِي الْمَاءِ وَالْكَلإِ وَالنَّارِ",
      "contents": "Kaum muslimin berserikat dalam tiga hal: air, rumput (gembalaan), dan api."
    },
    {
      "number": 3,
      "arab": "رِضَى الرَّبِّ فِي رِضَى الْوَالِدِ وَسَخَطُ الرَّبِّ فِي سَخَطِ الْوَالِدِ",
      "contents": "Ridha Tuhan terletak pada ridha orang tua, dan murka Tuhan terletak pada murka orang tua."
    },
    {
      "number": 4,
      "arab": "الرَّاحِمُونَ يَرْحَمُهُمُ الرَّحْمَنُ ارْحَمُوا مَنْ فِي الأَرْضِ يَرْحَمْكُمْ مَنْ فِي السَّمَاءِ",
      "contents": "Orang-orang yang penyayang akan disayangi oleh Tuhan Yang Maha Pengasih. Sayangilah yang ada di bumi, niscaya yang ada di langit akan menyayangi kalian."
    },
    {
      "number": 5,
      "arab": "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيُكْرِمْ ضَيْفَهُ",
      "contents": "Barangsiapa yang beriman kepada Allah dan hari akhir, hendaklah dia menghormati tamunya."
    },
    {
      "number": 6,
      "arab": "اتَّقُوا اللَّهَ وَاعْدِلُوا بَيْنَ أَوْلاَدِكُمْ",
      "contents": "Bertakwalah kepada Allah dan berbuat adillah di antara anak-anak kalian."
    },
    {
      "number": 7,
      "arab": "كَانَ النَّبِيُّ صَلَّى اللَّهُ عَلَيْهِ وَسَلَّمَ يُعْجِبُهُ التَّيَمُّنُ فِي تَنَعُّلِهِ وَتَرَجُّلِهِ وَطُهُورِهِ",
      "contents": "Nabi shallallahu 'alaihi wasallam sangat menyukai mendahulukan yang kanan saat memakai sandal, menyisir rambut, dan bersuci."
    },
    {
      "number": 8,
      "arab": "لَيْسَ الْمُؤْمِنُ بِالطَّعَّانِ وَلاَ اللَّعَّانِ وَلاَ الْفَاحِشِ وَلاَ الْبَذِيءِ",
      "contents": "Seorang mukmin bukanlah orang yang suka mencela, melaknat, berkata keji, maupun berkata kotor."
    },
    {
      "number": 9,
      "arab": "إِذَا وَلَجَ الرَّجُلُ بَيْتَهُ فَلْيَقُلِ اللَّهُمَّ إِنِّي أَسْأَلُكَ خَيْرَ الْمَوْلَجِ وَخَيْرَ الْمَخْرَجِ",
      "contents": "Apabila seseorang memasuki rumahnya, hendaklah ia membaca: Ya Allah, sesungguhnya aku memohon kepada-Mu kebaikan tempat masuk dan kebaikan tempat keluar."
    },
    {
      "number": 10,
      "arab": "عَلَيْكُمْ بِالصِّدْقِ فَإِنَّ الصِّدْقَ يَهْدِي إِلَى الْبِرِّ",
      "contents": "Hendaklah kalian bersikap jujur, karena kejujuran membawa kepada kebaikan."
    }
  ],
  "tirmidzi": [
    {
      "number": 1,
      "arab": "الدُّعَاءُ مُخُّ الْعِبَادَةِ",
      "contents": "Doa adalah inti/otak dari ibadah."
    },
    {
      "number": 2,
      "arab": "خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ",
      "contents": "Sebaik-baik kalian adalah orang yang mempelajari Al-Quran dan mengajarkannya."
    },
    {
      "number": 3,
      "arab": "اتَّقِ اللَّهِ حَيْثُمَا كُنْتَ وَأَتْبِعِ السَّيِّئَةَ الْحَسَنَةَ تَمْحُهَا وَخَالِقِ النَّاسَ بِخُلُقٍ حَسَنٍ",
      "contents": "Bertakwalah kepada Allah di mana pun kamu berada, iringilah keburukan dengan kebaikan niscaya akan menghapusnya, dan pergauilah manusia dengan akhlak yang baik."
    },
    {
      "number": 4,
      "arab": "الدُّنْيَا سِجْنُ الْمُؤْمِنِ وَجَنَّةُ الْكَافِرِ",
      "contents": "Dunia adalah penjara bagi orang mukmin dan surga bagi orang kafir."
    },
    {
      "number": 5,
      "arab": "صَدَقَةُ السِّرِّ تُطْفِئُ غَضَبَ الرَّبِّ",
      "contents": "Sedekah yang dilakukan secara sembunyi-sembunyi dapat meredam murka Allah."
    },
    {
      "number": 6,
      "arab": "مَا مِنْ شَيْءٍ أَثْقَلُ فِي مِيزَانِ الْمُؤْمِنِ يَوْمَ الْقِيَامَةِ مِنْ حُسْنِ الْخُلُقِ",
      "contents": "Tidak ada sesuatu pun yang lebih berat dalam timbangan amal seorang mukmin pada hari kiamat melainkan akhlak yang baik."
    },
    {
      "number": 7,
      "arab": "طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمِ",
      "contents": "Menuntut ilmu adalah kewajiban bagi setiap muslim."
    },
    {
      "number": 8,
      "arab": "إِنَّ الدَّالَّ عَلَى الْخَيْرِ كَفَاعِلِهِ",
      "contents": "Orang yang menunjukkan kepada kebaikan akan mendapatkan pahala seperti orang yang melakukannya."
    },
    {
      "number": 9,
      "arab": "وَاعْتَصِمُوا بِحَبْلِ اللَّهِ جَمِيعًا وَلاَ تَفَرَّقُوا",
      "contents": "Dan berpegang teguhlah kalian semuanya pada tali (agama) Allah, dan janganlah kalian bercerai-berai."
    },
    {
      "number": 10,
      "arab": "عَلَيْكُمْ بِقِيَامِ اللَّيْلِ فَإِنَّهُ دَأْبُ الصَّالِحِينَ قَبْلَكُمْ",
      "contents": "Hendaklah kalian melaksanakan shalat malam (tahajud), karena hal itu merupakan kebiasaan orang-orang saleh sebelum kalian."
    }
  ],
  "nasai": [
    {
      "number": 1,
      "arab": "السِّوَاكُ مَطْهَرَةٌ لِلْفَمِ مَرْضَاةٌ لِلرَّبِّ",
      "contents": "Bersiwak adalah pembersih mulut dan sarana meraih ridha Tuhan."
    },
    {
      "number": 2,
      "arab": "لاَ يُقْبَلُ اللَّهُ صَلاَةً بِغَيْرِ طُهُورٍ وَلاَ صَدَقَةً مِنْ غُلُولٍ",
      "contents": "Allah tidak menerima shalat tanpa bersuci dan tidak menerima sedekah dari hasil khianat."
    },
    {
      "number": 3,
      "arab": "أَوَّلُ مَا يُحَاسَبُ بِهِ الْعَبْدُ يَوْمَ الْقِيَامَةِ مِنْ عَمَلِهِ صَلاَتُهُ",
      "contents": "Amal pertama seorang hamba yang dihisab pada hari kiamat adalah shalatnya."
    },
    {
      "number": 4,
      "arab": "مَنْ أَذَّنَ اثْنَتَيْ عَشْرَةَ سَنَةً وَجَبَتْ لَهُ الْجَنَّةُ",
      "contents": "Barangsiapa mengumandangkan adzan selama dua belas tahun, wajib baginya surga."
    },
    {
      "number": 5,
      "arab": "لاَ يَدْخُلُ الْجَنَّةَ قَاطِعٌ",
      "contents": "Tidak akan masuk surga orang yang memutus hubungan silaturahmi."
    },
    {
      "number": 6,
      "arab": "كُلُّ مُسْكِرٍ خَمْرٌ وَكُلُّ خَمْرٍ حَرَامٌ",
      "contents": "Setiap yang memabukkan adalah khamr (arak) dan setiap khamr adalah haram."
    },
    {
      "number": 7,
      "arab": "لاَ إِيمَانَ لِمَنْ لاَ أَمَانَةَ لَهُ",
      "contents": "Tidak ada iman (yang sempurna) bagi orang yang tidak memegang amanah."
    },
    {
      "number": 8,
      "arab": "أَقْرَبُ مَا يَكُونُ الْعَبْدُ مِنْ رَبِّهِ وَهُوَ سَاجِدٌ فَأَكْثِرُوا الدُّعَاءَ",
      "contents": "Saat paling dekat antara seorang hamba dengan Tuhannya adalah ketika bersujud, maka perbanyaklah berdoa di dalamnya."
    },
    {
      "number": 9,
      "arab": "اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ وَالْعَجْزِ وَالْكَسَلِ",
      "contents": "Ya Allah, aku berlindung kepada-Mu dari kegelisahan, kesedihan, kelemahan, dan kemalasan."
    },
    {
      "number": 10,
      "arab": "خُذُوا جُنَّتَكُمْ مِنَ النَّارِ قُولُوا سُبْحَانَ اللَّهِ وَالْحَمْدُ لِلَّهِ",
      "contents": "Ambillah tameng kalian dari api neraka dengan mengucapkan Subhanallah walhamdulillah (Maha Suci Allah dan segala puji bagi Allah)."
    }
  ],
  "ibnu-majah": [
    {
      "number": 1,
      "arab": "طَلَبُ الْعِلْمِ فَرِيضَةٌ عَلَى كُلِّ مُسْلِمٍ",
      "contents": "Menuntut ilmu adalah kewajiban bagi setiap muslim."
    },
    {
      "number": 2,
      "arab": "أَعْطُوا الأَجِيرَ أَجْرَهُ قَبْلَ أَنْ يَجِفَّ عَرَقُهُ",
      "contents": "Berikanlah upah kepada pekerja sebelum keringatnya mengering."
    },
    {
      "number": 3,
      "arab": "لاَ ضَرَرَ وَلاَ ضِرَارَ",
      "contents": "Tidak boleh berbuat mudharat (merugikan diri sendiri) dan tidak boleh membalas dengan kemudharatan (merugikan orang lain)."
    },
    {
      "number": 4,
      "arab": "مَنْ نَفَّسَ عَنْ مُؤْمِنٍ كُرْبَةً مِنْ كُرَبِ الدُّنْيَا نَفَّسَ اللَّهُ عَنْهُ كُرْبَةً مِنْ كُرَبِ يَوْمِ الْقِيَامَةِ",
      "contents": "Barangsiapa meringankan satu kesulitan hidup seorang mukmin di dunia, Allah akan meringankan satu kesulitan hidupnya di hari kiamat."
    },
    {
      "number": 5,
      "arab": "أَفْضَلُ الصَّدَقَةِ أَنْ يَتَعَلَّمَ الْمَرْءُ الْمُسْلِمُ عِلْمًا ثُمَّ يُعَلِّمَهُ أَخَاهُ الْمُسْلِمَ",
      "contents": "Sedekah yang paling utama adalah seorang muslim mempelajari suatu ilmu kemudian mengajarkannya kepada saudaranya yang muslim."
    },
    {
      "number": 6,
      "arab": "عُودُوا الْمَرِيضَ وَاتَّبِعُوا الْجَنَائِزَ تُذَكِّرْكُمُ الآخِرَةَ",
      "contents": "Jenguklah orang sakit dan antarkan jenazah, karena hal itu akan mengingatkan kalian pada kehidupan akhirat."
    },
    {
      "number": 7,
      "arab": "مَنْ لاَ يَشْكُرِ النَّاسَ لاَ يَشْكُرِ اللَّهَ",
      "contents": "Barangsiapa yang tidak bersyukur (berterima kasih) kepada manusia, maka dia tidak bersyukur kepada Allah."
    },
    {
      "number": 8,
      "arab": "لاَ يَدْخُلُ الْجَنَّةَ مَنْ كَانَ فِي قَلْبِهِ مِثْقَالُ ذَرَّةٍ مِنْ كِبْرٍ",
      "contents": "Tidak akan masuk surga orang yang di dalam hatinya terdapat kesombongan seberat biji sawi."
    },
    {
      "number": 9,
      "arab": "أَكْثِرُوا ذِكْرَ هَاذِمِ اللَّذَّاتِ يَعْنِي الْمَوْتَ",
      "contents": "Perbanyaklah mengingat pemutus segala kelezatan dunia, yaitu kematian."
    },
    {
      "number": 10,
      "arab": "اللَّهُمَّ إِنَّكَ عَفُوٌّ تُحِبُّ الْعَفْوَ فَاعْفُ عَنِّي",
      "contents": "Ya Allah, sesungguhnya Engkau Maha Pemaaf dan menyukai kemaafan, maka maafkanlah aku."
    }
  ],
  "ahmad": [
    {
      "number": 1,
      "arab": "إِنَّ اللَّهَ كَتَبَ الإِحْسَانَ عَلَى كُلِّ شَيْءٍ",
      "contents": "Sesungguhnya Allah mewajibkan berlaku baik (ihsan) dalam segala hal."
    },
    {
      "number": 2,
      "arab": "مَا أَنْزَلَ اللَّهُ دَاءً إِلاَّ أَنْزَلَ لَهُ شِفَاءً",
      "contents": "Tidaklah Allah menurunkan suatu penyakit melainkan Dia juga menurunkan obat penawarnya."
    },
    {
      "number": 3,
      "arab": "إِنَّمَا بُعِثْتُ لأُتَمِّمَ صَالِحَ الأَخْلاَقِ",
      "contents": "Sesungguhnya aku diutus hanya untuk menyempurnakan kemuliaan akhlak."
    },
    {
      "number": 4,
      "arab": "إِنَّ اللَّهَ رَفِيقٌ يُحِبُّ الرِّفْقَ فِي الأَمْرِ كُلِّهِ",
      "contents": "Sesungguhnya Allah Maha Lembut dan menyukai kelembutan dalam segala urusan."
    },
    {
      "number": 5,
      "arab": "مَنْ يَحْرِمِ الرِّفْقَ يَحْرِمِ الْخَيْرَ كُلَّهُ",
      "contents": "Barangsiapa yang dihalangi dari sikap lemah lembut, maka dia dihalangi dari seluruh kebaikan."
    },
    {
      "number": 6,
      "arab": "أَفْشُوا السَّلاَمَ وَأَطْعِمُوا الطَّعَامَ وَكُونُوا إِخْوَانًا كَمَا أَمَرَكُمُ اللَّهُ",
      "contents": "Sebarkanlah salam, berilah makan, dan jadilah kalian bersaudara sebagaimana yang diperintahkan Allah."
    },
    {
      "number": 7,
      "arab": "اتَّقِ الدَّعْوَةَ الْمَظْلُومِ فَإِنَّهَا لَيْسَ بَيْنَهَا وَبَيْنَ اللَّهِ حِجَابٌ",
      "contents": "Takutlah terhadap doa orang yang terzhalimi, karena sesungguhnya tidak ada pembatas antara doanya dengan Allah."
    },
    {
      "number": 8,
      "arab": "مَنْ صَامَ رَمَضَانَ إِيمَانًا وَاحْتِسَابًا غُفِرَ لَهُ مَا تَقَدَّمَ مِنْ ذَنْبِهِ",
      "contents": "Barangsiapa berpuasa di bulan Ramadhan karena iman dan mengharap pahala dari Allah, niscaya dosa-dosanya yang telah lalu akan diampuni."
    },
    {
      "number": 9,
      "arab": "الْحَيَاءُ كُلُّهُ خَيْرٌ",
      "contents": "Sifat malu itu seluruhnya mendatangkan kebaikan."
    },
    {
      "number": 10,
      "arab": "ارْضَ بِمَا قَسَمَ اللَّهُ لَكَ تَكُنْ أَغْنَى النَّاسِ",
      "contents": "Ridhailah apa yang dibagikan Allah untukmu, niscaya kamu akan menjadi orang yang paling kaya (merasa cukup)."
    }
  ],
  "darimi": [
    {
      "number": 1,
      "arab": "فَضْلُ الْعِلْمِ أَحَبُّ إِلَيَّ مِنْ فَضْلِ الْعِبَادَةِ",
      "contents": "Keutamaan ilmu lebih aku cintai daripada keutamaan ibadah (tanpa ilmu)."
    },
    {
      "number": 2,
      "arab": "اقْرَءُوا الْقُرْآنَ فَإِنَّهُ يَأْتِي يَوْمَ الْقِيَامَةِ شَفِيعًا لأَصْحَابِهِ",
      "contents": "Bacalah Al-Quran, karena sesungguhnya ia akan datang pada hari kiamat memberi syafaat bagi para pembacanya."
    },
    {
      "number": 3,
      "arab": "مَنْ دَلَّ عَلَى خَيْرٍ فَلَهُ مِثْلُ أَجْرِ فَاعِلِهِ",
      "contents": "Barangsiapa menunjukkan kepada kebaikan, maka baginya pahala yang sama seperti orang yang melakukannya."
    },
    {
      "number": 4,
      "arab": "فَعَلَيْكُمْ بِسُنَّتِي وَسُنَّةِ الْخُلَفَاءِ الرَّاشِدِينَ الْمَهْدِيِّينَ",
      "contents": "Maka hendaklah kalian berpegang teguh dengan sunnahku dan sunnah Khulafaur Rasyidin yang mendapat petunjuk."
    },
    {
      "number": 5,
      "arab": "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيُحْسِنْ إِلَى جَارِهِ",
      "contents": "Barangsiapa beriman kepada Allah dan hari akhir, hendaklah dia berbuat baik kepada tetangganya."
    },
    {
      "number": 6,
      "arab": "بَلِّغُوا عَنِّي وَلَوْ آيَةً",
      "contents": "Sampaikanlah dariku walau hanya satu ayat."
    },
    {
      "number": 7,
      "arab": "الدُّنْيَا مَتَاعٌ وَخَيْرُ مَتَاعِ الدُّنْيَا الْمَرْأَةُ الصَّالِحَةُ",
      "contents": "Dunia ini adalah perhiasan, dan sebaik-baik perhiasan dunia adalah wanita yang saleha."
    },
    {
      "number": 8,
      "arab": "أَكْمَلُ الْمُؤْمِنِينَ إِيمَانًا أَحْسَنُهُمْ خُلُقًا",
      "contents": "Orang mukmin yang paling sempurna imannya adalah yang paling baik akhlaknya."
    },
    {
      "number": 9,
      "arab": "تَرَكْتُ فِيكُمْ أَمْرَيْنِ لَنْ تَضِلُّوا مَا تَمَسَّكْتُمْ بِهِمَا كِتَابَ اللَّهِ وَسُنَّةَ نَبِيِّهِ",
      "contents": "Aku tinggalkan untuk kalian dua perkara yang kalian tidak akan tersesat selama berpegang teguh pada keduanya: Kitab Allah (Al-Quran) dan Sunnah Nabi-Nya."
    },
    {
      "number": 10,
      "arab": "مَنْ يُرِدِ اللَّهُ بِهِ خَيْرًا يُفَقِّهْهُ فِي الدِّينِ",
      "contents": "Barangsiapa yang dikehendaki kebaikan oleh Allah, maka Dia akan memahamkannya dalam urusan agama."
    }
  ],
  "malik": [
    {
      "number": 1,
      "arab": "إِنَّمَا بُعِثْتُ لأُتَمِّمَ مَكَارِمَ الأَخْلاَقِ",
      "contents": "Sesungguhnya aku diutus hanya untuk menyempurnakan akhlak yang mulia."
    },
    {
      "number": 2,
      "arab": "تَرَكْتُ فِيكُمْ أَمْرَيْنِ لَنْ تَضِلُّوا مَا تَمَسَّكْتُمْ بِهِمَا كِتَابَ اللَّهِ وَسُنَّةَ رَسُولِهِ",
      "contents": "Aku tinggalkan untuk kalian dua perkara yang kalian tidak akan tersesat selama berpegang teguh pada keduanya: Kitab Allah dan Sunnah Rasul-Nya."
    },
    {
      "number": 3,
      "arab": "لاَ يَخْطُبُ أَحَدُكُمْ عَلَى خِطْبَةِ أَخِيهِ",
      "contents": "Janganlah salah seorang dari kalian melamar wanita yang sedang dilamar oleh saudaranya."
    },
    {
      "number": 4,
      "arab": "مَنْ مَاتَ وَهُوَ يُحِبُّ أَنْ لاَ يُشْرِكَ بِاللَّهِ شَيْئًا دَخَلَ الْجَنَّةَ",
      "contents": "Barangsiapa meninggal dunia dalam keadaan tidak menyekutukan Allah dengan sesuatu pun, niscaya ia akan masuk surga."
    },
    {
      "number": 5,
      "arab": "تَصَافَحُوا يَذْهَبِ الْغِلُّ وَتَهَادَوْا تَحَابُّوا وَتَذْهَبِ الشَّحْنَاءُ",
      "contents": "Saling bersalamanlah kalian niscaya akan hilang rasa dendam, dan saling memberi hadiahlah kalian niscaya akan saling mencintai dan hilang rasa permusuhan."
    },
    {
      "number": 6,
      "arab": "لاَ تَبَاغَضُوا وَلاَ تَحَاسَدُوا وَلاَ تَدَابَرُوا وَكُونُوا عِبَادَ اللَّهِ إِخْوَانًا",
      "contents": "Janganlah kalian saling membenci, saling mendengki, saling membelakangi, dan jadilah hamba-hamba Allah yang bersaudara."
    },
    {
      "number": 7,
      "arab": "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ",
      "contents": "Barangsiapa beriman kepada Allah dan hari akhir, hendaklah dia berkata baik atau diam."
    },
    {
      "number": 8,
      "arab": "إِنَّ اللَّهَ لاَ يَنْظُرُ إِلَى صُوَرِكُمْ وَلَكِنْ يَنْظُرُ إِلَى قُلُوبِكُمْ",
      "contents": "Sesungguhnya Allah tidak melihat rupa kalian, melainkan Dia melihat ke dalam hati kalian."
    },
    {
      "number": 9,
      "arab": "لاَ ضَرَرَ وَلاَ ضِرَارَ",
      "contents": "Tidak boleh membahayakan diri sendiri dan tidak boleh membahayakan orang lain."
    },
    {
      "number": 10,
      "arab": "أَفْضَلُ الأَعْمَالِ الْحُبُّ فِي اللَّهِ وَالْبُغْضُ فِي اللَّهِ",
      "contents": "Amalan yang paling utama adalah cinta karena Allah dan benci karena Allah."
    }
  ],
  "arbain-nawawi": [
    {
      "number": 1,
      "arab": "إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى",
      "contents": "Sesungguhnya amalan itu tergantung pada niat, dan bagi setiap orang adalah apa yang dia niatkan."
    },
    {
      "number": 2,
      "arab": "مَنْ كَانَتْ هِمَّتُهُ الدُّنْيَا فَلِلَّهِ الدُّنْيَا، وَمَنْ كَانَتْ هِمَّتُهُ الآخِرَةَ فَلِلَّهِ الآخِرَةِ، وَمَنْ كَانَتْ هِمَّتُهُ الْمَسْلِمِينَ فَلِلَّهِ الْمَسْلِمِينَ",
      "contents": "Barangsiapa niatnya dunia maka untuk dunia, barangsiapa niatnya akhirat maka untuk akhirat, dan barangsiapa niatnya untuk kaum muslimin maka untuk kaum muslimin."
    },
    {
      "number": 3,
      "arab": "إِنَّ اللَّهَ لَا يَنْظُرُ إِلَى صُوَرِكُمْ وَأَمْوَالِكُمْ وَلَكِنْ يَنْظُرُ إِلَى قُلُوبِكُمْ وَأَعْمَالِكُمْ",
      "contents": "Sesungguhnya Allah tidak melihat kepada rupa-rupamu dan hartamu, tapi Dia melihat kepada hatimu dan amalmu."
    },
    {
      "number": 4,
      "arab": "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلَا يُؤْذِي جَارَهُ",
      "contents": "Barangsiapa beriman kepada Allah dan hari akhir, maka janganlah ia menyakiti tetangganya."
    },
    {
      "number": 5,
      "arab": "مِنْ حُسْنِ إِسْلَامِ الْمَرْءِ تَرْكُهُ مَا لاَ يَعْنِيهِ",
      "contents": "Termasuk baiknya Islam seseorang adalah meninggalkan apa yang tidak bermanfaat baginya."
    },
    {
      "number": 6,
      "arab": "النَّاسُ إِخْوَانٌ، فَاشْتَرِكُوا فِي الْبِرِّ وَالْتَّقْوَى",
      "contents": "Manusia itu bersaudara, maka berilah mereka bagian dalam kebaikan dan takwa."
    },
    {
      "number": 7,
      "arab": "لاَ تَحَاسَدُوا، وَلاَ تَبَاغَضُوا، وَلاَ تَدَابَرُوا، وَكُونُوا عِبَادَ اللَّهِ إِخْوَانًا",
      "contents": "Jangan saling dengki, jangan saling membenci, jangan saling berpaling, tetapi jadilah hamba-hamba Allah yang bersaudara."
    },
    {
      "number": 8,
      "arab": "عَلَى الْمُسْلِمِ حَرَجٌ، وَلَا يُسَاخِطُهُ، وَلَا يُهـِينُهُ، وَلَا يُكْفِرُهُ",
      "contents": "Terhadap seorang muslim ada hak: jangan membuatnya susah, jangan memarahinya, jangan menghina, dan jangan mencela."
    },
    {
      "number": 9,
      "arab": "حُفْظُ الْلِسَانِ أَوَّلُ جُزْءِ السَّلَامَةِ",
      "contents": "Menjaga lidah adalah bagian pertama dari keselamatan."
    },
    {
      "number": 10,
      "arab": "الدُّعَاءُ هُوَ الْعِبَادَةُ",
      "contents": "Doa adalah ibadah."
    }
  ],
  "riyadush-shalihin": [
    {
      "number": 1,
      "arab": "الْعِلْمُ نُورٌ، وَالْجَهْلُ ظُلْمَةٌ",
      "contents": "Ilmu itu cahaya, dan kebodohan itu kegelapan."
    },
    {
      "number": 2,
      "arab": "مَنْ تَرَكَ شَيْئًا لِلَّهِ عَزَّ وَجَلَّ، أَعْطَاهُ اللَّهُ خَيْرًا مِمَّا تَرَكَ",
      "contents": "Barangsiapa meninggalkan sesuatu karena Allah, maka Allah memberinya yang lebih baik daripada yang ditinggalkan."
    },
    {
      "number": 3,
      "arab": "الصَّبْرُ ضِئْرٌ، وَالْحَمْدُ وَاسِعٌ",
      "contents": "Sabar itu sempit, dan pujian itu luas."
    },
    {
      "number": 4,
      "arab": "الْمُؤْمِنُ مِرْآةُ الْمُؤْمِنِ، وَالْمُؤْمِنُ أَخُو الْمُؤْمِنِ",
      "contents": "Seorang mukmin adalah cermin bagi mukmin lainnya, dan seorang mukmin adalah saudara bagi mukmin lainnya."
    },
    {
      "number": 5,
      "arab": "لاَ يَحْقِرَنَّ أَحَدُكُمْ صَغِيرَ الْمَعْرُوفِ",
      "contents": "Janganlah salah seorang di antara kalian meremehkan kebaikan kecil."
    },
    {
      "number": 6,
      "arab": "اللَّهُ جَمِيلٌ يُحِبُّ الْجَمَالَ",
      "contents": "Allah itu indah dan mencintai keindahan."
    },
    {
      "number": 7,
      "arab": "أَفْضَلُ النَّاسِ أَنْفَعُهُمْ لِلنَّاسِ",
      "contents": "Sebaik-baik manusia adalah yang paling bermanfaat bagi manusia lainnya."
    },
    {
      "number": 8,
      "arab": "رَضَا اللَّهِ فِي رِضَا الْوَالِدِ، وَسَخَطُ اللَّهِ فِي سَخَطِ الْوَالِدِ",
      "contents": "Ridha Allah berada pada ridha orang tua, dan murka Allah berada pada murka orang tua."
    }
  ]
};
