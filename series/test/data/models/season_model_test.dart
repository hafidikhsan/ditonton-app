import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:series/data/models/season_model.dart';
import 'package:series/domain/entities/season.dart';

import '../../json_reader.dart';

void main() {
  const tSeasonModel = Season(
    id: 1,
    name: 'Name',
    overview: 'overview.',
    seasonNumber: 1,
    episodeCount: 1,
    posterPath: '/path.jpg',
  );

  const tSeason = Seasons(
    id: 1,
    name: 'Name',
    overview: 'overview.',
    seasonNumber: 1,
    episodeCount: 1,
    posterPath: '/path.jpg',
  );

  test('should be a subclass of Seasons entity', () async {
    final result = tSeasonModel.toEntity();
    expect(result, tSeason);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/season.json'));
      // act
      final result = Season.fromJson(jsonMap);
      // assert
      expect(result, tSeasonModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tSeasonModel.toJson();
      // assert
      final jsonMap = {
        "id": 1,
        "name": "Name",
        "overview": "overview.",
        "season_number": 1,
        "episode_count": 1,
        "poster_path": "/path.jpg"
      };
      expect(result, jsonMap);
    });
  });
}
