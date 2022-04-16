import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:watchlist/domain/entities/database.dart';
import 'package:movie/movie.dart';

class GetWatchlist {
  final MovieRepository repository;

  GetWatchlist(this.repository);

  Future<Either<Failure, List<Database>>> execute() {
    return repository.getWatchlist();
  }
}
