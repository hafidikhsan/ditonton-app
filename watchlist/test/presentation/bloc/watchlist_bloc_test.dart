import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:common/common.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:watchlist/domain/entities/database.dart';
import 'package:watchlist/domain/usecases/get_watchlist_movies.dart';
import 'package:watchlist/presentation/bloc/watchlist_bloc.dart';

import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlist])
void main() {
  late WatchlistBloc watchlistBloc;
  late MockGetWatchlist mockWatchlist;

  const testWatchlistMovie = Database(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
    isMovie: 1,
  );

  setUp(() {
    mockWatchlist = MockGetWatchlist();
    watchlistBloc = WatchlistBloc(mockWatchlist);
  });

  test('initial state should be empty', () {
    expect(watchlistBloc.state, WatchlistEmpty());
  });

  blocTest<WatchlistBloc, WatchlistState>(
    'should get data from the usecase',
    build: () {
      when(mockWatchlist.execute())
          .thenAnswer((_) async => const Right([testWatchlistMovie]));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(LoadWatchlist()),
    verify: (bloc) {
      verify(mockWatchlist.execute());
    },
  );

  blocTest<WatchlistBloc, WatchlistState>(
    'should change state to loading when usecase is called',
    build: () {
      when(mockWatchlist.execute())
          .thenAnswer((_) async => const Right([testWatchlistMovie]));
      return watchlistBloc;
    },
    act: (bloc) => bloc.emit(WatchlistLoading()),
    expect: () => [
      WatchlistLoading(),
    ],
  );

  blocTest<WatchlistBloc, WatchlistState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockWatchlist.execute())
          .thenAnswer((_) async => const Right([testWatchlistMovie]));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(LoadWatchlist()),
    expect: () => [
      WatchlistLoading(),
      const WatchlistHasData([testWatchlistMovie]),
    ],
    verify: (bloc) {
      verify(mockWatchlist.execute());
    },
  );

  blocTest<WatchlistBloc, WatchlistState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockWatchlist.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(LoadWatchlist()),
    expect: () => [
      WatchlistLoading(),
      const WatchlistError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockWatchlist.execute());
    },
  );
}
