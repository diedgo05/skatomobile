import '../entities/trick.dart';
import '../repositories/trick_repository.dart';

class GetTricksUseCase {
  final TrickRepository repository;
  GetTricksUseCase(this.repository);

  Future<List<Trick>> call({required int idUser}) =>
      repository.getByUser(idUser);
}