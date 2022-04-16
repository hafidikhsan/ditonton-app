import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:series/data/models/episode_respons_model.dart';
import 'package:series/data/models/episodes_model.dart';

import '../../json_reader.dart';

void main() {
  const tEpisodesModel = Episode(
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

  const tEpisodesRespons = EpisodesRespons(
    id: 130604,
    episodes: <Episode>[tEpisodesModel],
    name: "Season 1",
    overview: "",
    posterPath: "/11keFudto4QrgrXChukexJwdHPe.jpg",
    seasonNumber: 1,
  );

  const tEpisodeResponseModel = EpisodesRespons(
    episodes: <Episode>[tEpisodesModel],
    id: 1,
    name: 'Name',
    overview: 'overview.',
    posterPath: '/path.jpg',
    seasonNumber: 1,
  );

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final Map<String, dynamic> jsonMap =
          json.decode(readJson('dummy_data/episodes.json'));
      // act
      final result = EpisodesRespons.fromJson(jsonMap);
      // assert
      expect(result, tEpisodesRespons);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tEpisodeResponseModel.toJson();
      // assert
      final expectedJsonMap = {
        "id": 1,
        "episodes": [
          {
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
          }
        ],
        "name": 'Name',
        "overview": "overview.",
        "poster_path": "/path.jpg",
        "season_number": 1,
      };
      expect(result, expectedJsonMap);
    });
  });
}
