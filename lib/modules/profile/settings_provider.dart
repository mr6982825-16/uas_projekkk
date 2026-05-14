import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  bool _isDarkMode = false;
  double _arabicFontSize = 28.0;
  bool _showTranslation = true;
  bool _isAdhanNotifEnabled = true;
  bool _isDzikirNotifEnabled = true;
  
  String _userName = "lora M.rusdi";
  String _profilePicUrl = "https://i.pravatar.cc/150?u=pilarislam";

  // Stats
  int _totalDoaRead = 1240;
  int _userPoints = 850;
  double _dailyTarget = 0.75;
  String _lastReadTitle = "Surah Al-Kahf";
  String _lastReadSubtitle = "Ayat 24 of 110";
  List<String> _favoriteDoaTitles = [];

  SettingsProvider() {
    _loadFromPrefs();
  }

  bool get isDarkMode => _isDarkMode;
  double get arabicFontSize => _arabicFontSize;
  bool get showTranslation => _showTranslation;
  bool get isAdhanNotifEnabled => _isAdhanNotifEnabled;
  bool get isDzikirNotifEnabled => _isDzikirNotifEnabled;
  String get userName => _userName;
  String get profilePicUrl => _profilePicUrl;
  
  int get totalDoaRead => _totalDoaRead;
  int get userPoints => _userPoints;
  double get dailyTarget => _dailyTarget;
  String get lastReadTitle => _lastReadTitle;
  String get lastReadSubtitle => _lastReadSubtitle;
  List<String> get favoriteDoaTitles => _favoriteDoaTitles;

  // Persistance
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _arabicFontSize = prefs.getDouble('arabicFontSize') ?? 28.0;
    _showTranslation = prefs.getBool('showTranslation') ?? true;
    _userName = prefs.getString('userName') ?? "lora M.rusdi";
    _profilePicUrl = prefs.getString('profilePicUrl') ?? "https://i.pravatar.cc/150?u=pilarislam";
    _totalDoaRead = prefs.getInt('totalDoaRead') ?? 1240;
    _userPoints = prefs.getInt('userPoints') ?? 850;
    _dailyTarget = prefs.getDouble('dailyTarget') ?? 0.75;
    _lastReadTitle = prefs.getString('lastReadTitle') ?? "Surah Al-Kahf";
    _lastReadSubtitle = prefs.getString('lastReadSubtitle') ?? "Ayat 24 of 110";
    _favoriteDoaTitles = prefs.getStringList('favoriteDoaTitles') ?? [];
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', _isDarkMode);
    await prefs.setDouble('arabicFontSize', _arabicFontSize);
    await prefs.setBool('showTranslation', _showTranslation);
    await prefs.setString('userName', _userName);
    await prefs.setString('profilePicUrl', _profilePicUrl);
    await prefs.setInt('totalDoaRead', _totalDoaRead);
    await prefs.setInt('userPoints', _userPoints);
    await prefs.setDouble('dailyTarget', _dailyTarget);
    await prefs.setString('lastReadTitle', _lastReadTitle);
    await prefs.setString('lastReadSubtitle', _lastReadSubtitle);
    await prefs.setStringList('favoriteDoaTitles', _favoriteDoaTitles);
  }

  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    _saveToPrefs();
    notifyListeners();
  }

  void setArabicFontSize(double size) {
    _arabicFontSize = size;
    _saveToPrefs();
    notifyListeners();
  }

  void toggleTranslation(bool value) {
    _showTranslation = value;
    _saveToPrefs();
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
    _saveToPrefs();
    notifyListeners();
  }

  void updateProfilePic(String newUrl) {
    _profilePicUrl = newUrl;
    _saveToPrefs();
    notifyListeners();
  }

  void incrementDoaRead() {
    _totalDoaRead++;
    _userPoints += 10;
    if (_dailyTarget < 1.0) _dailyTarget += 0.05;
    _saveToPrefs();
    notifyListeners();
  }

  void setLastRead(String title, String subtitle) {
    _lastReadTitle = title;
    _lastReadSubtitle = subtitle;
    _saveToPrefs();
    notifyListeners();
  }

  void toggleFavorite(String title) {
    if (_favoriteDoaTitles.contains(title)) {
      _favoriteDoaTitles.remove(title);
    } else {
      _favoriteDoaTitles.add(title);
    }
    _saveToPrefs();
    notifyListeners();
  }
}
