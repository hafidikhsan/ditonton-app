import 'package:dartz/dartz.dart';
// import 'package:ditonton/common/failure.dart';
import 'package:common/common.dart';
// import 'package:ditonton/domain/entities/movie_detail.dart';
// import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:movie/movie.dart';

class RemoveWatchlist {
  final MovieRepository repository;

  RemoveWatchlist(this.repository);

  Future<Either<Failure, String>> execute(MovieDetail movie) {
    return repository.removeWatchlist(movie);
  }
}
