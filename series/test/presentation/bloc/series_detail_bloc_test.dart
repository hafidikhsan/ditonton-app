import 'package:bloc_test/bloc_test.dart';
import 'package:common/common.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:series/domain/entities/episodes.dart';
import 'package:series/domain/entities/series.dart';
import 'package:series/domain/entities/series_detail.dart';
import 'package:series/domain/usecase/get_series_detail.dart';
import 'package:series/domain/usecase/get_series_episodes.dart';
import 'package:series/domain/usecase/get_series_recomendation.dart';
import 'package:series/domain/usecase/get_watchlist_status_series.dart';
import 'package:series/presentation/bloc/series_detail_bloc.dart';
import 'package:watchlist/domain/usecases/remove_watchlist_series.dart';
import 'package:watchlist/domain/usecases/save_watchlist_series.dart';

import 'series_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetSeriesDetail,
  GetSeriesRecommendations,
  GetSeriesEpisodes,
  GetWatchListStatusSeries,
  SaveWatchlistSeries,
  RemoveWatchlistSeries,
])
void main() {
  late SeriesDetailBloc seriesDetailBloc;
  late MockGetSeriesDetail mockSeriesDetail;
  late MockGetSeriesRecommendations mockSeriesRecomment;
  late MockGetSeriesEpisodes mockSeriesEpisode;
  late MockGetWatchListStatusSeries mockSeriesWatchlistStatus;
  late MockSaveWatchlistSeries mockSaveSeries;
  late MockRemoveWatchlistSeries mockRemoveSeries;

  setUp(() {
    mockSeriesDetail = MockGetSeriesDetail();
    mockSeriesRecomment = MockGetSeriesRecommendations();
    mockSeriesEpisode = MockGetSeriesEpisodes();
    mockSeriesWatchlistStatus = MockGetWatchListStatusSeries();
    mockSaveSeries = MockSaveWatchlistSeries();
    mockRemoveSeries = MockRemoveWatchlistSeries();
    seriesDetailBloc = SeriesDetailBloc(
      mockSeriesDetail,
      mockSeriesRecomment,
      mockSeriesEpisode,
      mockSeriesWatchlistStatus,
      mockSaveSeries,
      mockRemoveSeries,
    );
  });

  const seriesDetailState = SeriesDetailState(
    isAdd: false,
    message: '',
    messageWatchlist: '',
    recomment: [],
    recommentState: RequestState.Loading,
    resultSeries: null,
    resultSeriesState: RequestState.Loading,
    episode: [],
    episodeState: RequestState.Empty,
    id: 1,
    season: [],
    seasonValue: 1,
  );

  const tId = 1;

  const tSeries = Series(
    backdropPath: 'backdropPath',
    firstAir: 'firstAir',
    genreIds: [],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  const tSeriesList = <Series>[tSeries];

  const tSeriesDetail = SeriesDetail(
    adult: false,
    backdropPath: 'backdropPath',
    firstAir: 'firstAir',
    genres: [],
    id: 1,
    name: 'name',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
    seasons: [1],
  );

  const tEpisode = Episodes(
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

  const tEpisodes = <Episodes>[tEpisode];

  test('initial state should be empty', () {
    expect(seriesDetailBloc.state, SeriesDetailInitial());
  });

  group('Get Series Detail', () {
    blocTest<SeriesDetailBloc, SeriesDetailState>(
      'emits MovieSeriesState when OnSeriesDetail is added.',
      build: () {
        when(mockSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Right(tSeriesDetail));
        when(mockSeriesRecomment.execute(tId))
            .thenAnswer((_) async => const Right(tSeriesList));
        when(mockSeriesEpisode.execute(tId, tId))
            .thenAnswer((_) async => const Right(tEpisodes));
        return seriesDetailBloc;
      },
      act: (bloc) => bloc.add(const OnSeriesDetail(tId)),
      expect: () => [
        seriesDetailState,
        seriesDetailState.copyWith(
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          message: '',
        ),
        seriesDetailState.copyWith(
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          recommentState: RequestState.Loaded,
          recomment: tSeriesList,
          message: '',
        ),
        seriesDetailState.copyWith(
          resultSeriesState: RequestState.Loaded,
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          recommentState: RequestState.Loaded,
          recomment: tSeriesList,
          message: '',
        ),
        seriesDetailState.copyWith(
          resultSeriesState: RequestState.Loaded,
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          recommentState: RequestState.Loaded,
          episodeState: RequestState.Loading,
          recomment: tSeriesList,
          message: '',
        ),
        seriesDetailState.copyWith(
          resultSeriesState: RequestState.Loaded,
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          recommentState: RequestState.Loaded,
          recomment: tSeriesList,
          episodeState: RequestState.Loaded,
          episode: tEpisodes,
          message: '',
        ),
      ],
      verify: (_) {
        verify(mockSeriesDetail.execute(tId));
        verify(mockSeriesRecomment.execute(tId));
        verify(mockSeriesEpisode.execute(tId, tId));
      },
    );

    blocTest<SeriesDetailBloc, SeriesDetailState>(
      'emits SeriesDetailState when OnSeriesDetail is error in series detail added.',
      build: () {
        when(mockSeriesDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure("Failure")));
        when(mockSeriesRecomment.execute(tId))
            .thenAnswer((_) async => const Right(tSeriesList));
        return seriesDetailBloc;
      },
      act: (bloc) => bloc.add(const OnSeriesDetail(tId)),
      expect: () => [
        seriesDetailState,
        seriesDetailState.copyWith(
          resultSeriesState: RequestState.Error,
          message: "Failure",
        ),
      ],
      verify: (_) {
        verify(mockSeriesDetail.execute(tId));
        verify(mockSeriesRecomment.execute(tId));
      },
    );

    blocTest<SeriesDetailBloc, SeriesDetailState>(
      'emits SeriesDetailState when OnSeriesDetail is error in series recommendation added.',
      build: () {
        when(mockSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Right(tSeriesDetail));
        when(mockSeriesRecomment.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure("Failure")));
        return seriesDetailBloc;
      },
      act: (bloc) => bloc.add(const OnSeriesDetail(tId)),
      expect: () => [
        seriesDetailState,
        seriesDetailState.copyWith(
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          message: '',
        ),
        seriesDetailState.copyWith(
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          recommentState: RequestState.Error,
          message: 'Failure',
        ),
        seriesDetailState.copyWith(
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          recommentState: RequestState.Error,
          message: 'Failure',
          resultSeriesState: RequestState.Loaded,
        ),
      ],
      verify: (_) {
        verify(mockSeriesDetail.execute(tId));
        verify(mockSeriesRecomment.execute(tId));
      },
    );

    blocTest<SeriesDetailBloc, SeriesDetailState>(
      'emits SeriesDetailState when OnSeriesDetail is error in series episodes added.',
      build: () {
        when(mockSeriesDetail.execute(tId))
            .thenAnswer((_) async => const Right(tSeriesDetail));
        when(mockSeriesRecomment.execute(tId))
            .thenAnswer((_) async => const Right(tSeriesList));
        when(mockSeriesEpisode.execute(tId, tId))
            .thenAnswer((_) async => Left(ConnectionFailure("Failure")));
        return seriesDetailBloc;
      },
      act: (bloc) => bloc.add(const OnSeriesDetail(tId)),
      expect: () => [
        seriesDetailState,
        seriesDetailState.copyWith(
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          message: '',
        ),
        seriesDetailState.copyWith(
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          recommentState: RequestState.Loaded,
          recomment: tSeriesList,
          message: '',
        ),
        seriesDetailState.copyWith(
          resultSeriesState: RequestState.Loaded,
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          recommentState: RequestState.Loaded,
          recomment: tSeriesList,
          message: '',
        ),
        seriesDetailState.copyWith(
          resultSeriesState: RequestState.Loaded,
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          recommentState: RequestState.Loaded,
          episodeState: RequestState.Loading,
          recomment: tSeriesList,
          message: '',
        ),
        seriesDetailState.copyWith(
          resultSeriesState: RequestState.Loaded,
          resultSeries: tSeriesDetail,
          id: tId,
          season: [1],
          seasonValue: 1,
          recommentState: RequestState.Loaded,
          recomment: tSeriesList,
          episodeState: RequestState.Error,
          message: 'Failure',
        ),
      ],
      verify: (_) {
        verify(mockSeriesDetail.execute(tId));
        verify(mockSeriesRecomment.execute(tId));
        verify(mockSeriesEpisode.execute(tId, tId));
      },
    );
  });

  group('Season Value', () {
    blocTest<SeriesDetailBloc, SeriesDetailState>(
      'emits SeriesDetailState when OnSeasonValue is added.',
      build: () {
        when(mockSeriesEpisode.execute(tId, tId))
            .thenAnswer((_) async => const Right(tEpisodes));
        return seriesDetailBloc;
      },
      act: (bloc) => bloc.add(const OnSeasonValue(tId, tId)),
      expect: () => [
        seriesDetailState.copyWith(
          seasonValue: 1,
          recommentState: RequestState.Empty,
          resultSeriesState: RequestState.Empty,
        ),
        seriesDetailState.copyWith(
          seasonValue: 1,
          episodeState: RequestState.Loading,
          recommentState: RequestState.Empty,
          resultSeriesState: RequestState.Empty,
        ),
        seriesDetailState.copyWith(
          seasonValue: 1,
          episode: tEpisodes,
          episodeState: RequestState.Loaded,
          recommentState: RequestState.Empty,
          resultSeriesState: RequestState.Empty,
        ),
      ],
      verify: (_) {
        verify(mockSeriesEpisode.execute(tId, tId));
      },
    );
  });

  group('Add To Watchlist', () {
    blocTest<SeriesDetailBloc, SeriesDetailState>(
      'emits MovieDetailState when OnAddDatabase is added.',
      build: () {
        when(mockSaveSeries.execute(tSeriesDetail))
            .thenAnswer((_) async => const Right("Added to Watchlist"));
        when(mockSeriesWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return seriesDetailBloc;
      },
      act: (bloc) => bloc.add(const OnAddDatabase(tSeriesDetail)),
      expect: () => [
        seriesDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultSeriesState: RequestState.Empty,
          messageWatchlist: "Added to Watchlist",
        ),
        seriesDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultSeriesState: RequestState.Empty,
          messageWatchlist: "Added to Watchlist",
          isAdd: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveSeries.execute(tSeriesDetail));
        verify(mockSeriesWatchlistStatus.execute(tId));
      },
    );
    blocTest<SeriesDetailBloc, SeriesDetailState>(
      'emits MovieDetailState when OnAddDatabase is failed.',
      build: () {
        when(mockSaveSeries.execute(tSeriesDetail))
            .thenAnswer((_) async => Left(DatabaseFailure("Failure")));
        when(mockSeriesWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return seriesDetailBloc;
      },
      act: (bloc) => bloc.add(const OnAddDatabase(tSeriesDetail)),
      expect: () => [
        seriesDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultSeriesState: RequestState.Empty,
          messageWatchlist: "Failure",
        ),
      ],
      verify: (_) {
        verify(mockSaveSeries.execute(tSeriesDetail));
        verify(mockSeriesWatchlistStatus.execute(tId));
      },
    );
  });

  group('Remove From Watchlist', () {
    blocTest<SeriesDetailBloc, SeriesDetailState>(
      'emits MovieDetailState when OnRemoveDatabase is added.',
      build: () {
        when(mockRemoveSeries.execute(tSeriesDetail))
            .thenAnswer((_) async => const Right("Remove to Watchlist"));
        when(mockSeriesWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return seriesDetailBloc;
      },
      act: (bloc) => bloc.add(const OnRemoveDatabase(tSeriesDetail)),
      expect: () => [
        seriesDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultSeriesState: RequestState.Empty,
          messageWatchlist: "Remove to Watchlist",
        ),
      ],
      verify: (_) {
        verify(mockRemoveSeries.execute(tSeriesDetail));
        verify(mockSeriesWatchlistStatus.execute(tId));
      },
    );
    blocTest<SeriesDetailBloc, SeriesDetailState>(
      'emits MovieDetailState when OnRemoveDatabase is failed.',
      build: () {
        when(mockRemoveSeries.execute(tSeriesDetail))
            .thenAnswer((_) async => Left(DatabaseFailure("Failure")));
        when(mockSeriesWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return seriesDetailBloc;
      },
      act: (bloc) => bloc.add(const OnRemoveDatabase(tSeriesDetail)),
      expect: () => [
        seriesDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultSeriesState: RequestState.Empty,
          messageWatchlist: "Failure",
        ),
        seriesDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultSeriesState: RequestState.Empty,
          messageWatchlist: "Failure",
          isAdd: true,
        ),
      ],
      verify: (_) {
        verify(mockRemoveSeries.execute(tSeriesDetail));
        verify(mockSeriesWatchlistStatus.execute(tId));
      },
    );
  });

  group('Load From Watchlist', () {
    blocTest<SeriesDetailBloc, SeriesDetailState>(
      'emits SeriesDetailState when OnLoadWatchlistStatus is added.',
      build: () {
        when(mockSeriesWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return seriesDetailBloc;
      },
      act: (bloc) => bloc.add(const OnLoadWatchlistStatus(tId)),
      expect: () => [
        seriesDetailState.copyWith(
            recommentState: RequestState.Empty,
            resultSeriesState: RequestState.Empty,
            isAdd: false),
      ],
      verify: (_) {
        verify(mockSeriesWatchlistStatus.execute(tId));
      },
    );
  });
}
