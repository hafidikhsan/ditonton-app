import 'package:bloc_test/bloc_test.dart';
import 'package:common/common.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:watchlist/watchlist.dart';

import 'movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListStatus,
  SaveWatchlist,
  RemoveWatchlist,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockMovieDetail;
  late MockGetMovieRecommendations mockMoviesRecomment;
  late MockGetWatchListStatus mockNMovieWatchlistStatus;
  late MockSaveWatchlist mockSaveMovie;
  late MockRemoveWatchlist mockRemoveMovie;

  setUp(() {
    mockMovieDetail = MockGetMovieDetail();
    mockMoviesRecomment = MockGetMovieRecommendations();
    mockNMovieWatchlistStatus = MockGetWatchListStatus();
    mockSaveMovie = MockSaveWatchlist();
    mockRemoveMovie = MockRemoveWatchlist();
    movieDetailBloc = MovieDetailBloc(
      mockMovieDetail,
      mockMoviesRecomment,
      mockNMovieWatchlistStatus,
      mockSaveMovie,
      mockRemoveMovie,
    );
  });

  const movieDetailState = MovieDetailState(
    isAdd: false,
    message: '',
    messageWatchlist: '',
    recomment: [],
    recommentState: RequestState.Loading,
    resultMovie: null,
    resultMovieState: RequestState.Loading,
  );

  const tId = 1;

  const tMovie = Movie(
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

  const tMovies = <Movie>[tMovie];

  const tMovieDetail = MovieDetail(
    adult: false,
    backdropPath: 'backdropPath',
    genres: [],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    runtime: 100,
    title: 'title',
    voteAverage: 1,
    voteCount: 1,
  );

  test('initial state should be empty', () {
    expect(movieDetailBloc.state, MovieDetailInitial());
  });

  group('Get Movie Detail', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits MovieDetailState when OnMovieDetail is added.',
      build: () {
        when(mockMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(tMovieDetail));
        when(mockMoviesRecomment.execute(tId))
            .thenAnswer((_) async => const Right(tMovies));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnMovieDetail(tId)),
      expect: () => [
        movieDetailState,
        movieDetailState.copyWith(
          resultMovie: tMovieDetail,
          resultMovieState: RequestState.Loaded,
          message: '',
        ),
        movieDetailState.copyWith(
          resultMovieState: RequestState.Loaded,
          resultMovie: tMovieDetail,
          recommentState: RequestState.Loaded,
          recomment: tMovies,
          message: '',
        ),
      ],
      verify: (_) {
        verify(mockMovieDetail.execute(tId));
        verify(mockMoviesRecomment.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits MovieDetailState when OnMovieDetail is error in movie detail added.',
      build: () {
        when(mockMovieDetail.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure("Failure")));
        when(mockMoviesRecomment.execute(tId))
            .thenAnswer((_) async => const Right(tMovies));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnMovieDetail(tId)),
      expect: () => [
        movieDetailState,
        movieDetailState.copyWith(
          resultMovieState: RequestState.Error,
          message: "Failure",
        ),
      ],
      verify: (_) {
        verify(mockMovieDetail.execute(tId));
        verify(mockMoviesRecomment.execute(tId));
      },
    );

    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits MovieDetailState when OnMovieDetail is error in movie recommendation added.',
      build: () {
        when(mockMovieDetail.execute(tId))
            .thenAnswer((_) async => const Right(tMovieDetail));
        when(mockMoviesRecomment.execute(tId))
            .thenAnswer((_) async => Left(ConnectionFailure("Failure")));
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnMovieDetail(tId)),
      expect: () => [
        movieDetailState,
        movieDetailState.copyWith(
          resultMovie: tMovieDetail,
          resultMovieState: RequestState.Loaded,
          message: '',
        ),
        movieDetailState.copyWith(
          resultMovieState: RequestState.Loaded,
          resultMovie: tMovieDetail,
          recommentState: RequestState.Error,
          message: 'Failure',
        ),
      ],
      verify: (_) {
        verify(mockMovieDetail.execute(tId));
        verify(mockMoviesRecomment.execute(tId));
      },
    );
  });

  group('Add To Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits MovieDetailState when OnAddDatabase is added.',
      build: () {
        when(mockSaveMovie.execute(tMovieDetail))
            .thenAnswer((_) async => const Right("Added to Watchlist"));
        when(mockNMovieWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnAddDatabase(tMovieDetail)),
      expect: () => [
        movieDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultMovieState: RequestState.Empty,
          messageWatchlist: "Added to Watchlist",
        ),
        movieDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultMovieState: RequestState.Empty,
          messageWatchlist: "Added to Watchlist",
          isAdd: true,
        ),
      ],
      verify: (_) {
        verify(mockSaveMovie.execute(tMovieDetail));
        verify(mockNMovieWatchlistStatus.execute(tId));
      },
    );
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits MovieDetailState when OnAddDatabase is failed.',
      build: () {
        when(mockSaveMovie.execute(tMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure("Failure")));
        when(mockNMovieWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnAddDatabase(tMovieDetail)),
      expect: () => [
        movieDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultMovieState: RequestState.Empty,
          messageWatchlist: "Failure",
        ),
      ],
      verify: (_) {
        verify(mockSaveMovie.execute(tMovieDetail));
        verify(mockNMovieWatchlistStatus.execute(tId));
      },
    );
  });

  group('Remove From Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits MovieDetailState when OnRemoveDatabase is added.',
      build: () {
        when(mockRemoveMovie.execute(tMovieDetail))
            .thenAnswer((_) async => const Right("Remove to Watchlist"));
        when(mockNMovieWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnRemoveDatabase(tMovieDetail)),
      expect: () => [
        movieDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultMovieState: RequestState.Empty,
          messageWatchlist: "Remove to Watchlist",
        ),
      ],
      verify: (_) {
        verify(mockRemoveMovie.execute(tMovieDetail));
        verify(mockNMovieWatchlistStatus.execute(tId));
      },
    );
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits MovieDetailState when OnRemoveDatabase is failed.',
      build: () {
        when(mockRemoveMovie.execute(tMovieDetail))
            .thenAnswer((_) async => Left(DatabaseFailure("Failure")));
        when(mockNMovieWatchlistStatus.execute(tId))
            .thenAnswer((_) async => true);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnRemoveDatabase(tMovieDetail)),
      expect: () => [
        movieDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultMovieState: RequestState.Empty,
          messageWatchlist: "Failure",
        ),
        movieDetailState.copyWith(
          recommentState: RequestState.Empty,
          resultMovieState: RequestState.Empty,
          messageWatchlist: "Failure",
          isAdd: true,
        ),
      ],
      verify: (_) {
        verify(mockRemoveMovie.execute(tMovieDetail));
        verify(mockNMovieWatchlistStatus.execute(tId));
      },
    );
  });

  group('Load From Watchlist', () {
    blocTest<MovieDetailBloc, MovieDetailState>(
      'emits MovieDetailState when OnLoadWatchlistStatus is added.',
      build: () {
        when(mockNMovieWatchlistStatus.execute(tId))
            .thenAnswer((_) async => false);
        return movieDetailBloc;
      },
      act: (bloc) => bloc.add(const OnLoadWatchlistStatus(tId)),
      expect: () => [
        movieDetailState.copyWith(
            recommentState: RequestState.Empty,
            resultMovieState: RequestState.Empty,
            isAdd: false),
      ],
      verify: (_) {
        verify(mockNMovieWatchlistStatus.execute(tId));
      },
    );
  });
}
