import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_projekk/core/theme.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Pattern
        Positioned.fill(
          child: CustomPaint(
            painter: GridPatternPainter(),
          ),
        ),
        
        SafeArea(
          child: Column(
            children: [
              _buildFloatingAppBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _buildFilterChips(),
                      const SizedBox(height: 25),
                      _buildSectionHeader("Niat Salat", true),
                      const SizedBox(height: 15),
                      _buildNiatCarousel(),
                      const SizedBox(height: 30),
                      _buildSectionHeader("Doa Harian", false),
                      const SizedBox(height: 15),
                      _buildDoaList(),
                      const SizedBox(height: 20),
                      _buildFeaturedBanner(),
                      const SizedBox(height: 100), // Space for bottom nav
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingAppBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, color: AppTheme.textDark),
          Text(
            "Pilar Islam",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?u=pilarislam"),
            backgroundColor: Color(0xFFF5F9F9),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final List<String> categories = ["Pagi", "Malam", "Shalat", "Perjalanan", "Harian"];
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          bool isSelected = index == 0;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(categories[index]),
              selected: isSelected,
              onSelected: (val) {},
              selectedColor: const Color(0xFF0F4D3A),
              labelStyle: GoogleFonts.inter(
                color: isSelected ? Colors.white : AppTheme.textGrey,
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: isSelected ? Colors.transparent : Colors.grey[200]!),
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool showAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1B4332),
            ),
          ),
          if (showAll)
            Text(
              "Lihat Semua",
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF8B7355),
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildNiatCarousel() {
    return SizedBox(
      height: 480,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFDF7E7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.wb_sunny, color: Color(0xFFC19E4A), size: 20),
                ),
                const SizedBox(height: 15),
                Text(
                  "Salat Subuh",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: AppTheme.textDark,
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: Text(
                    "أُصَلِّى فَرْضَ الصُّبْحِ رَكْعَتَيْنِ مُسْتَقْبِلَ الْقِبْلَةِ أَدَاءً لِلَّهِ تَعَالَى",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(
                      fontSize: 32,
                      height: 2.2,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F4D3A),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "\"Ushalli fardhas subhi rak'ataini mustaqbilal qiblati adaa'an lillaahi ta'aalaa.\"",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: AppTheme.textGrey,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDoaList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildDoaCard(
            "PAGI & PETANG",
            "Doa Bangun Tidur",
            "اَلْحَمْدُ لِلَّهِ الَّذِيْ أَحْيَانَا بَعْدَ مَا أَمَاتَنَا وَإِلَيْهِ النُّشُوْرُ",
            "Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami dan kepada-Nya lah kami kembali."
          ),
          const SizedBox(height: 15),
          _buildDoaCard(
            "KEBERKAHAN",
            "Doa Sebelum Makan",
            "اللَّهُمَّ بَارِكْ لَنَا فِيْمَا رَزقتنا وَقِنَا عَذَابَ النَّارِ",
            "Ya Allah, berkahilah kami atas rezeki yang telah Engkau berikan kepada kami dan jagalah kami dari siksa api neraka."
          ),
        ],
      ),
    );
  }

  Widget _buildDoaCard(String category, String title, String arabic, String meaning) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppTheme.textGrey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textDark,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.bookmark_outline, size: 20, color: AppTheme.textGrey),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              arabic,
              textAlign: TextAlign.right,
              style: GoogleFonts.amiri(
                fontSize: 24,
                height: 1.8,
                color: const Color(0xFF0F4D3A),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 20),
          Text(
            "Artinya:",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: AppTheme.textDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "\"$meaning\"",
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppTheme.textGrey,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturedBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1542718610-a1d656d1884c?auto=format&fit=crop&q=80&w=800"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Text(
            "Mencari Kedamaian\nMelalui Lantunan Doa",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
        ),
      ),
    );
  }
}

class GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withOpacity(0.05)
      ..strokeWidth = 1;

    const double spacing = 40;
    const double crossSize = 4;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawLine(Offset(x - crossSize, y), Offset(x + crossSize, y), paint);
        canvas.drawLine(Offset(x, y - crossSize), Offset(x, y + crossSize), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
