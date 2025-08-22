import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:animehome/data/services/hive_service.dart';
import 'package:animehome/domain/entities/anime/anime_list_entity.dart';

class SmartCacheService {
  static const String _animeListKey = 'cached_anime_list';
  static const String _animeImagesPrefix = 'anime_images_';
  static const Duration _cacheExpiry = Duration(hours: 24);

  /// Anime list'ni cache'ga saqlash (Telegram style)
  static Future<void> cacheAnimeList(List<AnimeEntity> animes) async {
    try {
      final cacheData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'data': animes
            .map(
              (anime) => {
                'id': anime.id,
                'title': anime.title,
                'japaneseTitle': anime.japaneseTitle,
                'year': anime.year,
                'episodes': anime.episodes,
                'genres': anime.genres,
                'rating': anime.rating,
                'imageUrl': anime.imageUrl,
                'description': anime.description,
              },
            )
            .toList(),
      };

      await HiveService.saveSetting(_animeListKey, cacheData);
      print('✅ Cached ${animes.length} anime to Hive');
    } catch (e) {
      print('❌ Cache anime list error: $e');
    }
  }

  /// Cache'dan anime list olish
  static List<AnimeEntity>? getCachedAnimeList() {
    try {
      final cacheData = HiveService.getSetting<Map>(_animeListKey);
      if (cacheData == null) return null;

      final timestamp = cacheData['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Cache expired?
      if (now - timestamp > _cacheExpiry.inMilliseconds) {
        print('⏰ Cache expired, need fresh data');
        return null;
      }

      final List<dynamic> data = cacheData['data'] as List<dynamic>;
      final animes = data
          .map(
            (json) => AnimeEntity(
              id: json['id'],
              title: json['title'],
              japaneseTitle: json['japaneseTitle'],
              year: json['year'],
              episodes: json['episodes'],
              genres: List<String>.from(json['genres']),
              rating: json['rating'],
              imageUrl: json['imageUrl'],
              description: json['description'],
            ),
          )
          .toList();

      print('✅ Loaded ${animes.length} anime from cache');
      return animes;
    } catch (e) {
      print('❌ Get cached anime list error: $e');
      return null;
    }
  }

  /// Rasmni download qilib saqlash (Telegram style)
  static Future<String?> downloadAndSaveImage(
    String imageUrl,
    int animeId,
    int index,
  ) async {
    try {
      print('📥 Downloading image: $imageUrl');

      final response = await http
          .get(Uri.parse(imageUrl))
          .timeout(Duration(seconds: 30));
      if (response.statusCode != 200) {
        print('❌ Failed to download image: ${response.statusCode}');
        return null;
      }

      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/anime_images');
      if (!imagesDir.existsSync()) {
        imagesDir.createSync(recursive: true);
      }

      final fileName = 'anime_${animeId}_$index.jpg';
      final file = File('${imagesDir.path}/$fileName');
      await file.writeAsBytes(response.bodyBytes);

      print('✅ Image saved: ${file.path}');
      return file.path;
    } catch (e) {
      print('❌ Download image error: $e');
      return null;
    }
  }

  /// Anime rasmlarini cache qilish
  static Future<void> cacheAnimeImages(
    int animeId,
    List<String> imageUrls,
  ) async {
    try {
      print('📸 Caching ${imageUrls.length} images for anime $animeId');

      final localPaths = <String>[];
      for (int i = 0; i < imageUrls.length && i < 10; i++) {
        // Max 10 rasm
        final localPath = await downloadAndSaveImage(imageUrls[i], animeId, i);
        if (localPath != null) {
          localPaths.add(localPath);
        }
      }

      final cacheData = {
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'urls': imageUrls,
        'local_paths': localPaths,
      };

      await HiveService.saveSetting('$_animeImagesPrefix$animeId', cacheData);
      print('✅ Cached ${localPaths.length} images for anime $animeId');
    } catch (e) {
      print('❌ Cache anime images error: $e');
    }
  }

  /// Cache'dan anime rasmlarini olish
  static List<String>? getCachedAnimeImages(int animeId) {
    try {
      final cacheData = HiveService.getSetting<Map>(
        '$_animeImagesPrefix$animeId',
      );
      if (cacheData == null) return null;

      final timestamp = cacheData['timestamp'] as int;
      final now = DateTime.now().millisecondsSinceEpoch;

      // Cache expired? (7 kun)
      if (now - timestamp > Duration(days: 7).inMilliseconds) {
        print('⏰ Image cache expired for anime $animeId');
        return null;
      }

      final List<dynamic> localPaths =
          cacheData['local_paths'] as List<dynamic>;
      final List<String> validPaths = [];

      // Fayllar mavjudligini tekshirish
      for (String path in localPaths) {
        if (File(path).existsSync()) {
          validPaths.add(path);
        }
      }

      if (validPaths.isNotEmpty) {
        print('✅ Found ${validPaths.length} cached images for anime $animeId');
        return validPaths;
      }

      return null;
    } catch (e) {
      print('❌ Get cached anime images error: $e');
      return null;
    }
  }

  /// Cache'ni tozalash
  static Future<void> clearCache() async {
    try {
      print('🧹 Clearing cache...');

      // Hive cache'ni tozalash
      await HiveService.saveSetting(_animeListKey, null);

      // Rasm fayllarini o'chirish
      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/anime_images');
      if (imagesDir.existsSync()) {
        imagesDir.deleteSync(recursive: true);
      }

      print('✅ Cache cleared successfully');
    } catch (e) {
      print('❌ Clear cache error: $e');
    }
  }

  /// Cache hajmini hisoblash
  static Future<double> getCacheSizeMB() async {
    try {
      double totalSize = 0;

      final directory = await getApplicationDocumentsDirectory();
      final imagesDir = Directory('${directory.path}/anime_images');
      if (imagesDir.existsSync()) {
        final files = imagesDir.listSync(recursive: true);
        for (FileSystemEntity file in files) {
          if (file is File) {
            totalSize += file.lengthSync();
          }
        }
      }

      final sizeMB = totalSize / (1024 * 1024);
      print('📊 Cache size: ${sizeMB.toStringAsFixed(2)} MB');
      return sizeMB;
    } catch (e) {
      print('❌ Get cache size error: $e');
      return 0;
    }
  }

  /// Internet mavjudligini tekshirish
  static Future<bool> hasInternetConnection() async {
    try {
      print('🔍 Checking internet connection...');

      // Bir nechta URL'ni sinab ko'ramiz
      final urls = [
        'https://api.jikan.moe/v4',
        'https://google.com',
        'https://httpbin.org/status/200',
      ];

      for (String url in urls) {
        try {
          print('🌐 Testing: $url');
          final result = await http
              .get(Uri.parse(url))
              .timeout(Duration(seconds: 8));
          if (result.statusCode == 200) {
            print('✅ Internet available via $url');
            return true;
          }
        } catch (e) {
          print('❌ Failed to connect to $url: $e');
          continue;
        }
      }

      print('📴 No internet connection available');
      return false;
    } catch (e) {
      print('📴 No internet connection: $e');
      return false;
    }
  }

  /// Cache statistikasi
  static Future<Map<String, dynamic>> getCacheStats() async {
    try {
      final sizeMB = await getCacheSizeMB();
      final hasInternet = await hasInternetConnection();
      final cachedAnimes = getCachedAnimeList();

      return {
        'cache_size_mb': sizeMB,
        'has_internet': hasInternet,
        'cached_animes_count': cachedAnimes?.length ?? 0,
        'last_update': DateTime.now().toIso8601String(),
      };
    } catch (e) {
      return {'error': e.toString()};
    }
  }
}
