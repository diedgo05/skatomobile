import '../entities/trick.dart';

abstract class TrickRepository {
  Future<List<Trick>> getAll();
  Future<List<Trick>> getByUser(int idUser);
  Future<void> create(Trick trick);
  Future<void> update(Trick trick);
  Future<void> delete(int id);
}