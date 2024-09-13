class UserModel {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final String createdAt;
  final String updatedAt;
  final bool isLoggedIn;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.createdAt,
    required this.updatedAt,
    required this.isLoggedIn,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      isLoggedIn: json['is_logged_in'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar': avatar,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'is_logged_in': isLoggedIn,
    };
  }

  UserModel copyWith({
    String? name,
    String? avatar,
    String? updatedAt,
    bool? isLoggedIn,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
    );
  }
}
