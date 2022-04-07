import 'package:ditonton/data/models/episodes_model.dart';
import 'package:ditonton/domain/entities/episodes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tEpisodeModel = Episode(
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

  final tEpisode = Episodes(
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

  test('should be a subclass of Episode entity', () async {
    final result = tEpisodeModel.toEntity();
    expect(result, tEpisode);
  });
}
