import 'package:dartz/dartz.dart';
// import 'package:ditonton/common/failure.dart';
import 'package:common/common.dart';
// import 'package:ditonton/domain/entities/episodes.dart';
// import 'package:ditonton/domain/repositories/series_repository.dart';
import 'package:series/domain/entities/episodes.dart';
import 'package:series/domain/repositories/series_repository.dart';

class GetSeriesEpisodes {
  final SeriesRepository repository;

  GetSeriesEpisodes(this.repository);

  Future<Either<Failure, List<Episodes>>> execute(id, seasons) {
    return repository.getSeriesEpisodes(id, seasons);
  }
}
