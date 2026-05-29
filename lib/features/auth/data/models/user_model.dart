import '../../domain/entities/user.dart';

/// La presentación seguirá viendo "User"; el modelo se queda dentro de la capa data.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    super.joinDate,
    super.idLevelUser,
  });

  /// Crea un UserModel desde un Map JSON que viene de la API.
  /// Es defensivo: tolera que `id` venga como String o int y que faltan campos.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: _asInt(json['id']),
      username: (json['username'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      joinDate: json['joinDate'] != null
          ? DateTime.tryParse(json['joinDate'].toString())
          : null,
      idLevelUser:
      json['idLevelUser'] != null ? _asInt(json['idLevelUser']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    if (joinDate != null) 'joinDate': joinDate!.toIso8601String(),
    if (idLevelUser != null) 'idLevelUser': idLevelUser,
  };

  static int _asInt(dynamic v) =>
      v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
}