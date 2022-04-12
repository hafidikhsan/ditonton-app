import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'watchlist_bloc_test.mocks.dart';

@GenerateMocks([GetWatchlist])
void main() {
  late WatchlistBloc watchlistBloc;
  late MockGetWatchlist mockWatchlist;

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
          .thenAnswer((_) async => Right([testWatchlistMovie]));
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
          .thenAnswer((_) async => Right([testWatchlistMovie]));
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
          .thenAnswer((_) async => Right([testWatchlistMovie]));
      return watchlistBloc;
    },
    act: (bloc) => bloc.add(LoadWatchlist()),
    expect: () => [
      WatchlistLoading(),
      WatchlistHasData([testWatchlistMovie]),
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
      WatchlistError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockWatchlist.execute());
    },
  );
}
