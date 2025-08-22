import 'package:flutter/material.dart';
import 'package:animehome/data/services/hive_service.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  static const String _languageKey = 'language';
  static const String _notificationsKey = 'notifications_enabled';
  static const String _autoPlayKey = 'auto_play_enabled';
  static const String _downloadQualityKey = 'download_quality';

  bool _isDarkMode = true;
  String _language = 'uz';
  bool _notificationsEnabled = true;
  bool _autoPlayEnabled = false;
  String _downloadQuality = 'HD';
  bool _isInitialized = false;

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get autoPlayEnabled => _autoPlayEnabled;
  String get downloadQuality => _downloadQuality;

  /// Settings'ni initialize qilish
  Future<void> init() async {
    if (_isInitialized) return;
    
    try {
      _isDarkMode = HiveService.getSetting<bool>(_themeKey, defaultValue: true) ?? true;
      _language = HiveService.getSetting<String>(_languageKey, defaultValue: 'uz') ?? 'uz';
      _notificationsEnabled = HiveService.getSetting<bool>(_notificationsKey, defaultValue: true) ?? true;
      _autoPlayEnabled = HiveService.getSetting<bool>(_autoPlayKey, defaultValue: false) ?? false;
      _downloadQuality = HiveService.getSetting<String>(_downloadQualityKey, defaultValue: 'HD') ?? 'HD';
      
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('SettingsProvider init error: $e');
    }
  }

  /// Theme mode o'zgartirish
  Future<void> setThemeMode(bool isDark) async {
    try {
      _isDarkMode = isDark;
      await HiveService.saveSetting(_themeKey, isDark);
      notifyListeners();
    } catch (e) {
      debugPrint('Set theme mode error: $e');
    }
  }

  /// Til o'zgartirish
  Future<void> setLanguage(String languageCode) async {
    try {
      _language = languageCode;
      await HiveService.saveSetting(_languageKey, languageCode);
      notifyListeners();
    } catch (e) {
      debugPrint('Set language error: $e');
    }
  }

  /// Bildirishnomalar sozlamasi
  Future<void> setNotificationsEnabled(bool enabled) async {
    try {
      _notificationsEnabled = enabled;
      await HiveService.saveSetting(_notificationsKey, enabled);
      notifyListeners();
    } catch (e) {
      debugPrint('Set notifications error: $e');
    }
  }

  /// Auto play sozlamasi
  Future<void> setAutoPlayEnabled(bool enabled) async {
    try {
      _autoPlayEnabled = enabled;
      await HiveService.saveSetting(_autoPlayKey, enabled);
      notifyListeners();
    } catch (e) {
      debugPrint('Set auto play error: $e');
    }
  }

  /// Download quality sozlamasi
  Future<void> setDownloadQuality(String quality) async {
    try {
      _downloadQuality = quality;
      await HiveService.saveSetting(_downloadQualityKey, quality);
      notifyListeners();
    } catch (e) {
      debugPrint('Set download quality error: $e');
    }
  }

  /// Barcha settings'ni reset qilish
  Future<void> resetSettings() async {
    try {
      _isDarkMode = true;
      _language = 'uz';
      _notificationsEnabled = true;
      _autoPlayEnabled = false;
      _downloadQuality = 'HD';
      
      await HiveService.saveSetting(_themeKey, _isDarkMode);
      await HiveService.saveSetting(_languageKey, _language);
      await HiveService.saveSetting(_notificationsKey, _notificationsEnabled);
      await HiveService.saveSetting(_autoPlayKey, _autoPlayEnabled);
      await HiveService.saveSetting(_downloadQualityKey, _downloadQuality);
      
      notifyListeners();
    } catch (e) {
      debugPrint('Reset settings error: $e');
    }
  }
}
