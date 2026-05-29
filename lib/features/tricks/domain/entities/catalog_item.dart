/// Entidad genérica para los catálogos {id, name}: categorías, dificultades,
/// niveles de truco. Como los tres tienen exactamente la misma forma, una sola
/// entity sirve. Esto evita duplicar Category, Difficulty y LevelTrick.
class CatalogItem {
  final int id;
  final String name;

  const CatalogItem({required this.id, required this.name});

  @override
  String toString() => name;
}