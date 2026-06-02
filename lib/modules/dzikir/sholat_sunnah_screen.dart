import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/features/pilar_islam/data/datasources/prayer_intention_data.dart';
import 'package:uas_projekk/features/pilar_islam/data/models/prayer_intention_model.dart';
import 'package:uas_projekk/modules/dzikir/sholat_sunnah_model.dart';

class SholatSunnahScreen extends StatefulWidget {
  const SholatSunnahScreen({super.key});

  @override
  State<SholatSunnahScreen> createState() => _SholatSunnahScreenState();
}

class _SholatSunnahScreenState extends State<SholatSunnahScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> categories = ["Salat Wajib", "Rawatib", "Waktu/Keadaan", "Berjamaah/Momen", "Khusus", "Bacaan & Dzikir"];
  int _selectedJamakMode = 0;
  final List<String> _jamakModes = [
    PrayerIntentionData.jamakBiasa,
    PrayerIntentionData.jamakQashar,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 180,
              floating: false,
              pinned: true,
              backgroundColor: AppTheme.primaryColor,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  "Salat Sunnah",
                  style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppTheme.primaryColor, AppTheme.primaryColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -50,
                        top: -20,
                        child: Icon(
                          Icons.mosque,
                          size: 200,
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, bottom: 60),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Panduan Lengkap",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              "Ibadah Sunnah",
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  indicatorColor: AppTheme.primaryColor,
                  labelColor: AppTheme.primaryColor,
                  unselectedLabelColor: Colors.grey,
                  indicatorWeight: 3,
                  labelStyle: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                  tabs: categories.map((cat) => Tab(text: cat)).toList(),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: categories.map((cat) {
            if (cat == 'Khusus') {
              return _buildKhususTab();
            }

            final filteredList = SholatSunnahData.sunnahList
                .where((s) => s.category == cat)
                .toList();
            return _buildSholatList(filteredList);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSholatList(List<SholatSunnah> list) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.black.withOpacity(0.05)),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              title: Text(
                item.name,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppTheme.primaryColor,
                ),
              ),
              subtitle: Text(
                item.fadhilah ?? "Panduan Salat Sunnah",
                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
              ),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.menu_book, color: AppTheme.primaryColor, size: 20),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle("Niat Salat"),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            Text(
                              item.niatArab,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.amiri(
                                fontSize: 24,
                                height: 1.8,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item.niatLatin,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.primaryColor,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.niatTranslation,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildSectionTitle("Tata Cara / Rakaat"),
                      const SizedBox(height: 8),
                      Text(
                        item.tataCara,
                        style: GoogleFonts.inter(fontSize: 14, height: 1.6, color: Colors.black87),
                      ),
                      if (item.doaAfter != null) ...[
                        const SizedBox(height: 20),
                        _buildSectionTitle("Doa Setelah Salat"),
                        const SizedBox(height: 8),
                        Text(
                          item.doaAfter!,
                          style: GoogleFonts.inter(fontSize: 14, height: 1.6, color: Colors.black87),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildKhususTab() {
    final selectedMode = _jamakModes[_selectedJamakMode];
    final intentionList = PrayerIntentionData.getByMode(selectedMode);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildKhususHeader(selectedMode),
        const SizedBox(height: 16),
        _buildWarningBanner(),
        const SizedBox(height: 16),
        ...intentionList.map((item) => _buildPrayerIntentionCard(item)),
      ],
    );
  }

  Widget _buildKhususHeader(String selectedMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Salat Khusus & Jamak',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Pilih versi Jamak biasa atau Jamak + Qashar untuk panduan niat dan jumlah rakaat.',
          style: GoogleFonts.inter(fontSize: 13, color: Colors.black54, height: 1.4),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(_jamakModes.length, (index) {
            final mode = _jamakModes[index];
            return ChoiceChip(
              label: Text(mode),
              selected: _selectedJamakMode == index,
              onSelected: (_) {
                setState(() {
                  _selectedJamakMode = index;
                });
              },
              selectedColor: AppTheme.primaryColor.withOpacity(0.15),
              backgroundColor: Colors.grey.shade100,
              labelStyle: GoogleFonts.inter(
                color: _selectedJamakMode == index ? AppTheme.primaryColor : Colors.black87,
              ),
            );
          }),
        ),
        const SizedBox(height: 12),
        Text(
          'Mode Terpilih: $selectedMode',
          style: GoogleFonts.inter(fontSize: 13, color: AppTheme.primaryColor, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: AppTheme.primaryColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Perhatian: Salat Subuh tidak bisa dijamak. Untuk musafir, gunakan niat Qashar jika diperlukan dan pastikan mengikuti aturan fiqh yang benar.',
              style: GoogleFonts.inter(fontSize: 13, color: Colors.black87, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerIntentionCard(PrayerIntention intention) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.black.withOpacity(0.05)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    intention.name,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
                Text(
                  intention.rakat,
                  style: GoogleFonts.inter(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              intention.description,
              style: GoogleFonts.inter(fontSize: 13, color: Colors.black87, height: 1.5),
            ),
            if (intention.note.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                intention.note,
                style: GoogleFonts.inter(fontSize: 12, color: Colors.black54, fontStyle: FontStyle.italic),
              ),
            ],
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.05),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    intention.niatArab,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.amiri(fontSize: 22, height: 1.6, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    intention.niatLatin,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 13, color: AppTheme.primaryColor, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    intention.niatTranslation,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _copyPrayerIntention(intention),
                icon: const Icon(Icons.copy, size: 18),
                label: Text(
                  'Salin Niat',
                  style: GoogleFonts.inter(fontSize: 13, color: AppTheme.primaryColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _copyPrayerIntention(PrayerIntention intention) {
    Clipboard.setData(ClipboardData(
      text: '${intention.niatLatin}\n${intention.niatTranslation}',
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Niat ${intention.name} berhasil disalin.',
          style: GoogleFonts.inter(fontSize: 13),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 16,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: AppTheme.backgroundLight,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
