import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/features/pilar_islam/data/models/doa_model.dart';
import 'package:uas_projekk/features/pilar_islam/logic/pilar_islam_provider.dart';
import 'package:uas_projekk/modules/dzikir/niat_salat_model.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';
class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);

    return Consumer<PilarIslamProvider>(
      builder: (context, pilar, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: GridPatternPainter(
                  color: settings.isDarkMode ? Colors.white10 : Colors.grey.withOpacity(0.05),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  _buildFloatingAppBar(settings, theme),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 15),
                          _buildCategoryScroll(settings, theme, pilar),
                          const SizedBox(height: 30),
                          _buildSectionHeader("Niat Salat", true, theme),
                          const SizedBox(height: 15),
                          _buildNiatCarousel(settings, theme),
                          const SizedBox(height: 35),
                          _buildSectionHeader("Daftar Doa", false, theme),
                          const SizedBox(height: 15),
                          _buildFilteredDoaList(settings, theme, pilar),
                          const SizedBox(height: 20),
                          _buildFeaturedBanner(),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
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
          Icon(Icons.menu, color: settings.isDarkMode ? Colors.white : AppTheme.textDark),
          Text(
            "Pilar Islam",
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: settings.isDarkMode ? Colors.white : AppTheme.textDark,
            ),
          ),
          CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage(settings.profilePicUrl),
            backgroundColor: settings.isDarkMode ? Colors.white10 : const Color(0xFFF5F9F9),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryScroll(SettingsProvider settings, ThemeData theme, PilarIslamProvider provider) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: provider.categories.map((category) {
          final bool isSelected = provider.selectedCategory == category;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () => provider.selectCategory(category),
              borderRadius: BorderRadius.circular(25),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0F4D3A) : theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : (settings.isDarkMode ? Colors.white10 : Colors.grey[200]!),
                  ),
                ),
                child: Text(
                  category,
                  style: GoogleFonts.inter(
                    color: isSelected ? Colors.white : (settings.isDarkMode ? Colors.white70 : AppTheme.textGrey),
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool showAll, ThemeData theme) {
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

  Widget _buildNiatCarousel(SettingsProvider settings, ThemeData theme) {
    final list = NiatData.daftarNiat;
    return SizedBox(
      height: 480,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final niat = list[index];
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(settings.isDarkMode ? 0.2 : 0.03),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: settings.isDarkMode ? Colors.white10 : const Color(0xFFFDF7E7),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconData(niat.icon),
                    color: const Color(0xFFC19E4A),
                    size: 20,
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  niat.nama,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: Center(
                    child: Text(
                      niat.arab,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.amiri(
                        fontSize: settings.arabicFontSize + 4,
                        height: 2.2,
                        fontWeight: FontWeight.bold,
                        color: settings.isDarkMode ? const Color(0xFF4DB6AC) : const Color(0xFF0F4D3A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "\"${niat.latin}\"",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
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

  IconData _getIconData(String name) {
    switch (name) {
      case "wb_sunny_outlined": return Icons.wb_sunny_outlined;
      case "wb_sunny": return Icons.wb_sunny;
      case "cloud_outlined": return Icons.cloud_outlined;
      case "nights_stay_outlined": return Icons.nights_stay_outlined;
      case "brightness_3": return Icons.brightness_3;
      default: return Icons.wb_sunny_outlined;
    }
  }

  Widget _buildFilteredDoaList(SettingsProvider settings, ThemeData theme, PilarIslamProvider provider) {
    final list = provider.filteredDoa;
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "Data untuk kategori '${provider.selectedCategory}' belum tersedia",
            style: GoogleFonts.inter(color: Colors.grey),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: list.map((doa) => _buildDoaCard(doa, settings, theme)).toList(),
      ),
    );
  }

  Widget _buildDoaCard(DoaModel doa, SettingsProvider settings, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doa.category.toUpperCase(),
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppTheme.textGrey,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    doa.title,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: settings.isDarkMode ? Colors.white10 : Colors.grey[100],
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
              doa.arabicText,
              textAlign: TextAlign.right,
              style: GoogleFonts.amiri(
                fontSize: settings.arabicFontSize,
                height: 1.8,
                color: settings.isDarkMode ? const Color(0xFF4DB6AC) : const Color(0xFF0F4D3A),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 15),
          if (doa.target > 1)
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: settings.isDarkMode ? Colors.white10 : const Color(0xFFF0F4F2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Baca ${doa.target}x',
                  style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textGrey),
                ),
              ),
            ),
          if (settings.showTranslation) ...[
            const SizedBox(height: 15),
            const Divider(height: 1),
            const SizedBox(height: 15),
            Text(
              "Artinya:",
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              doa.translation,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: theme.colorScheme.onSurface.withOpacity(0.7),
                height: 1.6,
              ),
            ),
          ],
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
  final Color color;
  GridPatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
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
