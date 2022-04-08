import 'dart:convert';

import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../json_reader.dart';

void main() {
  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of Movie entity', () async {
    final result = tMovieModel.toEntity();
    expect(result, tMovie);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/movie.json'));
      // act
      final result = MovieModel.fromJson(jsonMap);
      // assert
      expect(result, tMovieModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tMovieModel.toJson();
      // assert
      final jsonMap = {
        "adult": false,
        "backdrop_path": "backdropPath",
        "genre_ids": [1, 2, 3],
        "id": 1,
        "original_title": "originalTitle",
        "overview": "overview",
        "popularity": 1.0,
        "poster_path": "posterPath",
        "release_date": "releaseDate",
        "title": "title",
        "video": false,
        "vote_average": 1.0,
        "vote_count": 1
      };
      expect(result, jsonMap);
    });
  });
}
