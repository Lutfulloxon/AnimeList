import 'dart:io';
import 'package:animehome/data/models/user_model.dart';
import 'package:animehome/data/services/hive_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class AuthService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  /// Foydalanuvchi tizimga kirganmi?
  static bool get isLoggedIn {
    return HiveService.getSetting<bool>(_isLoggedInKey, defaultValue: false) ??
        false;
  }

  /// Joriy foydalanuvchini olish
  static UserModel? get currentUser {
    try {
      final userData = HiveService.getSetting<Map>(_userKey);
      if (userData == null) return null;

      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    } catch (e) {
      print('❌ Error getting current user: $e');
      return null;
    }
  }

  /// Foydalanuvchini tizimga kiritish
  static Future<bool> login({
    required String name,
    String? profileImagePath,
  }) async {
    try {
      if (name.trim().isEmpty) {
        throw Exception('Ism bo\'sh bo\'lishi mumkin emas');
      }

      final now = DateTime.now();
      final user = UserModel(
        name: name.trim(),
        profileImagePath: profileImagePath,
        createdAt: now,
        lastLoginAt: now,
      );

      // Foydalanuvchi ma'lumotlarini saqlash
      await HiveService.saveSetting(_userKey, user.toJson());
      await HiveService.saveSetting(_isLoggedInKey, true);

      print('✅ User logged in successfully: ${user.name}');
      return true;
    } catch (e) {
      print('❌ Login error: $e');
      return false;
    }
  }

  /// Foydalanuvchi ma'lumotlarini yangilash
  static Future<bool> updateUser({
    String? name,
    String? profileImagePath,
  }) async {
    try {
      final currentUserData = currentUser;
      if (currentUserData == null) {
        throw Exception('Foydalanuvchi topilmadi');
      }

      final updatedUser = currentUserData.copyWith(
        name: name,
        profileImagePath: profileImagePath,
        lastLoginAt: DateTime.now(),
      );

      await HiveService.saveSetting(_userKey, updatedUser.toJson());
      print('✅ User updated successfully: ${updatedUser.name}');
      return true;
    } catch (e) {
      print('❌ Update user error: $e');
      return false;
    }
  }

  /// Tizimdan chiqish
  static Future<void> logout() async {
    try {
      await HiveService.deleteSetting(_userKey);
      await HiveService.deleteSetting(_isLoggedInKey);
      print('✅ User logged out successfully');
    } catch (e) {
      print('❌ Logout error: $e');
    }
  }

  /// Profile rasmini saqlash
  static Future<String?> saveProfileImage(File imageFile) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final profileDir = Directory(path.join(appDir.path, 'profile_images'));

      // Papka mavjud emasligini tekshirish va yaratish
      if (!await profileDir.exists()) {
        await profileDir.create(recursive: true);
      }

      // Fayl nomini yaratish (timestamp bilan)
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImagePath = path.join(profileDir.path, fileName);

      // Rasmni ko'chirish
      await imageFile.copy(savedImagePath);

      print('✅ Profile image saved: $savedImagePath');
      return savedImagePath;
    } catch (e) {
      print('❌ Save profile image error: $e');
      return null;
    }
  }

  /// Eski profile rasmini o'chirish
  static Future<void> deleteOldProfileImage(String? imagePath) async {
    try {
      if (imagePath == null || imagePath.isEmpty) return;

      final file = File(imagePath);
      if (await file.exists()) {
        await file.delete();
        print('✅ Old profile image deleted: $imagePath');
      }
    } catch (e) {
      print('❌ Delete old profile image error: $e');
    }
  }

  /// Foydalanuvchi ma'lumotlarini tozalash (debug uchun)
  static Future<void> clearUserData() async {
    try {
      final user = currentUser;
      if (user?.profileImagePath != null) {
        await deleteOldProfileImage(user!.profileImagePath);
      }

      await logout();
      print('✅ All user data cleared');
    } catch (e) {
      print('❌ Clear user data error: $e');
    }
  }

  /// Last login vaqtini yangilash
  static Future<void> updateLastLogin() async {
    try {
      final user = currentUser;
      if (user != null) {
        final updatedUser = user.copyWith(lastLoginAt: DateTime.now());
        await HiveService.saveSetting(_userKey, updatedUser.toJson());
      }
    } catch (e) {
      print('❌ Update last login error: $e');
    }
  }
}
