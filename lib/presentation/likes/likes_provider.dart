import 'package:flutter/material.dart';
import 'package:animehome/domain/entities/anime/anime_list_entity.dart';
import 'package:animehome/data/services/hive_service.dart';

class LikesProvider extends ChangeNotifier {
  List<AnimeEntity> _favoriteAnimes = [];
  bool _isInitialized = false;

  List<AnimeEntity> get favoriteAnimes => List.unmodifiable(_favoriteAnimes);

  /// Provider'ni initialize qilish
  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await HiveService.init();
      _favoriteAnimes = HiveService.getAllFavorites();
      _isInitialized = true;
      notifyListeners();
    } catch (e) {
      debugPrint('LikesProvider init error: $e');
    }
  }

  bool isFavorite(int animeId) {
    return HiveService.isFavorite(animeId);
  }

  Future<void> toggleFavorite(AnimeEntity anime) async {
    try {
      if (isFavorite(anime.id)) {
        await HiveService.removeFavorite(anime.id);
        _favoriteAnimes.removeWhere((item) => item.id == anime.id);
      } else {
        await HiveService.addFavorite(anime);
        _favoriteAnimes.add(anime);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Toggle favorite error: $e');
    }
  }

  Future<void> addToFavorites(AnimeEntity anime) async {
    if (!isFavorite(anime.id)) {
      try {
        await HiveService.addFavorite(anime);
        _favoriteAnimes.add(anime);
        notifyListeners();
      } catch (e) {
        debugPrint('Add to favorites error: $e');
      }
    }
  }

  Future<void> removeFromFavorites(int animeId) async {
    try {
      await HiveService.removeFavorite(animeId);
      _favoriteAnimes.removeWhere((anime) => anime.id == animeId);
      notifyListeners();
    } catch (e) {
      debugPrint('Remove from favorites error: $e');
    }
  }

  Future<void> clearAllFavorites() async {
    try {
      await HiveService.clearAllFavorites();
      _favoriteAnimes.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Clear all favorites error: $e');
    }
  }

  int get favoritesCount => _favoriteAnimes.length;

  /// Provider'ni dispose qilish
  @override
  void dispose() {
    HiveService.close();
    super.dispose();
  }
}
