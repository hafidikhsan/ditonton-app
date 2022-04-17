import 'package:flutter_test/flutter_test.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';

void main() {
  group('SearchMovieEvent', () {
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
    const tId = 1;
    group('Load', () {
      test('Load Movie Detail', () {
        expect(
          const OnMovieDetail(tId),
          const OnMovieDetail(tId),
        );
      });
      test('Load Movie Watchlist Status', () {
        expect(
          const OnLoadWatchlistStatus(tId),
          const OnLoadWatchlistStatus(tId),
        );
      });
      test('Add Movie Watchlist', () {
        expect(
          const OnAddDatabase(tMovieDetail),
          const OnAddDatabase(tMovieDetail),
        );
      });
      test('Remove Movie Watchlist', () {
        expect(
          const OnRemoveDatabase(tMovieDetail),
          const OnRemoveDatabase(tMovieDetail),
        );
      });
      test('Load MovieDetail Event', () {
        expect(
          const MovieDetailEvent(),
          const MovieDetailEvent(),
        );
      });
    });
  });
}
