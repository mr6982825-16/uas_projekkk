import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  double _arabicFontSize = 28.0;
  bool _showTranslation = true;
  bool _isAdhanNotifEnabled = true;
  bool _isDzikirNotifEnabled = true;
  
  // New User Info fields
  String _userName = "lora M.rusdi";
  String _profilePicUrl = "https://i.pravatar.cc/150?u=pilarislam";

  bool get isDarkMode => _isDarkMode;
  double get arabicFontSize => _arabicFontSize;
  bool get showTranslation => _showTranslation;
  bool get isAdhanNotifEnabled => _isAdhanNotifEnabled;
  bool get isDzikirNotifEnabled => _isDzikirNotifEnabled;
  String get userName => _userName;
  String get profilePicUrl => _profilePicUrl;

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void setArabicFontSize(double size) {
    _arabicFontSize = size;
    notifyListeners();
  }

  void toggleTranslation(bool value) {
    _showTranslation = value;
    notifyListeners();
  }

  void toggleAdhanNotif(bool value) {
    _isAdhanNotifEnabled = value;
    notifyListeners();
  }

  void toggleDzikirNotif(bool value) {
    _isDzikirNotifEnabled = value;
    notifyListeners();
  }

  void updateUserName(String newName) {
    _userName = newName;
    notifyListeners();
  }

  void updateProfilePic(String newUrl) {
    _profilePicUrl = newUrl;
    notifyListeners();
  }
}
