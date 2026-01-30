class UserModel {
  final String id;
  String name;
  String email;
  String? avatarUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
  });
}
