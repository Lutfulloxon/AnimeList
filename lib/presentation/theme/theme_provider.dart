import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = true;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadTheme();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _saveTheme();
    notifyListeners();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? true;
    notifyListeners();
  }

  void _saveTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
  }

  // Dark theme colors (AniArk style)
  Color get darkPrimary => const Color(0xFF00D4AA);
  Color get darkBackground => const Color(0xFF0A0E1A);
  Color get darkSurface => const Color(0xFF1A1F2E);
  Color get darkCard => const Color(0xFF252B3A);
  Color get darkAccent => const Color(0xFF2A3441);

  // Light theme colors (AniArk style)
  Color get lightPrimary => const Color(0xFF00B894);
  Color get lightBackground => const Color(0xFFFAFBFC);
  Color get lightSurface => const Color(0xFFFFFFFF);
  Color get lightCard => const Color(0xFFF8F9FA);
  Color get lightAccent => const Color(0xFFF1F3F4);

  // Current theme colors
  Color get primaryColor => _isDarkMode ? darkPrimary : lightPrimary;
  Color get backgroundColor => _isDarkMode ? darkBackground : lightBackground;
  Color get surfaceColor => _isDarkMode ? darkSurface : lightSurface;
  Color get cardColor => _isDarkMode ? darkCard : lightCard;
  Color get accentColor => _isDarkMode ? darkAccent : lightAccent;

  // Text colors
  Color get primaryTextColor => _isDarkMode ? Colors.white : Colors.black87;
  Color get secondaryTextColor => _isDarkMode ? Colors.white70 : Colors.black54;
  Color get tertiaryTextColor => _isDarkMode ? Colors.white54 : Colors.black38;

  // Gradient colors
  List<Color> get backgroundGradient => _isDarkMode
      ? [darkBackground, darkSurface, darkCard, darkAccent]
      : [lightBackground, lightSurface, lightCard, lightAccent];

  // Shadow colors
  Color get shadowColor => _isDarkMode
      ? Colors.black.withValues(alpha: 0.3)
      : Colors.grey.withValues(alpha: 0.2);

  // Border colors
  Color get borderColor => _isDarkMode
      ? Colors.white.withValues(alpha: 0.1)
      : Colors.grey.withValues(alpha: 0.3);

  // Icon colors
  Color get iconColor => _isDarkMode ? Colors.white : Colors.black54;
  Color get primaryIconColor => primaryColor;
}
