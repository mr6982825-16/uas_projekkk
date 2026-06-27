import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';
import 'package:uas_projekk/modules/profile/about_screen.dart';
import 'package:uas_projekk/modules/profile/feedback_screen.dart';
import 'package:uas_projekk/modules/dzikir/doa_harian_screen.dart';
import 'package:uas_projekk/modules/profile/adhan_sound_selector.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  ImageProvider _getProfileImage(String path) {
    if (path.startsWith('http://') || path.startsWith('https://')) {
      return NetworkImage(path);
    }
    final file = File(path);
    if (file.existsSync()) {
      return FileImage(file);
    }
    return const NetworkImage("https://i.pravatar.cc/150?u=pilarislam");
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text("Konfirmasi Logout", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text("Apakah Anda yakin ingin keluar dari akun Pilar Islam?", style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Batal", style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear(); // Clear all saved session data
              
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Anda telah keluar dari aplikasi.")),
                );
                // Usually navigate to login screen here
                // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginScreen()), (route) => false);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[700],
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text("Keluar", style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final settings = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  _buildStatsSection(theme, settings),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Koleksi Saya", theme),
                  _buildSavedContentSection(context, theme, settings),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Pengaturan Ibadah", theme),
                  _buildPrayerSettingsSection(context, theme),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Pengaturan Tampilan", theme),
                  _buildUISettingsSection(context, theme),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Dukungan", theme),
                  _buildSupportSection(context, theme),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final settings = Provider.of<SettingsProvider>(context);
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 80, bottom: 40),
      decoration: const BoxDecoration(
        color: Color(0xFF0F4D3A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: _getProfileImage(settings.profilePicUrl),
                backgroundColor: Colors.white,
              ),
              InkWell(
                onTap: () => _showEditPicDialog(context, settings),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD4AF37),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  settings.userName,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.white70, size: 18),
                onPressed: () => _showEditNameDialog(context, settings),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "Pembelajar Harian • Level 12",
            style: GoogleFonts.inter(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeaderBadge(Icons.local_fire_department, "14 Day Streak"),
              const SizedBox(width: 15),
              _buildHeaderBadge(Icons.auto_awesome, "Ahli Dzikir"),
            ],
          ),
        ],
      ),
    );
  }

  void _showEditNameDialog(BuildContext context, SettingsProvider settings) {
    final controller = TextEditingController(text: settings.userName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ubah Nama", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: controller,
          maxLength: 12,
          decoration: const InputDecoration(hintText: "Masukkan nama baru"),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              final trimmedName = controller.text.trim();
              if (trimmedName.isNotEmpty) {
                settings.updateUserName(
                  trimmedName.substring(0, trimmedName.length > 12 ? 12 : trimmedName.length),
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F4D3A)),
            child: const Text("Simpan", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditPicDialog(BuildContext context, SettingsProvider settings) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
              child: Text(
                "Ubah Foto Profil",
                style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Color(0xFF0F4D3A)),
              title: Text("Pilih dari Galeri", style: GoogleFonts.inter()),
              onTap: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  settings.updateProfilePic(image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Color(0xFF0F4D3A)),
              title: Text("Ambil Foto dari Kamera", style: GoogleFonts.inter()),
              onTap: () async {
                Navigator.pop(context);
                final picker = ImagePicker();
                final image = await picker.pickImage(source: ImageSource.camera);
                if (image != null) {
                  settings.updateProfilePic(image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.restore, color: Colors.grey),
              title: Text("Gunakan Foto Default", style: GoogleFonts.inter()),
              onTap: () {
                Navigator.pop(context);
                settings.updateProfilePic("https://i.pravatar.cc/150?u=pilarislam");
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFD4AF37), size: 16),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection(ThemeData theme, SettingsProvider settings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem("Doa Terbaca", settings.totalDoaRead.toString(), theme),
              Container(height: 30, width: 1, color: Colors.grey[200]),
              _buildStatItem("Poin Ibadah", settings.userPoints.toString(), theme),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Target Harian",
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
              Text(
                "${(settings.dailyTarget * 100).toInt()}%",
                style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0F4D3A), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: settings.dailyTarget,
              minHeight: 10,
              backgroundColor: theme.brightness == Brightness.dark ? Colors.white10 : const Color(0xFFF1F1F1),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0F4D3A)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, ThemeData theme) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: theme.primaryColor),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: theme.colorScheme.onBackground),
        ),
      ),
    );
  }

  Widget _buildSavedContentSection(BuildContext context, ThemeData theme, SettingsProvider settings) {
    return Column(
      children: [
        _buildSettingsTile(
          Icons.bookmark_outline, 
          "Doa Favorit", 
          theme, 
          subtitle: "${settings.favoriteDoaTitles.length} Doa tersimpan",
          onTap: () {
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => DoaHarianScreen(showFavoritesOnly: true))
            );
          },
        ),
        _buildSettingsTile(
          Icons.history, 
          "Terakhir Dibaca", 
          theme, 
          subtitle: "${settings.lastReadTitle} • ${settings.lastReadSubtitle}",
          onTap: () {
            // Simple logic: if it's a doa, open the collection.
            Navigator.push(context, MaterialPageRoute(builder: (_) => DoaHarianScreen()));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Melanjutkan: ${settings.lastReadTitle}")),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPrayerSettingsSection(BuildContext context, ThemeData theme) {
    final settings = Provider.of<SettingsProvider>(context);
    return Column(
      children: [
        _buildSettingsTile(Icons.my_location, "Lokasi Pengguna", theme, subtitle: "Jakarta, Indonesia", trailing: const Icon(Icons.sync, size: 20, color: Color(0xFF0F4D3A))),
        _buildSwitchTile(Icons.notifications_active_outlined, "Notifikasi Adzan", settings.isAdhanNotifEnabled, (val) => settings.toggleAdhanNotif(val), theme),
        if (settings.isAdhanNotifEnabled)
          _buildSettingsTile(
            Icons.music_note_outlined,
            "Pilih Suara Adzan",
            theme,
            subtitle: _getAdhanSoundName(settings.selectedAdhanSoundId),
            onTap: () => _showAdhanSoundSelector(context),
          ),
        _buildSwitchTile(Icons.alarm, "Pengingat Dzikir", settings.isDzikirNotifEnabled, (val) => settings.toggleDzikirNotif(val), theme),
      ],
    );
  }

  Widget _buildUISettingsSection(BuildContext context, ThemeData theme) {
    final settings = Provider.of<SettingsProvider>(context);
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.text_fields, color: Color(0xFF8B7355), size: 22),
                  const SizedBox(width: 15),
                  Text("Ukuran Font Arab", style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
                  const Spacer(),
                  Text("${settings.arabicFontSize.toInt()} pt", style: GoogleFonts.inter(color: Colors.grey)),
                ],
              ),
              Slider(
                value: settings.arabicFontSize,
                min: 20,
                max: 40,
                activeColor: const Color(0xFF0F4D3A),
                inactiveColor: const Color(0xFFF1F1F1),
                onChanged: (val) => settings.setArabicFontSize(val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _buildSwitchTile(Icons.dark_mode_outlined, "Mode Gelap", settings.isDarkMode, (val) => settings.toggleDarkMode(val), theme),
        _buildSwitchTile(Icons.translate, "Tampilkan Terjemahan", settings.showTranslation, (val) => settings.toggleTranslation(val), theme),
      ],
    );
  }

  Widget _buildSupportSection(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        _buildSettingsTile(
          Icons.info_outline, 
          "Tentang Pilar Islam", 
          theme,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen())),
        ),
        _buildSettingsTile(
          Icons.star_outline, 
          "Beri Rating", 
          theme,
          onTap: () => _launchUrl("https://play.google.com/store/apps/details?id=com.pilarislam.app"),
        ),
        _buildSettingsTile(
          Icons.mail_outline, 
          "Hubungi Kami", 
          theme,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackScreen())),
        ),
        _buildSettingsTile(
          Icons.logout, 
          "Logout", 
          theme, 
          color: Colors.red[700],
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, ThemeData theme, {String? subtitle, Widget? trailing, Color? color, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: color ?? const Color(0xFF8B7355), size: 22),
          title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: color ?? theme.colorScheme.onSurface)),
          subtitle: subtitle != null ? Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)) : null,
          trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(IconData icon, String title, bool value, Function(bool) onChanged, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: SwitchListTile(
          secondary: Icon(icon, color: const Color(0xFF8B7355), size: 22),
          title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
          value: value,
          activeColor: const Color(0xFF0F4D3A),
          onChanged: onChanged,
        ),
      ),
    );
  }

  String _getAdhanSoundName(String soundId) {
    switch (soundId) {
      case 'makkah':
        return 'Adzan Makkah (Populer)';
      case 'madinah':
        return 'Adzan Madinah (Syahdu)';
      case 'alaqsa':
        return 'Adzan Al-Aqsa';
      case 'egypt':
        return 'Adzan Mesir (Melodi Indah)';
      case 'turkey':
        return 'Adzan Turki';
      case 'yusuf_islam':
        return 'Adzan Yusuf Islam';
      default:
        return 'Adzan Makkah (Populer)';
    }
  }

  void _showAdhanSoundSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const AdhanSoundSelectorSheet(),
    );
  }
}
