  class AnimeEntity {
    final int id;
    final String title;
    final String japaneseTitle;
    final int year;
    final int episodes;
    final List<String> genres;
    final double rating;
    final String imageUrl;
    final String description;
  
    const AnimeEntity({
      required this.id,
      required this.title,
      required this.japaneseTitle,
      required this.year,
      required this.episodes,
      required this.genres,
      required this.rating,
      required this.imageUrl,
      required this.description,
    });

    /// Entity → Map (optional, agar local save qilmoqchi bo‘lsangiz foydali)
    Map<String, dynamic> toMap() {
      return {
        'id': id,
        'title': title,
        'japanese_title': japaneseTitle,
        'year': year,
        'episodes': episodes,
        'genres': genres,
        'rating': rating,
        'image_url': imageUrl,
        'description': description,
      };
    }

    /// Map → Entity (optional, agar localdan o‘qisangiz)
    factory AnimeEntity.fromMap(Map<String, dynamic> map) {
      return AnimeEntity(
        id: map['id'] ?? 0,
        title: map['title'] ?? '',
        japaneseTitle: map['japanese_title'] ?? '',
        year: map['year'] ?? 0,
        episodes: map['episodes'] ?? 0,
        genres: List<String>.from(map['genres'] ?? []),
        rating: (map['rating'] ?? 0).toDouble(),
        imageUrl: map['image_url'] ?? '',
        description: map['description'] ?? '',
      );
    }
  }
