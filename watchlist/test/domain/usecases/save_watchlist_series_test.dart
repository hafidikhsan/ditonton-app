import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/domain/usecases/save_watchlist_series.dart';
import 'package:series/series.dart' as series;

import '../../helper/test_helper.mocks.dart';

void main() {
  late SaveWatchlistSeries usecase;
  late MockSeriesRepository mockSeriesRepository;

  final testSeriesDetail = series.SeriesDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [series.Genre(id: 1, name: 'Action')],
    id: 1,
    overview: 'overview',
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    firstAir: '2022-04-08',
    name: 'title',
    originalName: 'Original Name',
    popularity: 1,
    seasons: const [],
  );

  setUp(() {
    mockSeriesRepository = MockSeriesRepository();
    usecase = SaveWatchlistSeries(mockSeriesRepository);
  });

  test('should save series to the repository', () async {
    // arrange
    when(mockSeriesRepository.saveWatchlist(testSeriesDetail))
        .thenAnswer((_) async => const Right('Added to Watchlist'));
    // act
    final result = await usecase.execute(testSeriesDetail);
    // assert
    verify(mockSeriesRepository.saveWatchlist(testSeriesDetail));
    expect(result, const Right('Added to Watchlist'));
  });
}
