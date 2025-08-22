import 'package:equatable/equatable.dart';

/// Request object for registering to an event
class AnimeSearchEntity extends Equatable {
  final String title;

  const AnimeSearchEntity({required this.title});

  @override
  List<Object?> get props => [title];

  AnimeSearchEntity copyWith({String? title}) {
    return AnimeSearchEntity(title: title ?? this.title);
  }
}
