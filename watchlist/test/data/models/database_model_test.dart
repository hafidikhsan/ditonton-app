import 'package:flutter_test/flutter_test.dart';
import 'package:movie/movie.dart' as movie;
import 'package:series/series.dart' as series;
import 'package:watchlist/data/models/database_model.dart';
import 'package:watchlist/domain/entities/database.dart';

void main() {
  const tDatabaseModel = DatabaseModel(
    id: 1,
    isMovie: 1,
    overview: 'overview.',
    posterPath: '/path.jpg',
    title: 'title',
  );

  final tDatabase = Database(
    id: 1,
    isMovie: 1,
    overview: 'overview.',
    posterPath: '/path.jpg',
    title: 'title',
  );

  const tDatabaseRespons = DatabaseModel(
    id: 1,
    isMovie: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    title: 'title',
  );

  const tDatabaseResponsSeries = DatabaseModel(
    id: 1,
    isMovie: 0,
    overview: 'overview',
    posterPath: 'posterPath',
    title: 'title',
  );

  final tDatabaseMap = {
    "id": 1,
    "isMovie": 0,
    "overview": 'overview',
    "posterPath": 'posterPath',
    "title": 'title',
  };

  final testMovieDetail = movie.MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [movie.Genre(id: 1, name: 'Action')],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 120,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  final testSeriesDetail = series.SeriesDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [series.Genre(id: 1, name: 'Action')],
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    firstAir: '2022-04-08',
    name: 'title',
    originalName: 'Original Name',
    popularity: 1,
    seasons: [],
  );

  test('should be a subclass of Database entity', () async {
    final result = tDatabaseModel.toEntity();
    expect(result, tDatabase);
  });

  group('return Movie Detail', () {
    test('should return a valid Database model from Movie Detail', () async {
      // act
      final result = DatabaseModel.fromMovieEntity(testMovieDetail);
      // assert
      expect(result, tDatabaseRespons);
    });
  });

  group('return Series Detail', () {
    test('should return a valid Database model from Series Detail', () async {
      // act
      final result = DatabaseModel.fromSeriesEntity(testSeriesDetail);
      // assert
      expect(result, tDatabaseResponsSeries);
    });
  });

  group('From Map', () {
    test('should return a valid Database model from Map', () async {
      // act
      final result = DatabaseModel.fromMap(tDatabaseMap);
      // assert
      expect(result, tDatabaseResponsSeries);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tDatabaseRespons.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "title": 'title',
        "overview": "overview",
        "posterPath": "posterPath",
        "isMovie": 1,
      };
      expect(result, expectedJsonMap);
    });
  });
}
