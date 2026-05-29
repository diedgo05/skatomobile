import '../entities/trick.dart';
import '../repositories/trick_repository.dart';

class CreateTrickUseCase {
  final TrickRepository repository;
  CreateTrickUseCase(this.repository);

  Future<void> call(Trick trick) => repository.create(trick);
}