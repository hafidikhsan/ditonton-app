import 'package:dartz/dartz.dart';
// import 'package:ditonton/common/failure.dart';
import 'package:common/common.dart';
// import 'package:ditonton/domain/entities/movie.dart';
// import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/repositories/movie_repository.dart';

class SearchMovies {
  final MovieRepository repository;

  SearchMovies(this.repository);

  Future<Either<Failure, List<Movie>>> execute(String query) {
    return repository.searchMovies(query);
  }
}
