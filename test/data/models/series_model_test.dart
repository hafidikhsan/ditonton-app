import 'dart:convert';

import 'package:ditonton/data/models/series_model.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tSeriesModel = SeriesModel(
    backdropPath: 'backdropPath',
    firstAir: "first air",
    genreIds: [1, 2, 3],
    id: 1,
    name: 'Name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tSeries = Series(
    backdropPath: 'backdropPath',
    firstAir: "first air",
    genreIds: [1, 2, 3],
    id: 1,
    name: 'Name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of Series entity', () async {
    final result = tSeriesModel.toEntity();
    expect(result, tSeries);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/series.json'));
      // act
      final result = SeriesModel.fromJson(jsonMap);
      // assert
      expect(result, tSeriesModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tSeriesModel.toJson();
      // assert
      final jsonMap = {
        "backdrop_path": "backdropPath",
        "first_air_date": "first air",
        "genre_ids": [1, 2, 3],
        "id": 1,
        "name": "Name",
        "original_name": "originalName",
        "overview": "overview",
        "popularity": 1,
        "poster_path": "posterPath",
        "vote_average": 1,
        "vote_count": 1
      };
      expect(result, jsonMap);
    });
  });
}
