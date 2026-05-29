import '../../domain/entities/trick.dart';

class TrickModel extends Trick {
  const TrickModel({
    required super.id,
    required super.title,
    required super.description,
    required super.idCategory,
    required super.idDifficulty,
    required super.idLevelTrick,
    required super.idUser,
  });

  factory TrickModel.fromJson(Map<String, dynamic> json) {
    return TrickModel(
      id: _asInt(json['id']),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      idCategory: _asInt(json['idCategory']),
      idDifficulty: _asInt(json['idDifficulty']),
      idLevelTrick: _asInt(json['idLevelTrick']),
      idUser: _asInt(json['idUser']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'idCategory': idCategory,
    'idDifficulty': idDifficulty,
    'idLevelTrick': idLevelTrick,
    'idUser': idUser,
  };

  factory TrickModel.fromEntity(Trick t) => TrickModel(
    id: t.id,
    title: t.title,
    description: t.description,
    idCategory: t.idCategory,
    idDifficulty: t.idDifficulty,
    idLevelTrick: t.idLevelTrick,
    idUser: t.idUser,
  );

  static int _asInt(dynamic v) =>
      v is int ? v : int.tryParse(v?.toString() ?? '') ?? 0;
}