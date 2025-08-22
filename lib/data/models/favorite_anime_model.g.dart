// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_anime_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteAnimeModelAdapter extends TypeAdapter<FavoriteAnimeModel> {
  @override
  final int typeId = 0;

  @override
  FavoriteAnimeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteAnimeModel(
      id: fields[0] as int,
      title: fields[1] as String,
      japaneseTitle: fields[2] as String,
      year: fields[3] as int,
      episodes: fields[4] as int,
      genres: (fields[5] as List).cast<String>(),
      rating: fields[6] as double,
      imageUrl: fields[7] as String,
      description: fields[8] as String,
      addedAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteAnimeModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.japaneseTitle)
      ..writeByte(3)
      ..write(obj.year)
      ..writeByte(4)
      ..write(obj.episodes)
      ..writeByte(5)
      ..write(obj.genres)
      ..writeByte(6)
      ..write(obj.rating)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteAnimeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
