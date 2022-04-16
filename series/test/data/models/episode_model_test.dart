import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:series/data/models/episodes_model.dart';
import 'package:series/domain/entities/episodes.dart';

import '../../json_reader.dart';

void main() {
  const tEpisodeModel = Episode(
    id: 2239811,
    name: 'The Goldfish Problem',
    airDate: '2022-03-30',
    episodeNumber: 1,
    overview:
        'Steven Grant learns that he may be a superhero, but may also share a body with a ruthless mercenary.',
    seasonNumber: 1,
    stillPath: '/uA81REU7p7bniOQfplpbGIMWCe.jpg',
    voteAverage: 7.882,
    voteCount: 17,
  );

  const tEpisode = Episodes(
    id: 2239811,
    name: 'The Goldfish Problem',
    airDate: '2022-03-30',
    episodeNumber: 1,
    overview:
        'Steven Grant learns that he may be a superhero, but may also share a body with a ruthless mercenary.',
    seasonNumber: 1,
    stillPath: '/uA81REU7p7bniOQfplpbGIMWCe.jpg',
    voteAverage: 7.882,
    voteCount: 17,
  );

  const tEpisodeFromJson = Episode(
    id: 2239811,
    name: "The Goldfish Problem",
    overview:
        "Steven Grant learns that he may be a superhero, but may also share a body with a ruthless mercenary.",
    seasonNumber: 1,
    airDate: '2022-03-30',
    episodeNumber: 1,
    stillPath: '/uA81REU7p7bniOQfplpbGIMWCe.jpg',
    voteAverage: 7.882,
    voteCount: 17,
  );

  test('should be a subclass of Episode entity', () async {
    final result = tEpisodeModel.toEntity();
    expect(result, tEpisode);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/episode.json'));
      // act
      final result = Episode.fromJson(jsonMap);
      // assert
      expect(result, tEpisodeFromJson);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tEpisodeFromJson.toJson();
      // assert
      final expectedJsonMap = {
        "id": 2239811,
        "name": 'The Goldfish Problem',
        "air_date": '2022-03-30',
        "episode_number": 1,
        "overview":
            'Steven Grant learns that he may be a superhero, but may also share a body with a ruthless mercenary.',
        "season_number": 1,
        "still_path": '/uA81REU7p7bniOQfplpbGIMWCe.jpg',
        "vote_average": 7.882,
        "vote_count": 17,
      };
      expect(result, expectedJsonMap);
    });
  });
}
