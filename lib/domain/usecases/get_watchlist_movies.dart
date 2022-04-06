import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/database.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetWatchlist {
  final MovieRepository _repository;

  GetWatchlist(this._repository);

  Future<Either<Failure, List<Database>>> execute() {
    return _repository.getWatchlist();
  }
}
