import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series_detail.dart';

abstract class SeriesRepository {
  Future<Either<Failure, List<Series>>> getNowPlayingSeries();
  Future<Either<Failure, List<Series>>> getPopularSeries();
  Future<Either<Failure, List<Series>>> getTopRatedSeries();
  Future<Either<Failure, SeriesDetail>> getSeriesDetail(int id);
  Future<Either<Failure, List<Series>>> getSeriesRecommendations(int id);
}
