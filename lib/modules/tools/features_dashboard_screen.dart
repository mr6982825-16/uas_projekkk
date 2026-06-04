import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/modules/quran/quran_screen.dart';
import 'package:uas_projekk/modules/hadith/hadith_list_screen.dart';
import 'package:uas_projekk/modules/dzikir/dzikir_pagi_petang_screen.dart';
import 'package:uas_projekk/modules/dzikir/sholat_sunnah_screen.dart';
import 'package:uas_projekk/modules/dzikir/dzikir_model.dart';
import 'package:uas_projekk/modules/dzikir/doa_harian_screen.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';
import 'package:uas_projekk/features/debt_tracker/presentation/screens/debt_dashboard_screen.dart';
import 'package:uas_projekk/features/faraid_calculator/presentation/screens/faraid_wizard_screen.dart';
import 'package:uas_projekk/features/islamic_maps/presentation/screens/maps_screen.dart';

class FeaturesDashboardScreen extends StatelessWidget {
  const FeaturesDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: StarPatternPainter(color: settings.isDarkMode ? Colors.white10 : Colors.grey.withOpacity(0.04)),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildFloatingAppBar(settings, theme),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        _buildDailyReflectionCard(settings, theme),
                        const SizedBox(height: 30),
                        _buildSectionHeader("Explore Sanctuary", theme),
                        const SizedBox(height: 15),
                        _buildFeaturesGrid(context, settings, theme),
                        const SizedBox(height: 30),
                        _buildSectionHeader("Continue Reading", theme, showViewAll: true),
                        const SizedBox(height: 15),
                        _buildLastReadCard(settings, theme),
                        const SizedBox(height: 25),
                        _buildWeeklyThemeBanner(),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingAppBar(SettingsProvider settings, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(settings.isDarkMode ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.menu, color: theme.primaryColor),
          Text(
            "Pilar Islam",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: theme.primaryColor,
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(settings.profilePicUrl),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyReflectionCard(SettingsProvider settings, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(settings.isDarkMode ? 0.2 : 0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
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
                    "TODAY IN HIJRI",
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: const Color(0xFF8B7355),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "14 Ramadan 1445 AH",
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: settings.isDarkMode ? Colors.white10 : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.calendar_today_outlined, size: 20, color: Color(0xFF8B7355)),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              "فَإِنَّ مَعَ الْعُسْرِ يُسْرًا",
              style: GoogleFonts.amiri(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Container(
            padding: const EdgeInsets.only(left: 15),
            decoration: const BoxDecoration(
              border: Border(left: BorderSide(color: Color(0xFFD4AF37), width: 3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "\"For indeed, with hardship [will be] ease.\"",
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Surah Al-Inshirah [94:5]",
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Share.share(
                  "\"For indeed, with hardship [will be] ease.\"\n- Surah Al-Inshirah [94:5]\n\nShared from Pilar Islam App",
                );
              },
              icon: const Icon(Icons.share_outlined, size: 18, color: Colors.white),
              label: Text(
                "Share Reflection",
                style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme, {bool showViewAll = false}) {
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
              color: theme.colorScheme.onBackground,
            ),
          ),
          if (showViewAll)
            Text(
              "View All",
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

  Widget _buildFeaturesGrid(BuildContext context, SettingsProvider settings, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        childAspectRatio: 1.3,
        children: [
          _buildFeatureCard(Icons.menu_book_outlined, "Al-Quran", "The Noble Revelation", theme, settings, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const QuranScreen()));
          }),
          _buildFeatureCard(Icons.library_books_outlined, "Hadist", "Prophetic Wisdom", theme, settings, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HadithListScreen()));
          }),
          _buildFeatureCard(Icons.auto_stories_outlined, "Kumpulan Doa", "100+ Doa API", theme, settings, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DoaHarianScreen()));
          }),
          _buildFeatureCard(Icons.pan_tool_alt_outlined, "Dzikir", "Daily Supplications", theme, settings, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DzikirPagiPetangScreen(
              title: "Dzikir Pagi", 
              dzikirList: DzikirData.dzikirPagi
            )));
          }),
          _buildFeatureCard(Icons.mosque_outlined, "Niat Salat", "Prayer Intentions", theme, settings, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SholatSunnahScreen()));
          }),
          _buildFeatureCard(Icons.account_balance_wallet_outlined, "Utang Piutang", "Debt Tracker", theme, settings, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const DebtDashboardScreen()));
          }),
          _buildFeatureCard(Icons.calculate_outlined, "Kalkulator Waris", "Faraid Smart System", theme, settings, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const FaraidWizardScreen()));
          }),
          _buildFeatureCard(Icons.map_outlined, "Peta Islami", "Masjid & Restoran Halal", theme, settings, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MapsScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String subtitle, ThemeData theme, SettingsProvider settings, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(settings.isDarkMode ? 0.2 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: settings.isDarkMode ? Colors.white10 : const Color(0xFFF8FBFB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF8B7355), size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLastReadCard(SettingsProvider settings, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(settings.isDarkMode ? 0.2 : 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: settings.isDarkMode ? Colors.white10 : const Color(0xFFFDF7E7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.chrome_reader_mode_outlined, color: Color(0xFFC19E4A)),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "LAST READ",
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Surah Al-Kahf",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14, color: theme.colorScheme.onSurface),
                ),
                Text(
                  "Ayah 24 of 110",
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const Icon(Icons.bookmark_outline, color: Color(0xFFD4E5E1)),
        ],
      ),
    );
  }

  Widget _buildWeeklyThemeBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&q=80&w=800"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black38, BlendMode.darken),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFC19E4A).withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Weekly Theme",
                style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Cultivating Inner Peace through Dhikr",
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Discover 5 essential morning adhkar to transform your daily focus.",
              style: GoogleFonts.inter(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class StarPatternPainter extends CustomPainter {
  final Color color;
  StarPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const double spacing = 60;
    
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        _drawStar(canvas, Offset(x, y), paint);
      }
    }
  }

  void _drawStar(Canvas canvas, Offset center, Paint paint) {
    const double size = 15;
    canvas.drawLine(Offset(center.dx - size, center.dy), Offset(center.dx + size, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - size), Offset(center.dx, center.dy + size), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
