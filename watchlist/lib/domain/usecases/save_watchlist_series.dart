import 'package:dartz/dartz.dart';
// import 'package:ditonton/common/failure.dart';
import 'package:common/common.dart';
// import 'package:ditonton/domain/entities/series_detail.dart';
// import 'package:ditonton/domain/repositories/series_repository.dart';
import 'package:series/series.dart';

class SaveWatchlistSeries {
  final SeriesRepository repository;

  SaveWatchlistSeries(this.repository);

  Future<Either<Failure, String>> execute(SeriesDetail series) {
    return repository.saveWatchlist(series);
  }
}
