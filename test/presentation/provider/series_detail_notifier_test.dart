import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/data/models/episodes_model.dart';
import 'package:ditonton/domain/entities/episodes.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_series_detail.dart';
import 'package:ditonton/domain/usecases/get_series_episodes.dart';
import 'package:ditonton/domain/usecases/get_series_recomendation.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_series.dart';
import 'package:ditonton/presentation/provider/series_detail_notifier.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../json_reader.dart';
import 'series_detail_notifier_test.mocks.dart';

@GenerateMocks([
  GetSeriesDetail,
  GetSeriesRecommendations,
  GetSeriesEpisodes,
  GetWatchListStatusSeries,
  SaveWatchlistSeries,
  RemoveWatchlistSeries,
])
void main() {
  late SeriesDetailNotifier provider;
  late MockGetSeriesDetail mockGetSeriesDetail;
  late MockGetSeriesRecommendations mockGetSeriesRecommendations;
  late MockGetSeriesEpisodes mockGetSeriesEpisodes;
  late MockGetWatchListStatusSeries mockGetWatchlistStatusSeries;
  late MockSaveWatchlistSeries mockSaveWatchlistSeries;
  late MockRemoveWatchlistSeries mockRemoveWatchlistSeries;
  late int listenerCallCount;

  setUp(() {
    listenerCallCount = 0;
    mockGetSeriesDetail = MockGetSeriesDetail();
    mockGetSeriesRecommendations = MockGetSeriesRecommendations();
    mockGetSeriesEpisodes = MockGetSeriesEpisodes();
    mockGetWatchlistStatusSeries = MockGetWatchListStatusSeries();
    mockSaveWatchlistSeries = MockSaveWatchlistSeries();
    mockRemoveWatchlistSeries = MockRemoveWatchlistSeries();
    provider = SeriesDetailNotifier(
      getSeriesDetail: mockGetSeriesDetail,
      getSeriesRecommendations: mockGetSeriesRecommendations,
      getWatchListStatus: mockGetWatchlistStatusSeries,
      saveWatchlist: mockSaveWatchlistSeries,
      removeWatchlist: mockRemoveWatchlistSeries,
      getSeriesEpisodes: mockGetSeriesEpisodes,
    )..addListener(() {
        listenerCallCount += 1;
      });
  });

  final tId = 1;

  final tSerie = Series(
    backdropPath: 'backdropPath',
    firstAir: 'firstAir',
    genreIds: [1, 2, 3],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tEpisode = Episodes(
    airDate: 'airDate',
    episodeNumber: 1,
    id: 1,
    name: 'name',
    overview: 'overview',
    seasonNumber: 1,
    stillPath: 'stillPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tSeries = <Series>[tSerie];
  final tEpisodes = <Episodes>[tEpisode];

  void _arrangeUsecase() {
    when(mockGetSeriesDetail.execute(tId))
        .thenAnswer((_) async => Right(tSeriesDetail));
    when(mockGetSeriesRecommendations.execute(tId))
        .thenAnswer((_) async => Right(tSeries));
    when(mockGetSeriesEpisodes.execute(tId, tId))
        .thenAnswer((_) async => Right(tEpisodes));
  }

  group('Get Series Detail', () {
    test('initialState should be Empty', () {
      expect(provider.seriesState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeriesDetail(tId);
      await provider.getEpisodes();
      // assert
      verify(mockGetSeriesDetail.execute(tId));
      verify(mockGetSeriesRecommendations.execute(tId));
      verify(mockGetSeriesEpisodes.execute(tId, tId));
    });

    test('should change state to Loading when usecase Detail is called', () {
      // arrange
      _arrangeUsecase();
      // act
      provider.fetchSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Loading);
      expect(listenerCallCount, 1);
    });

    test('should change movie when data is gotten successfully', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeriesDetail(tId);
      await provider.getEpisodes();
      // assert
      expect(provider.seriesState, RequestState.Loaded);
      expect(provider.series, tSeriesDetail);
      expect(provider.episodesState, RequestState.Loaded);
      expect(provider.seriesEpisodes, tEpisodes);
      expect(listenerCallCount, 8);
    });

    test('should change recommendation movies when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Loaded);
      expect(provider.seriesRecommendations, tSeries);
    });
  });

  group('Get Series Recommendations', () {
    test('initialState should be Empty', () {
      expect(provider.recommendationState, equals(RequestState.Empty));
    });

    test('should get data from the usecase', () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      verify(mockGetSeriesRecommendations.execute(tId));
      expect(provider.seriesRecommendations, tSeries);
    });

    test('should update recommendation state when data is gotten successfully',
        () async {
      // arrange
      _arrangeUsecase();
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Loaded);
      expect(provider.seriesRecommendations, tSeries);
    });

    test('should update error message when request in successful', () async {
      // arrange
      when(mockGetSeriesDetail.execute(tId))
          .thenAnswer((_) async => Right(tSeriesDetail));
      when(mockGetSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Failed')));
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      expect(provider.recommendationState, RequestState.Error);
      expect(provider.message, 'Failed');
    });
  });

  group('Watchlist', () {
    test('should get the watchlist status', () async {
      // arrange
      when(mockGetWatchlistStatusSeries.execute(1))
          .thenAnswer((_) async => true);
      // act
      await provider.loadWatchlistStatus(1);
      // assert
      expect(provider.isAddedToWatchlist, true);
    });

    test('should execute save watchlist when function called', () async {
      // arrange
      when(mockSaveWatchlistSeries.execute(tSeriesDetail))
          .thenAnswer((_) async => Right('Success'));
      when(mockGetWatchlistStatusSeries.execute(tSeriesDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(tSeriesDetail);
      // assert
      verify(mockSaveWatchlistSeries.execute(tSeriesDetail));
    });

    test('should execute remove watchlist when function called', () async {
      // arrange
      when(mockRemoveWatchlistSeries.execute(tSeriesDetail))
          .thenAnswer((_) async => Right('Removed'));
      when(mockGetWatchlistStatusSeries.execute(tSeriesDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.removeFromWatchlist(tSeriesDetail);
      // assert
      verify(mockRemoveWatchlistSeries.execute(tSeriesDetail));
    });

    test('should update watchlist status when add watchlist success', () async {
      // arrange
      when(mockSaveWatchlistSeries.execute(tSeriesDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchlistStatusSeries.execute(tSeriesDetail.id))
          .thenAnswer((_) async => true);
      // act
      await provider.addWatchlist(tSeriesDetail);
      // assert
      verify(mockGetWatchlistStatusSeries.execute(tSeriesDetail.id));
      expect(provider.isAddedToWatchlist, true);
      expect(provider.watchlistMessage, 'Added to Watchlist');
      expect(listenerCallCount, 1);
    });

    test('should update watchlist message when add watchlist failed', () async {
      // arrange
      when(mockSaveWatchlistSeries.execute(tSeriesDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchlistStatusSeries.execute(tSeriesDetail.id))
          .thenAnswer((_) async => false);
      // act
      await provider.addWatchlist(tSeriesDetail);
      // assert
      expect(provider.watchlistMessage, 'Failed');
      expect(listenerCallCount, 1);
    });
  });

  group('on Error', () {
    test('should return error when data is unsuccessful', () async {
      // arrange
      when(mockGetSeriesDetail.execute(tId))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      when(mockGetSeriesRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tSeries));
      // act
      await provider.fetchSeriesDetail(tId);
      // assert
      expect(provider.seriesState, RequestState.Error);
      expect(provider.message, 'Server Failure');
      expect(listenerCallCount, 2);
    });
  });
}
