import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:series/series.dart';

class RemoveWatchlistSeries {
  final SeriesRepository repository;

  RemoveWatchlistSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.removeWatchlist(series);
  }
}
