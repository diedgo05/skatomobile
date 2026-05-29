import '../../domain/entities/trick.dart';
import '../../domain/repositories/trick_repository.dart';
import '../datasources/trick_remote_data_source.dart';
import '../models/trick_model.dart';

class TrickRepositoryImpl implements TrickRepository {
  final TrickRemoteDataSource remoteDataSource;
  TrickRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Trick>> getAll() => remoteDataSource.getAll();

  @override
  Future<List<Trick>> getByUser(int idUser) =>
      remoteDataSource.getByUser(idUser);

  @override
  Future<void> create(Trick trick) =>
      remoteDataSource.create(TrickModel.fromEntity(trick));

  @override
  Future<void> update(Trick trick) =>
      remoteDataSource.update(TrickModel.fromEntity(trick));

  @override
  Future<void> delete(int id) => remoteDataSource.delete(id);
}