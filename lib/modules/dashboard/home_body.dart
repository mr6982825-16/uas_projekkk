import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/features/pilar_islam/data/models/doa_model.dart';
import 'package:uas_projekk/features/pilar_islam/logic/pilar_islam_provider.dart';
import 'package:uas_projekk/features/pilar_islam/presentation/screens/doa_detail_screen.dart';
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
                          if (pilar.isLoading)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: CircularProgressIndicator(color: Color(0xFF0F4D3A)),
                              ),
                            )
                          else ...[
                            // Dynamic section based on selected category
                            if (pilar.selectedCategory == 'Shalat') ...[
                              _buildSectionHeader("Niat Salat", true, theme),
                              const SizedBox(height: 15),
                              _buildNiatCarousel(settings, theme),
                              const SizedBox(height: 35),
                            ] else if (pilar.selectedCategory == 'Perjalanan') ...[
                              _buildSectionHeader("Panduan Shalat Jamak & Qashar", false, theme),
                              const SizedBox(height: 15),
                              _buildPanduanSafarCarousel(settings, theme),
                              const SizedBox(height: 35),
                            ] else ...[
                              _buildDailyDzikirCard(settings, theme, pilar),
                              const SizedBox(height: 35),
                            ],
                            _buildSectionHeader(
                              pilar.selectedCategory == 'Shalat'
                                  ? "Daftar Wirid Setelah Shalat"
                                  : "Daftar Dzikir & Doa",
                              false,
                              theme,
                            ),
                            const SizedBox(height: 15),
                            _buildFilteredDoaList(context, settings, theme, pilar),
                          ],
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

  Widget _buildPanduanSafarCarousel(SettingsProvider settings, ThemeData theme) {
    final panduanList = [
      {
        "title": "Ketentuan Jamak",
        "description": "Boleh menjamak shalat (menggabungkan dua shalat di satu waktu) bagi musafir yang menempuh jarak minimal 81-89 km.",
        "icon": Icons.info_outline
      },
      {
        "title": "Jamak Taqdim",
        "description": "Menggabungkan shalat kedua ke shalat pertama (contoh: shalat Ashar dikerjakan di waktu Dzuhur). Harus berurutan.",
        "icon": Icons.arrow_forward
      },
      {
        "title": "Jamak Takhir",
        "description": "Menggabungkan shalat pertama ke shalat kedua (contoh: shalat Maghrib dikerjakan di waktu Isya). Niat dilakukan di waktu shalat pertama.",
        "icon": Icons.arrow_back
      },
      {
        "title": "Ketentuan Qashar",
        "description": "Meringkas shalat 4 rakaat menjadi 2 rakaat (Subuh & Maghrib tidak bisa diqashar). Berlaku selama perjalanan.",
        "icon": Icons.bolt
      }
    ];

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: panduanList.length,
        itemBuilder: (context, index) {
          final item = panduanList[index];
          return Container(
            width: 280,
            margin: const EdgeInsets.only(right: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(settings.isDarkMode ? 0.2 : 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(item["icon"] as IconData, color: const Color(0xFFC19E4A), size: 24),
                    const SizedBox(width: 10),
                    Text(
                      item["title"] as String,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Text(
                    item["description"] as String,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDailyDzikirCard(SettingsProvider settings, ThemeData theme, PilarIslamProvider provider) {
    final list = provider.filteredDoa;
    if (list.isEmpty) return const SizedBox.shrink();

    final mainDoa = list.first;
    final int count = provider.getCount(mainDoa.id);
    final bool isCompleted = count >= mainDoa.target;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: settings.isDarkMode
              ? [const Color(0xFF0F4D3A), const Color(0xFF004D40)]
              : [const Color(0xFF0F4D3A), const Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F4D3A).withOpacity(0.3),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Rekomendasi Amalan",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.refresh_rounded, color: Colors.white60),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  provider.resetAllCountsInCategory(provider.selectedCategory);
                },
                tooltip: "Reset semua zikir di kategori ini",
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            mainDoa.title,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            mainDoa.translation,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCompleted ? "Alhamdulillah, Selesai!" : "Kemajuan: $count / ${mainDoa.target}",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0F4D3A),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onPressed: () {
                  if (count < mainDoa.target) {
                    HapticFeedback.lightImpact();
                    provider.incrementCount(mainDoa.id, mainDoa.target);
                    if (count + 1 >= mainDoa.target) {
                      HapticFeedback.vibrate();
                    }
                  }
                },
                child: Text(
                  isCompleted ? "Selesai" : "+1 Ketuk",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
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

  Widget _buildFilteredDoaList(BuildContext context, SettingsProvider settings, ThemeData theme, PilarIslamProvider provider) {
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
        children: list.map((doa) => _buildDoaCard(context, doa, settings, theme, provider)).toList(),
      ),
    );
  }

  Widget _buildDoaCard(BuildContext context, DoaModel doa, SettingsProvider settings, ThemeData theme, PilarIslamProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DoaDetailScreen(doa: doa),
              ),
            );
          },
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.all(25),
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
                const SizedBox(height: 20),
                _buildCardCounter(context, doa, settings, theme, provider),
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
          ),
        ),
      ),
    );
  }

  Widget _buildCardCounter(BuildContext context, DoaModel doa, SettingsProvider settings, ThemeData theme, PilarIslamProvider provider) {
    final int count = provider.getCount(doa.id);
    final bool isCompleted = count >= doa.target;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color(0xFF4CAF50).withOpacity(0.1)
                    : (settings.isDarkMode ? Colors.white10 : const Color(0xFFF0F4F2)),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isCompleted ? const Color(0xFF4CAF50).withOpacity(0.3) : Colors.transparent,
                ),
              ),
              child: Row(
                children: [
                  if (isCompleted)
                    const Icon(Icons.check, size: 14, color: Color(0xFF4CAF50))
                  else
                    Icon(Icons.fingerprint, size: 14, color: settings.isDarkMode ? Colors.white60 : const Color(0xFF0F4D3A)),
                  const SizedBox(width: 6),
                  Text(
                    isCompleted ? 'Selesai' : 'Dibaca: $count / ${doa.target}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? const Color(0xFF4CAF50) : (settings.isDarkMode ? Colors.white70 : AppTheme.textGrey),
                    ),
                  ),
                ],
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 8),
              IconButton(
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.refresh, size: 18, color: Colors.grey),
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  provider.resetCount(doa.id);
                },
              ),
            ],
          ],
        ),
        if (!isCompleted)
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F4D3A),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: Text(
              "+1",
              style: GoogleFonts.inter(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              HapticFeedback.lightImpact();
              provider.incrementCount(doa.id, doa.target);
              if (count + 1 >= doa.target) {
                HapticFeedback.vibrate();
              }
            },
          ),
      ],
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

