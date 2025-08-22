import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animehome/data/models/real_anime_model.dart';
import 'package:animehome/domain/entities/anime/anime_list_entity.dart';

class AnimeApiService {
  static const String _baseUrl = 'https://api.jikan.moe/v4';
  static const Duration _timeout = Duration(seconds: 10);

  /// Top anime'larni olish
  static Future<List<AnimeEntity>> getTopAnime({
    int page = 1,
    int limit = 100,
  }) async {
    try {
      // Jikan API v4 to'g'ri URL format
      final url = '$_baseUrl/top/anime?page=$page&limit=$limit';
      print('🌐 API Request: $url');

      final response = await http
          .get(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'User-Agent': 'AnimeHome/1.0',
            },
          )
          .timeout(_timeout);

      print('📡 API Response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        print('📊 API Data keys: ${jsonData.keys}');

        // Jikan API v4 format
        if (jsonData['data'] != null) {
          final List<dynamic> animeList = jsonData['data'];
          print('✅ Found ${animeList.length} anime from API');

          return animeList.map((animeJson) {
            return AnimeEntity(
              id: animeJson['mal_id'] ?? 0,
              title: animeJson['title'] ?? 'Unknown',
              japaneseTitle:
                  animeJson['title_japanese'] ??
                  animeJson['title'] ??
                  'Unknown',
              year:
                  animeJson['year'] ??
                  animeJson['aired']?['prop']?['from']?['year'] ??
                  2023,
              episodes: animeJson['episodes'] ?? 0,
              genres:
                  (animeJson['genres'] as List<dynamic>?)
                      ?.map((g) => g['name'].toString())
                      .toList() ??
                  [],
              rating: (animeJson['score'] as num?)?.toDouble() ?? 0.0,
              imageUrl: animeJson['images']?['jpg']?['image_url'] ?? '',
              description: animeJson['synopsis'] ?? 'Tavsif mavjud emas',
            );
          }).toList();
        } else {
          throw Exception('Invalid API response format');
        }
      } else {
        print('❌ API Error: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to load anime: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error: $e');
    }
  }

  /// Anime qidirish
  static Future<List<AnimeEntity>> searchAnime({
    required String query,
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final encodedQuery = Uri.encodeComponent(query);
      final url = '$_baseUrl/anime?q=$encodedQuery&page=$page&limit=$limit';

      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final animeResponse = AnimeResponseModel.fromJson(jsonData);

        return animeResponse.data.map((model) => model.toEntity()).toList();
      } else {
        throw Exception('Failed to search anime: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Search error: $e');
    }
  }

  /// Anime detailini olish
  static Future<RealAnimeModel> getAnimeDetail(int animeId) async {
    try {
      final url = '$_baseUrl/anime/$animeId';
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return RealAnimeModel.fromJson(jsonData['data']);
      } else {
        throw Exception('Failed to load anime detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Detail error: $e');
    }
  }

  /// Anime rasmlarini olish
  static Future<List<String>> getAnimeImages(int animeId) async {
    try {
      final url = '$_baseUrl/anime/$animeId/pictures';
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> pictures = jsonData['data'] ?? [];

        return pictures
            .map((pic) => pic['jpg']['large_image_url'] as String? ?? '')
            .where((url) => url.isNotEmpty)
            .toList();
      } else {
        throw Exception('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Images error: $e');
    }
  }

  /// Anime videolarini olish
  static Future<List<VideoModel>> getAnimeVideos(int animeId) async {
    try {
      final url = '$_baseUrl/anime/$animeId/videos';
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<VideoModel> videos = [];

        // Promo videos
        final List<dynamic> promos = jsonData['data']['promo'] ?? [];
        for (var promo in promos) {
          videos.add(VideoModel.fromJson(promo));
        }

        // Music videos
        final List<dynamic> musicVideos =
            jsonData['data']['music_videos'] ?? [];
        for (var mv in musicVideos) {
          videos.add(VideoModel.fromJson(mv));
        }

        return videos;
      } else {
        throw Exception('Failed to load videos: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Videos error: $e');
    }
  }

  /// Kategoriya bo'yicha anime'lar
  static Future<List<AnimeEntity>> getAnimeByGenre({
    required int genreId,
    int page = 1,
    int limit = 100,
  }) async {
    try {
      final url = '$_baseUrl/anime?genres=$genreId&page=$page&limit=$limit';
      final response = await http
          .get(Uri.parse(url), headers: {'Content-Type': 'application/json'})
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final animeResponse = AnimeResponseModel.fromJson(jsonData);

        return animeResponse.data.map((model) => model.toEntity()).toList();
      } else {
        throw Exception('Failed to load genre anime: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Genre error: $e');
    }
  }
}

class VideoModel {
  final String title;
  final String? youtubeId;
  final String? url;
  final String? embedUrl;
  final String? thumbnail;

  VideoModel({
    required this.title,
    this.youtubeId,
    this.url,
    this.embedUrl,
    this.thumbnail,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      title: json['title'] ?? 'Video',
      youtubeId: json['trailer']?['youtube_id'],
      url: json['trailer']?['url'],
      embedUrl: json['trailer']?['embed_url'],
      thumbnail: json['trailer']?['images']?['maximum_image_url'],
    );
  }
}
