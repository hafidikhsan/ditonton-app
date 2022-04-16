import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:series/data/models/genre_model.dart';
import 'package:series/data/models/series_detail_model.dart';
import 'package:series/domain/entities/genre.dart';
import 'package:series/domain/entities/series_detail.dart';

import '../../json_reader.dart';

void main() {
  const tSeriesDetailModel = SeriesDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    genres: <GenreModel>[],
    id: 1,
    overview: 'overview.',
    popularity: 1,
    posterPath: '/path.jpg',
    voteAverage: 1,
    voteCount: 1,
    firstAir: '2021-09-03',
    name: 'Name',
    originalName: 'Original Name',
    seasons: [],
  );

  const tSeriesDetail = SeriesDetail(
    adult: false,
    backdropPath: '/path.jpg',
    genres: <Genre>[],
    id: 1,
    originalName: 'Original Name',
    overview: 'overview.',
    posterPath: '/path.jpg',
    voteAverage: 1,
    voteCount: 1,
    firstAir: '2021-09-03',
    name: 'Name',
    popularity: 1,
    seasons: [],
  );

  test('should be a subclass of Series Detail entity', () async {
    final result = tSeriesDetailModel.toEntity();
    expect(result, tSeriesDetail);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/series_detail.json'));
      // act
      final result = SeriesDetailResponse.fromJson(jsonMap);
      // assert
      expect(result, tSeriesDetailModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tSeriesDetailModel.toJson();
      // assert
      final jsonMap = {
        "adult": false,
        "backdrop_path": "/path.jpg",
        "first_air_date": "2021-09-03",
        "genres": [],
        "id": 1,
        "name": "Name",
        "original_name": "Original Name",
        "overview": "overview.",
        "popularity": 1.0,
        "poster_path": "/path.jpg",
        "vote_average": 1.0,
        "vote_count": 1,
        "seasons": []
      };
      expect(result, jsonMap);
    });
  });
}
