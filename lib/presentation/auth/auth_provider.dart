import 'dart:io';
import 'package:flutter/material.dart';
import 'package:animehome/data/models/user_model.dart';
import 'package:animehome/data/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Provider'ni initialize qilish
  Future<void> init() async {
    try {
      _isLoading = true;
      notifyListeners();

      _isLoggedIn = AuthService.isLoggedIn;
      _currentUser = AuthService.currentUser;

      // Agar foydalanuvchi tizimga kirgan bo'lsa, last login'ni yangilash
      if (_isLoggedIn && _currentUser != null) {
        await AuthService.updateLastLogin();
        _currentUser = AuthService.currentUser; // Yangilangan ma'lumotni olish
      }

      print('🔐 Auth initialized: ${_isLoggedIn ? "Logged in as ${_currentUser?.name}" : "Not logged in"}');
    } catch (e) {
      _error = e.toString();
      print('❌ Auth init error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tizimga kirish
  Future<bool> login({
    required String name,
    File? profileImage,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Ism tekshirish
      if (name.trim().isEmpty) {
        throw Exception('Ism kiritish majburiy');
      }

      String? profileImagePath;

      // Profile rasmini saqlash (agar mavjud bo'lsa)
      if (profileImage != null) {
        profileImagePath = await AuthService.saveProfileImage(profileImage);
        if (profileImagePath == null) {
          throw Exception('Profile rasmini saqlashda xatolik');
        }
      }

      // Foydalanuvchini tizimga kiritish
      final success = await AuthService.login(
        name: name,
        profileImagePath: profileImagePath,
      );

      if (success) {
        _isLoggedIn = true;
        _currentUser = AuthService.currentUser;
        print('✅ Login successful: ${_currentUser?.name}');
        notifyListeners();
        return true;
      } else {
        throw Exception('Tizimga kirishda xatolik');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Login error: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Foydalanuvchi ma'lumotlarini yangilash
  Future<bool> updateProfile({
    String? name,
    File? newProfileImage,
    bool removeCurrentImage = false,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      String? profileImagePath = _currentUser?.profileImagePath;

      // Agar yangi rasm yuklangan bo'lsa
      if (newProfileImage != null) {
        // Eski rasmni o'chirish
        if (profileImagePath != null) {
          await AuthService.deleteOldProfileImage(profileImagePath);
        }
        
        // Yangi rasmni saqlash
        profileImagePath = await AuthService.saveProfileImage(newProfileImage);
        if (profileImagePath == null) {
          throw Exception('Yangi rasmni saqlashda xatolik');
        }
      } else if (removeCurrentImage) {
        // Joriy rasmni o'chirish
        if (profileImagePath != null) {
          await AuthService.deleteOldProfileImage(profileImagePath);
          profileImagePath = null;
        }
      }

      // Foydalanuvchi ma'lumotlarini yangilash
      final success = await AuthService.updateUser(
        name: name,
        profileImagePath: profileImagePath,
      );

      if (success) {
        _currentUser = AuthService.currentUser;
        print('✅ Profile updated successfully');
        notifyListeners();
        return true;
      } else {
        throw Exception('Profilni yangilashda xatolik');
      }
    } catch (e) {
      _error = e.toString();
      print('❌ Update profile error: $e');
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tizimdan chiqish
  Future<void> logout() async {
    try {
      _isLoading = true;
      notifyListeners();

      await AuthService.logout();
      
      _isLoggedIn = false;
      _currentUser = null;
      _error = null;
      
      print('✅ Logout successful');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print('❌ Logout error: $e');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Xatolikni tozalash
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Barcha ma'lumotlarni tozalash (debug uchun)
  Future<void> clearAllData() async {
    try {
      _isLoading = true;
      notifyListeners();

      await AuthService.clearUserData();
      
      _isLoggedIn = false;
      _currentUser = null;
      _error = null;
      
      print('✅ All data cleared');
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      print('❌ Clear all data error: $e');
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
