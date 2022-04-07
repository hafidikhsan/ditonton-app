import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tSeasonModel = Season(
    id: 1,
    name: 'Name',
    overview: 'overview.',
    seasonNumber: 1,
    episodeCount: 1,
    posterPath: '/path.jpg',
  );

  final tSeason = Seasons(
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
}
