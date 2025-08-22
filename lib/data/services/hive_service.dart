import 'package:hive_flutter/hive_flutter.dart';
import 'package:animehome/data/models/favorite_anime_model.dart';
import 'package:animehome/domain/entities/anime/anime_list_entity.dart';

class HiveService {
  static const String _favoritesBoxName = 'favorites';
  static const String _settingsBoxName = 'settings';

  static Box<FavoriteAnimeModel>? _favoritesBox;
  static Box? _settingsBox;

  /// Hive'ni initialize qilish
  static Future<void> init() async {
    await Hive.initFlutter();

    // Adapter'larni register qilish
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(FavoriteAnimeModelAdapter());
    }

    // Box'larni ochish
    _favoritesBox = await Hive.openBox<FavoriteAnimeModel>(_favoritesBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  /// Sevimli anime qo'shish
  static Future<void> addFavorite(AnimeEntity anime) async {
    if (_favoritesBox == null) await init();

    final favoriteModel = FavoriteAnimeModel.fromEntity(anime);
    await _favoritesBox!.put(anime.id, favoriteModel);
  }

  /// Sevimli anime olib tashlash
  static Future<void> removeFavorite(int animeId) async {
    if (_favoritesBox == null) await init();

    await _favoritesBox!.delete(animeId);
  }

  /// Anime sevimli ekanligini tekshirish
  static bool isFavorite(int animeId) {
    if (_favoritesBox == null) return false;

    return _favoritesBox!.containsKey(animeId);
  }

  /// Barcha sevimli anime'larni olish
  static List<AnimeEntity> getAllFavorites() {
    if (_favoritesBox == null) return [];

    return _favoritesBox!.values.map((model) => model.toEntity()).toList()
      ..sort((a, b) => b.id.compareTo(a.id)); // Eng yangi birinchi
  }

  /// Sevimlilar sonini olish
  static int getFavoritesCount() {
    if (_favoritesBox == null) return 0;

    return _favoritesBox!.length;
  }

  /// Barcha sevimlilarni tozalash
  static Future<void> clearAllFavorites() async {
    if (_favoritesBox == null) await init();

    await _favoritesBox!.clear();
  }

  /// Setting saqlash
  static Future<void> saveSetting(String key, dynamic value) async {
    if (_settingsBox == null) await init();

    await _settingsBox!.put(key, value);
  }

  /// Setting olish
  static T? getSetting<T>(String key, {T? defaultValue}) {
    if (_settingsBox == null) return defaultValue;

    return _settingsBox!.get(key, defaultValue: defaultValue) as T?;
  }

  /// Setting o'chirish
  static Future<void> deleteSetting(String key) async {
    if (_settingsBox == null) await init();

    await _settingsBox!.delete(key);
  }

  /// Hive'ni yopish (app terminate bo'lganda)
  static Future<void> close() async {
    await _favoritesBox?.close();
    await _settingsBox?.close();
    await Hive.close();
  }

  /// Box'larni listen qilish uchun
  static Box<FavoriteAnimeModel>? get favoritesBox => _favoritesBox;
  static Box? get settingsBox => _settingsBox;
}
