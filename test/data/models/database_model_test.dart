import 'package:ditonton/data/models/database_model.dart';
import 'package:ditonton/domain/entities/database.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  final tDatabaseModel = DatabaseModel(
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

  final tDatabaseRespons = DatabaseModel(
    id: 1,
    isMovie: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    title: 'title',
  );

  final tDatabaseResponsSeries = DatabaseModel(
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
