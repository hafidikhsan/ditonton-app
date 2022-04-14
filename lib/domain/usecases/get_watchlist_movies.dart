import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/database.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/common/failure.dart';

class GetWatchlist {
  final MovieRepository repository;

  GetWatchlist(this.repository);

  Future<Either<Failure, List<Database>>> execute() {
    return repository.getWatchlist();
  }
}
