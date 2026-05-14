import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uas_projekk/core/theme.dart';
import 'package:uas_projekk/modules/profile/settings_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
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
                  _buildStatsSection(theme),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Koleksi Saya", theme),
                  _buildSavedContentSection(theme),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Pengaturan Ibadah", theme),
                  _buildPrayerSettingsSection(context, theme),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Pengaturan Tampilan", theme),
                  _buildUISettingsSection(context, theme),
                  const SizedBox(height: 25),
                  _buildSectionHeader("Dukungan", theme),
                  _buildSupportSection(theme),
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
                backgroundImage: NetworkImage(settings.profilePicUrl),
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
              Text(
                settings.userName,
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
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
          decoration: const InputDecoration(hintText: "Masukkan nama baru"),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                settings.updateUserName(controller.text);
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
    final controller = TextEditingController(text: settings.profilePicUrl);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Ubah Foto Profil", style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Masukkan URL foto profil baru Anda:"),
            const SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "https://example.com/image.jpg"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                settings.updateProfilePic(controller.text);
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

  Widget _buildStatsSection(ThemeData theme) {
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
              _buildStatItem("Doa Terbaca", "1,240", theme),
              Container(height: 30, width: 1, color: Colors.grey[200]),
              _buildStatItem("Poin Ibadah", "850", theme),
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
                style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                "75%",
                style: GoogleFonts.inter(fontSize: 14, color: const Color(0xFF0F4D3A), fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: const LinearProgressIndicator(
              value: 0.75,
              minHeight: 10,
              backgroundColor: Color(0xFFF1F1F1),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F4D3A)),
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

  Widget _buildSavedContentSection(ThemeData theme) {
    return Column(
      children: [
        _buildSettingsTile(Icons.bookmark_outline, "Doa Favorit", theme, subtitle: "24 Doa tersimpan"),
        _buildSettingsTile(Icons.history, "Terakhir Dibaca", theme, subtitle: "Surah Al-Kahf • Ayat 24"),
      ],
    );
  }

  Widget _buildPrayerSettingsSection(BuildContext context, ThemeData theme) {
    final settings = Provider.of<SettingsProvider>(context);
    return Column(
      children: [
        _buildSettingsTile(Icons.my_location, "Lokasi Pengguna", theme, subtitle: "Jakarta, Indonesia", trailing: const Icon(Icons.sync, size: 20, color: Color(0xFF0F4D3A))),
        _buildSwitchTile(Icons.notifications_active_outlined, "Notifikasi Adzan", settings.isAdhanNotifEnabled, (val) => settings.toggleAdhanNotif(val), theme),
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

  Widget _buildSupportSection(ThemeData theme) {
    return Column(
      children: [
        _buildSettingsTile(Icons.info_outline, "Tentang Pilar Islam", theme),
        _buildSettingsTile(Icons.star_outline, "Beri Rating", theme),
        _buildSettingsTile(Icons.mail_outline, "Hubungi Kami", theme),
        _buildSettingsTile(Icons.logout, "Logout", theme, color: Colors.red[700]),
      ],
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, ThemeData theme, {String? subtitle, Widget? trailing, Color? color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? const Color(0xFF8B7355), size: 22),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: color ?? theme.colorScheme.onSurface)),
        subtitle: subtitle != null ? Text(subtitle, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)) : null,
        trailing: trailing ?? const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
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
      child: SwitchListTile(
        secondary: Icon(icon, color: const Color(0xFF8B7355), size: 22),
        title: Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
        value: value,
        activeColor: const Color(0xFF0F4D3A),
        onChanged: onChanged,
      ),
    );
  }
}
