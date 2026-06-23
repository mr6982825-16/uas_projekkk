const hadithBooksData = [
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
  "arbain-nawawi": [
    {
      "number": 1,
      "arab": "إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى",
      "contents": "Sesungguhnya amalan itu tergantung pada niat, dan bagi setiap orang adalah apa yang dia niatkan.",
    },
    {
      "number": 2,
      "arab": "مَنْ كَانَتْ هِمَّتُهُ الدُّنْيَا فَلِلَّهِ الدُّنْيَا، وَمَنْ كَانَتْ هِمَّتُهُ الآخِرَةَ فَلِلَّهِ الآخِرَةِ، وَمَنْ كَانَتْ هِمَّتُهُ الْمَسْلِمِينَ فَلِلَّهِ الْمَسْلِمِينَ",
      "contents": "Barangsiapa niatnya dunia maka untuk dunia, barangsiapa niatnya akhirat maka untuk akhirat, dan barangsiapa niatnya untuk kaum muslimin maka untuk kaum muslimin.",
    },
    {
      "number": 3,
      "arab": "إِنَّ اللَّهَ لَا يَنْظُرُ إِلَى صُوَرِكُمْ وَأَمْوَالِكُمْ وَلَكِنْ يَنْظُرُ إِلَى قُلُوبِكُمْ وَأَعْمَالِكُمْ",
      "contents": "Sesungguhnya Allah tidak melihat kepada rupa-rupamu dan hartamu, tapi Dia melihat kepada hatimu dan amalmu.",
    },
    {
      "number": 4,
      "arab": "مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الآخِرِ فَلَا يُؤْذِي جَارَهُ",
      "contents": "Barangsiapa beriman kepada Allah dan hari akhir, maka janganlah ia menyakiti tetangganya.",
    },
    {
      "number": 5,
      "arab": "مِنْ حُسْنِ إِسْلَامِ الْمَرْءِ تَرْكُهُ مَا لاَ يَعْنِيهِ",
      "contents": "Termasuk baiknya Islam seseorang adalah meninggalkan apa yang tidak bermanfaat baginya.",
    },
    {
      "number": 6,
      "arab": "النَّاسُ إِخْوَانٌ، فَاشْتَرِكُوا فِي الْبِرِّ وَالْتَّقْوَى",
      "contents": "Manusia itu bersaudara, maka berilah mereka bagian dalam kebaikan dan takwa.",
    },
    {
      "number": 7,
      "arab": "لاَ تَحَاسَدُوا، وَلاَ تَبَاغَضُوا، وَلاَ تَدَابَرُوا، وَكُونُوا عِبَادَ اللَّهِ إِخْوَانًا",
      "contents": "Jangan saling dengki, jangan saling membenci, jangan saling berpaling, tetapi jadilah hamba-hamba Allah yang bersaudara.",
    },
    {
      "number": 8,
      "arab": "عَلَى الْمُسْلِمِ حَرَجٌ، وَلَا يُسَاخِطُهُ، وَلَا يُهـِينُهُ، وَلَا يُكْفِرُهُ",
      "contents": "Terhadap seorang muslim ada hak: jangan membuatnya susah, jangan memarahinya, jangan menghina, dan jangan mencela.",
    },
    {
      "number": 9,
      "arab": "حُفْظُ الْلِسَانِ أَوَّلُ جُزْءِ السَّلَامَةِ",
      "contents": "Menjaga lidah adalah bagian pertama dari keselamatan.",
    },
    {
      "number": 10,
      "arab": "الدُّعَاءُ هُوَ الْعِبَادَةُ",
      "contents": "Doa adalah ibadah.",
    },
  ],
  "riyadush-shalihin": [
    {
      "number": 1,
      "arab": "الْعِلْمُ نُورٌ، وَالْجَهْلُ ظُلْمَةٌ",
      "contents": "Ilmu itu cahaya, dan kebodohan itu kegelapan.",
    },
    {
      "number": 2,
      "arab": "مَنْ تَرَكَ شَيْئًا لِلَّهِ عَزَّ وَجَلَّ، أَعْطَاهُ اللَّهُ خَيْرًا مِمَّا تَرَكَ",
      "contents": "Barangsiapa meninggalkan sesuatu karena Allah, maka Allah memberinya yang lebih baik daripada yang ditinggalkan.",
    },
    {
      "number": 3,
      "arab": "الصَّبْرُ ضِئْرٌ، وَالْحَمْدُ وَاسِعٌ",
      "contents": "Sabar itu sempit, dan pujian itu luas.",
    },
    {
      "number": 4,
      "arab": "الْمُؤْمِنُ مِرْآةُ الْمُؤْمِنِ، وَالْمُؤْمِنُ أَخُو الْمُؤْمِنِ",
      "contents": "Seorang mukmin adalah cermin bagi mukmin lainnya, dan seorang mukmin adalah saudara bagi mukmin lainnya.",
    },
    {
      "number": 5,
      "arab": "لاَ يَحْقِرَنَّ أَحَدُكُمْ صَغِيرَ الْمَعْرُوفِ",
      "contents": "Janganlah salah seorang di antara kalian meremehkan kebaikan kecil.",
    },
    {
      "number": 6,
      "arab": "اللَّهُ جَمِيلٌ يُحِبُّ الْجَمَالَ",
      "contents": "Allah itu indah dan mencintai keindahan.",
    },
    {
      "number": 7,
      "arab": "أَفْضَلُ النَّاسِ أَنْفَعُهُمْ لِلنَّاسِ",
      "contents": "Sebaik-baik manusia adalah yang paling bermanfaat bagi manusia lainnya.",
    },
    {
      "number": 8,
      "arab": "رَضَا اللَّهِ فِي رِضَا الْوَالِدِ، وَسَخَطُ اللَّهِ فِي سَخَطِ الْوَالِدِ",
      "contents": "Ridha Allah berada pada ridha orang tua, dan murka Allah berada pada murka orang tua.",
    },
  ],
};
