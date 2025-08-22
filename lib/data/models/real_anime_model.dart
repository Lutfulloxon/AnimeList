import 'package:json_annotation/json_annotation.dart';
import 'package:animehome/domain/entities/anime/anime_list_entity.dart';

part 'real_anime_model.g.dart';

@JsonSerializable()
class RealAnimeModel {
  @JsonKey(name: 'mal_id')
  final int malId;
  
  final String title;
  
  @JsonKey(name: 'title_japanese')
  final String? titleJapanese;
  
  final int? year;
  
  final int? episodes;
  
  final List<GenreModel>? genres;
  
  final double? score;
  
  final ImagesModel? images;
  
  final String? synopsis;
  
  @JsonKey(name: 'trailer')
  final TrailerModel? trailer;
  
  final String? status;
  
  @JsonKey(name: 'aired')
  final AiredModel? aired;

  RealAnimeModel({
    required this.malId,
    required this.title,
    this.titleJapanese,
    this.year,
    this.episodes,
    this.genres,
    this.score,
    this.images,
    this.synopsis,
    this.trailer,
    this.status,
    this.aired,
  });

  factory RealAnimeModel.fromJson(Map<String, dynamic> json) =>
      _$RealAnimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$RealAnimeModelToJson(this);

  // Entity'ga convert qilish
  AnimeEntity toEntity() {
    return AnimeEntity(
      id: malId,
      title: title,
      japaneseTitle: titleJapanese ?? title,
      year: year ?? 0,
      episodes: episodes ?? 0,
      genres: genres?.map((g) => g.name).toList() ?? [],
      rating: score ?? 0.0,
      imageUrl: images?.jpg?.imageUrl ?? '',
      description: synopsis ?? 'Tavsif mavjud emas',
    );
  }
}

@JsonSerializable()
class GenreModel {
  @JsonKey(name: 'mal_id')
  final int malId;
  
  final String name;

  GenreModel({required this.malId, required this.name});

  factory GenreModel.fromJson(Map<String, dynamic> json) =>
      _$GenreModelFromJson(json);

  Map<String, dynamic> toJson() => _$GenreModelToJson(this);
}

@JsonSerializable()
class ImagesModel {
  final ImageSizeModel? jpg;
  final ImageSizeModel? webp;

  ImagesModel({this.jpg, this.webp});

  factory ImagesModel.fromJson(Map<String, dynamic> json) =>
      _$ImagesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesModelToJson(this);
}

@JsonSerializable()
class ImageSizeModel {
  @JsonKey(name: 'image_url')
  final String? imageUrl;
  
  @JsonKey(name: 'small_image_url')
  final String? smallImageUrl;
  
  @JsonKey(name: 'large_image_url')
  final String? largeImageUrl;

  ImageSizeModel({this.imageUrl, this.smallImageUrl, this.largeImageUrl});

  factory ImageSizeModel.fromJson(Map<String, dynamic> json) =>
      _$ImageSizeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ImageSizeModelToJson(this);
}

@JsonSerializable()
class TrailerModel {
  @JsonKey(name: 'youtube_id')
  final String? youtubeId;
  
  final String? url;
  
  @JsonKey(name: 'embed_url')
  final String? embedUrl;

  TrailerModel({this.youtubeId, this.url, this.embedUrl});

  factory TrailerModel.fromJson(Map<String, dynamic> json) =>
      _$TrailerModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrailerModelToJson(this);
}

@JsonSerializable()
class AiredModel {
  final String? from;
  final String? to;

  AiredModel({this.from, this.to});

  factory AiredModel.fromJson(Map<String, dynamic> json) =>
      _$AiredModelFromJson(json);

  Map<String, dynamic> toJson() => _$AiredModelToJson(this);
}

@JsonSerializable()
class AnimeResponseModel {
  final List<RealAnimeModel> data;
  
  @JsonKey(name: 'pagination')
  final PaginationModel? pagination;

  AnimeResponseModel({required this.data, this.pagination});

  factory AnimeResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AnimeResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$AnimeResponseModelToJson(this);
}

@JsonSerializable()
class PaginationModel {
  @JsonKey(name: 'last_visible_page')
  final int? lastVisiblePage;
  
  @JsonKey(name: 'has_next_page')
  final bool? hasNextPage;

  PaginationModel({this.lastVisiblePage, this.hasNextPage});

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationModelToJson(this);
}
