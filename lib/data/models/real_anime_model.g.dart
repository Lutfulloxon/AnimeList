// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'real_anime_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RealAnimeModel _$RealAnimeModelFromJson(Map<String, dynamic> json) =>
    RealAnimeModel(
      malId: (json['mal_id'] as num).toInt(),
      title: json['title'] as String,
      titleJapanese: json['title_japanese'] as String?,
      year: (json['year'] as num?)?.toInt(),
      episodes: (json['episodes'] as num?)?.toInt(),
      genres: (json['genres'] as List<dynamic>?)
          ?.map((e) => GenreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      score: (json['score'] as num?)?.toDouble(),
      images: json['images'] == null
          ? null
          : ImagesModel.fromJson(json['images'] as Map<String, dynamic>),
      synopsis: json['synopsis'] as String?,
      trailer: json['trailer'] == null
          ? null
          : TrailerModel.fromJson(json['trailer'] as Map<String, dynamic>),
      status: json['status'] as String?,
      aired: json['aired'] == null
          ? null
          : AiredModel.fromJson(json['aired'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RealAnimeModelToJson(RealAnimeModel instance) =>
    <String, dynamic>{
      'mal_id': instance.malId,
      'title': instance.title,
      'title_japanese': instance.titleJapanese,
      'year': instance.year,
      'episodes': instance.episodes,
      'genres': instance.genres,
      'score': instance.score,
      'images': instance.images,
      'synopsis': instance.synopsis,
      'trailer': instance.trailer,
      'status': instance.status,
      'aired': instance.aired,
    };

GenreModel _$GenreModelFromJson(Map<String, dynamic> json) => GenreModel(
      malId: (json['mal_id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$GenreModelToJson(GenreModel instance) =>
    <String, dynamic>{
      'mal_id': instance.malId,
      'name': instance.name,
    };

ImagesModel _$ImagesModelFromJson(Map<String, dynamic> json) => ImagesModel(
      jpg: json['jpg'] == null
          ? null
          : ImageSizeModel.fromJson(json['jpg'] as Map<String, dynamic>),
      webp: json['webp'] == null
          ? null
          : ImageSizeModel.fromJson(json['webp'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ImagesModelToJson(ImagesModel instance) =>
    <String, dynamic>{
      'jpg': instance.jpg,
      'webp': instance.webp,
    };

ImageSizeModel _$ImageSizeModelFromJson(Map<String, dynamic> json) =>
    ImageSizeModel(
      imageUrl: json['image_url'] as String?,
      smallImageUrl: json['small_image_url'] as String?,
      largeImageUrl: json['large_image_url'] as String?,
    );

Map<String, dynamic> _$ImageSizeModelToJson(ImageSizeModel instance) =>
    <String, dynamic>{
      'image_url': instance.imageUrl,
      'small_image_url': instance.smallImageUrl,
      'large_image_url': instance.largeImageUrl,
    };

TrailerModel _$TrailerModelFromJson(Map<String, dynamic> json) => TrailerModel(
      youtubeId: json['youtube_id'] as String?,
      url: json['url'] as String?,
      embedUrl: json['embed_url'] as String?,
    );

Map<String, dynamic> _$TrailerModelToJson(TrailerModel instance) =>
    <String, dynamic>{
      'youtube_id': instance.youtubeId,
      'url': instance.url,
      'embed_url': instance.embedUrl,
    };

AiredModel _$AiredModelFromJson(Map<String, dynamic> json) => AiredModel(
      from: json['from'] as String?,
      to: json['to'] as String?,
    );

Map<String, dynamic> _$AiredModelToJson(AiredModel instance) =>
    <String, dynamic>{
      'from': instance.from,
      'to': instance.to,
    };

AnimeResponseModel _$AnimeResponseModelFromJson(Map<String, dynamic> json) =>
    AnimeResponseModel(
      data: (json['data'] as List<dynamic>)
          .map((e) => RealAnimeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: json['pagination'] == null
          ? null
          : PaginationModel.fromJson(
              json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AnimeResponseModelToJson(AnimeResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'pagination': instance.pagination,
    };

PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      lastVisiblePage: (json['last_visible_page'] as num?)?.toInt(),
      hasNextPage: json['has_next_page'] as bool?,
    );

Map<String, dynamic> _$PaginationModelToJson(PaginationModel instance) =>
    <String, dynamic>{
      'last_visible_page': instance.lastVisiblePage,
      'has_next_page': instance.hasNextPage,
    };
