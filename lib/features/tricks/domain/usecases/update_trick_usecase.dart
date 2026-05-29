import '../entities/trick.dart';
import '../repositories/trick_repository.dart';

class UpdateTrickUseCase {
  final TrickRepository repository;
  UpdateTrickUseCase(this.repository);

  Future<void> call(Trick trick) => repository.update(trick);
}