import '../repositories/trick_repository.dart';

class DeleteTrickUseCase {
  final TrickRepository repository;
  DeleteTrickUseCase(this.repository);

  Future<void> call(int id) => repository.delete(id);
}