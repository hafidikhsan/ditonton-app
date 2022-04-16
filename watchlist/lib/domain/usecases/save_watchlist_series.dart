import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:series/series.dart';

class SaveWatchlistSeries {
  final SeriesRepository repository;

  SaveWatchlistSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.saveWatchlist(series);
  }
}
