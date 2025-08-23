import 'package:flutter/material.dart';
import 'package:animehome/domain/entities/anime/anime_list_entity.dart';
import 'package:animehome/data/services/anime_api_service.dart';
import 'package:animehome/data/services/smart_cache_service.dart';

class HybridAnimeProvider extends ChangeNotifier {
  List<AnimeEntity> _animeList = [];
  List<AnimeEntity> _searchResults = [];
  List<AnimeEntity> _currentSeasonAnime = [];
  List<AnimeEntity> _upcomingAnime = [];
  AnimeEntity? _randomAnime;
  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  bool _isOnline = false;
  int _currentPage = 1;
  bool _hasMoreData = true;

  // Getters
  List<AnimeEntity> get animeList => _animeList;
  List<AnimeEntity> get searchResults => _searchResults;
  List<AnimeEntity> get currentSeasonAnime => _currentSeasonAnime;
  List<AnimeEntity> get upcomingAnime => _upcomingAnime;
  AnimeEntity? get randomAnime => _randomAnime;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  bool get isOnline => _isOnline;
  bool get hasMoreData => _hasMoreData;

  /// Provider'ni initialize qilish
  Future<void> init() async {
    await _checkInternetAndLoadData();
    // Kategoriyalarni ham yuklash
    await loadAllCategories();
  }

  /// Internet tekshirish va ma'lumot yuklash
  Future<void> _checkInternetAndLoadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      print('🚀 Starting data load process...');

      // Internet tekshirish
      _isOnline = await SmartCacheService.hasInternetConnection();
      print('🌐 Internet status: ${_isOnline ? "Connected" : "Offline"}');

      if (_isOnline) {
        // Online: API'dan yuklash
        print('📡 Loading from API...');
        await _loadFromAPI();
      } else {
        // Offline: Cache'dan yuklash
        print('💾 Loading from cache...');
        await _loadFromCache();
      }

