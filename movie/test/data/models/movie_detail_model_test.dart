import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie/data/models/genre_model.dart';
import 'package:movie/data/models/movie_detail_model.dart';
import 'package:movie/domain/entities/genre.dart';
import 'package:movie/domain/entities/movie_detail.dart';

import '../../json_reader.dart';

void main() {
  const tMoviedDetailModel = MovieDetailResponse(
    adult: false,
    backdropPath: '/path.jpg',
    genres: <GenreModel>[],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    popularity: 1,
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    title: 'Title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
    budget: 100,
    homepage: 'https://google.com',
    imdbId: 'imdb1',
    originalLanguage: 'en',
    revenue: 12000,
    runtime: 120,
    status: 'Status',
    tagline: 'Tagline',
  );

  const tMoviedDetail = MovieDetail(
    adult: false,
    backdropPath: '/path.jpg',
    genres: <Genre>[],
    id: 1,
    originalTitle: 'Original Title',
    overview: 'Overview',
    posterPath: '/path.jpg',
    releaseDate: '2020-05-05',
    title: 'Title',
    voteAverage: 1,
    voteCount: 1,
    runtime: 120,
  );

  test('should be a subclass of Movie Detail entity', () async {
    final result = tMoviedDetailModel.toEntity();
    expect(result, tMoviedDetail);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/movie_detail.json'));
      // act
      final result = MovieDetailResponse.fromJson(jsonMap);
      // assert
      expect(result, tMoviedDetailModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tMoviedDetailModel.toJson();
      // assert
      final jsonMap = {
        "adult": false,
        "backdrop_path": '/path.jpg',
        "genres": <GenreModel>[],
        "id": 1,
        "original_title": 'Original Title',
        "overview": 'Overview',
        "popularity": 1,
        "poster_path": '/path.jpg',
        "release_date": '2020-05-05',
        "title": 'Title',
        "video": false,
        "vote_average": 1,
        "vote_count": 1,
        "budget": 100,
        "homepage": 'https://google.com',
        "imdb_id": 'imdb1',
        "original_language": 'en',
        "revenue": 12000,
        "runtime": 120,
        "status": 'Status',
        "tagline": 'Tagline',
      };
      expect(result, jsonMap);
    });
  });
}
