import 'package:flutter/material.dart';
import 'package:uas_projekk/modules/quran/quran_screen.dart';
import 'package:uas_projekk/modules/dashboard/home_body.dart';
import 'package:uas_projekk/modules/tools/features_dashboard_screen.dart';
import 'package:uas_projekk/modules/prayer/prayer_screen.dart';
import 'package:uas_projekk/modules/profile/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 1;

  final List<Widget> _pages = [
    const QuranScreen(),
    const HomeBody(),
    const FeaturesDashboardScreen(),
    const PrayerTimesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          _buildFloatingBottomNav(),
        ],
      ),
    );
  }

  Widget _buildFloatingBottomNav() {
    return Positioned(
      bottom: 20,
      left: 20,
      right: 20,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.book_outlined, 0),
            _buildNavItem(Icons.home_outlined, 1, isSpecial: true),
            _buildNavItem(Icons.auto_awesome_outlined, 2),
            _buildNavItem(Icons.access_time, 3),
            _buildNavItem(Icons.person_outline, 4),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index, {bool isSpecial = false}) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: isSelected
            ? BoxDecoration(
                color: const Color(0xFFF0F5F3),
                borderRadius: BorderRadius.circular(15),
              )
            : null,
        child: Icon(
          icon,
          color: isSelected ? const Color(0xFF0F4D3A) : Colors.grey[400],
          size: 28,
        ),
      ),
    );
  }
}
