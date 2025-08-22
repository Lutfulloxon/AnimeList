import 'package:hive/hive.dart';
import 'package:animehome/domain/entities/anime/anime_list_entity.dart';

part 'favorite_anime_model.g.dart';

@HiveType(typeId: 0)
class FavoriteAnimeModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String japaneseTitle;

  @HiveField(3)
  final int year;

  @HiveField(4)
  final int episodes;

  @HiveField(5)
  final List<String> genres;

  @HiveField(6)
  final double rating;

  @HiveField(7)
  final String imageUrl;

  @HiveField(8)
  final String description;

  @HiveField(9)
  final DateTime addedAt;

  FavoriteAnimeModel({
    required this.id,
    required this.title,
    required this.japaneseTitle,
    required this.year,
    required this.episodes,
    required this.genres,
    required this.rating,
    required this.imageUrl,
    required this.description,
    required this.addedAt,
  });

  // AnimeEntity'dan FavoriteAnimeModel yaratish
  factory FavoriteAnimeModel.fromEntity(AnimeEntity entity) {
    return FavoriteAnimeModel(
      id: entity.id,
      title: entity.title,
      japaneseTitle: entity.japaneseTitle,
      year: entity.year,
      episodes: entity.episodes,
      genres: entity.genres,
      rating: entity.rating,
      imageUrl: entity.imageUrl,
      description: entity.description,
      addedAt: DateTime.now(),
    );
  }

  // FavoriteAnimeModel'dan AnimeEntity yaratish
  AnimeEntity toEntity() {
    return AnimeEntity(
      id: id,
      title: title,
      japaneseTitle: japaneseTitle,
      year: year,
      episodes: episodes,
      genres: genres,
      rating: rating,
      imageUrl: imageUrl,
      description: description,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FavoriteAnimeModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
