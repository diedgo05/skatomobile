class User {
  final int id;
  final String username;
  final String email;
  final DateTime? joinDate;
  final int? idLevelUser;

  const User({
    required this.id,
    required this.username,
    required this.email,
    this.joinDate,
    this.idLevelUser,
  });

  /// el email es válido si contiene "@".
  bool get hasValidEmail => email.contains('@');
}