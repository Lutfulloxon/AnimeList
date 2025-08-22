class UserModel {
  final String name;
  final String? profileImagePath;
  final DateTime createdAt;
  final DateTime lastLoginAt;

  const UserModel({
    required this.name,
    this.profileImagePath,
    required this.createdAt,
    required this.lastLoginAt,
  });

  /// JSON'dan model yaratish
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'] as String,
      profileImagePath: json['profile_image_path'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
      lastLoginAt: DateTime.fromMillisecondsSinceEpoch(json['last_login_at'] as int),
    );
  }

  /// Model'ni JSON'ga aylantirish
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'profile_image_path': profileImagePath,
      'created_at': createdAt.millisecondsSinceEpoch,
      'last_login_at': lastLoginAt.millisecondsSinceEpoch,
    };
  }

  /// Model'ni copy qilish
  UserModel copyWith({
    String? name,
    String? profileImagePath,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserModel(
      name: name ?? this.name,
      profileImagePath: profileImagePath ?? this.profileImagePath,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }

  @override
  String toString() {
    return 'UserModel(name: $name, profileImagePath: $profileImagePath, createdAt: $createdAt, lastLoginAt: $lastLoginAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.name == name &&
        other.profileImagePath == profileImagePath &&
        other.createdAt == createdAt &&
        other.lastLoginAt == lastLoginAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        profileImagePath.hashCode ^
        createdAt.hashCode ^
        lastLoginAt.hashCode;
  }
}