      print('✅ Data load completed. Total anime: ${_animeList.length}');
    } catch (e) {
      print('❌ Error in data loading: $e');
      _error = e.toString();

      // Xatolik bo'lsa cache'dan yuklashga harakat qilish
      try {
        print('🔄 Trying to load from cache as fallback...');
        await _loadFromCache();
      } catch (cacheError) {
        print('❌ Cache fallback also failed: $cacheError');
        _error = 'Internet yo\'q va cache ham mavjud emas: $e';
      }
    } finally {
      _isLoading = false;
      notifyListeners();
      print('🏁 Data loading process finished');
    }
  }

  /// API'dan ma'lumot yuklash
  Future<void> _loadFromAPI() async {
    try {
      print('🌐 Loading from API...');

      // Birinchi sahifadan boshlaymiz
      final firstPage = await AnimeApiService.getTopAnime(page: 1, limit: 25);
      _animeList = firstPage;

      // Agar birinchi sahifa muvaffaqiyatli bo'lsa, ko'proq yuklash
      if (firstPage.isNotEmpty) {
        // 2-sahifani ham yuklash
        try {
          await Future.delayed(
            Duration(milliseconds: 1000),
          ); // Rate limit uchun
          final secondPage = await AnimeApiService.getTopAnime(
            page: 2,
            limit: 25,
          );
          _animeList.addAll(secondPage);

          // 3-sahifani ham yuklash
          await Future.delayed(Duration(milliseconds: 1000));
          final thirdPage = await AnimeApiService.getTopAnime(
            page: 3,
            limit: 25,
          );
          _animeList.addAll(thirdPage);

          _currentPage = 4;
        } catch (e) {
          print('⚠️ Additional pages failed: $e');
          _currentPage = 2;
        }
      }

      _hasMoreData = _animeList.length >= 25;

      // Cache'ga saqlash
      await SmartCacheService.cacheAnimeList(_animeList);

      print('✅ Loaded ${_animeList.length} anime from API');
    } catch (e) {
      print('❌ API load error: $e');
      throw e;
    }
  }

  /// Cache'dan ma'lumot yuklash
  Future<void> _loadFromCache() async {
    try {
      print('💾 Loading from cache...');
      final cachedAnimes = SmartCacheService.getCachedAnimeList();

      if (cachedAnimes != null && cachedAnimes.isNotEmpty) {
        _animeList = cachedAnimes;
        print('✅ Loaded ${cachedAnimes.length} anime from cache');
      } else {
        // Cache bo'sh bo'lsa API'dan yuklashga harakat qilish
        print('📦 Cache empty, trying API again...');
        await _loadFromAPI();
      }
    } catch (e) {
      print('❌ Cache load error: $e');
      // Eng oxirgi variant - bo'sh ro'yxat
      _animeList = [];
      _error = 'Internet ulanishi yo\'q va cache\'da ma\'lumot mavjud emas';
    }
  }

  /// Refresh qilish
  Future<void> refresh() async {
    _error = null;
    _currentPage = 1;
    _hasMoreData = true;
    await _checkInternetAndLoadData();
  }

  /// Ko'proq yuklash
  Future<void> loadMore() async {
    if (!_hasMoreData || _isLoading || !_isOnline) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newAnimes = await AnimeApiService.getTopAnime(
        page: _currentPage,
        limit: 25,
      );

      _animeList.addAll(newAnimes);
      _currentPage++;
      _hasMoreData = newAnimes.length >= 25;

      // Cache'ni yangilash
      await SmartCacheService.cacheAnimeList(_animeList);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Qidiruv
  Future<void> searchAnime(String query) async {
    if (query.trim().isEmpty) {
      _searchResults.clear();
      notifyListeners();
      return;
    }

    _isSearching = true;
    _error = null;
    notifyListeners();

    try {
      if (_isOnline) {
        // Online qidiruv
        _searchResults = await AnimeApiService.searchAnime(
          query: query.trim(),
          limit: 100,
        );
      } else {
        // Offline qidiruv (local ma'lumotlardan)
        _searchResults = _animeList.where((anime) {
          return anime.title.toLowerCase().contains(query.toLowerCase()) ||
              anime.japaneseTitle.toLowerCase().contains(query.toLowerCase()) ||
              anime.genres.any(
                (genre) => genre.toLowerCase().contains(query.toLowerCase()),
              );
        }).toList();
      }
    } catch (e) {
      _error = e.toString();
      _searchResults.clear();
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  /// Kategoriya bo'yicha anime'lar
  Future<List<AnimeEntity>> getAnimeByCategory(String categoryName) async {
    try {
      if (_isOnline) {
        // Online: API'dan
        final genreMap = {
          'Action': 1,
          'Adventure': 2,
          'Comedy': 4,
          'Drama': 8,
          'Fantasy': 10,
          'Horror': 14,
          'Romance': 22,
          'Sci-Fi': 24,
          'Thriller': 41,
          'Supernatural': 37,
          'Mystery': 7,
          'Sports': 30,
          'Slice of Life': 36,
          'Historical': 13,
          'Psychological': 40,
          'Shounen': 27,
        };

        final genreId = genreMap[categoryName];
        if (genreId != null) {
          return await AnimeApiService.getAnimeByGenre(
            genreId: genreId,
            limit: 50,
          );
        }
      } else {
        // Offline: Local'dan filter qilish
        return _animeList.where((anime) {
          return anime.genres.any(
            (genre) => genre.toLowerCase() == categoryName.toLowerCase(),
          );
        }).toList();
      }

      return [];
    } catch (e) {
      print('Category anime error: $e');
      return [];
    }
  }

  /// Qidiruvni tozalash
  void clearSearch() {
    _searchResults.clear();
    notifyListeners();
  }

  /// Error'ni tozalash
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Internet holatini yangilash
  Future<void> updateInternetStatus() async {
    final wasOnline = _isOnline;
    _isOnline = await SmartCacheService.hasInternetConnection();

    if (!wasOnline && _isOnline) {
      // Internet qaytib keldi - yangi ma'lumotlarni yuklash
      print('🌐 Internet restored, refreshing data...');
      await refresh();
    }

    notifyListeners();
  }

  /// Cache statistikasi
  Future<Map<String, dynamic>> getCacheStats() async {
    return await SmartCacheService.getCacheStats();
  }

  /// Cache'ni tozalash
  Future<void> clearCache() async {
    await SmartCacheService.clearCache();
    await refresh();
  }

  /// Joriy mavsum anime'larini yuklash
  Future<void> loadCurrentSeasonAnime() async {
    try {
      print('🌸 Loading current season anime...');
      _currentSeasonAnime = await AnimeApiService.getCurrentSeasonAnime(
        limit: 20,
      );
      print('🌸 Loaded ${_currentSeasonAnime.length} current season anime');
      notifyListeners();
    } catch (e) {
      print('❌ Current season error: $e');
    }
  }

  /// Kelayotgan anime'larni yuklash
  Future<void> loadUpcomingAnime() async {
    try {
      print('🔮 Loading upcoming anime...');
      _upcomingAnime = await AnimeApiService.getUpcomingAnime(limit: 20);
      print('🔮 Loaded ${_upcomingAnime.length} upcoming anime');
      notifyListeners();
    } catch (e) {
      print('❌ Upcoming error: $e');
    }
  }

  /// Random anime yuklash
  Future<void> loadRandomAnime() async {
    try {
      print('🎲 Loading random anime...');
      _randomAnime = await AnimeApiService.getRandomAnime();
      if (_randomAnime != null) {
        print('🎲 Loaded random anime: ${_randomAnime!.title}');
      }
      notifyListeners();
    } catch (e) {
      print('❌ Random anime error: $e');
    }
  }

  /// Barcha kategoriyalarni yuklash
  Future<void> loadAllCategories() async {
    if (_isOnline) {
      await Future.wait([
        loadCurrentSeasonAnime(),
        loadUpcomingAnime(),
        loadRandomAnime(),
      ]);
    }
  }
}
