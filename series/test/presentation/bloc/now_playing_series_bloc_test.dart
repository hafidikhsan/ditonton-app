import 'package:bloc_test/bloc_test.dart';
import 'package:common/common.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:series/domain/entities/series.dart';
import 'package:series/domain/usecase/get_now_playing_series.dart';
import 'package:series/presentation/bloc/now_playing_series_bloc.dart';

import 'now_playing_series_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingSeries])
void main() {
  late NowPlayingSeriesBloc nowPlayingSeriesBloc;
  late MockGetNowPlayingSeries mockNowPlayingSeries;

  setUp(() {
    mockNowPlayingSeries = MockGetNowPlayingSeries();
    nowPlayingSeriesBloc = NowPlayingSeriesBloc(mockNowPlayingSeries);
  });

  final tSeries = Series(
    backdropPath: 'backdropPath',
    firstAir: 'firstAir',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'Moon Knight',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  final tSeriesList = <Series>[tSeries];

  test('initial state should be empty', () {
    expect(nowPlayingSeriesBloc.state, NowPlayingSeriesEmpty());
  });

  blocTest<NowPlayingSeriesBloc, NowPlayingSeriesState>(
    'should get data from the usecase',
    build: () {
      when(mockNowPlayingSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(LoadNowPlayingSeries()),
    verify: (bloc) {
      verify(mockNowPlayingSeries.execute());
    },
  );

  blocTest<NowPlayingSeriesBloc, NowPlayingSeriesState>(
    'should change state to loading when usecase is called',
    build: () {
      when(mockNowPlayingSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.emit(NowPlayingSeriesLoading()),
    expect: () => [
      NowPlayingSeriesLoading(),
    ],
  );

  blocTest<NowPlayingSeriesBloc, NowPlayingSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockNowPlayingSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(LoadNowPlayingSeries()),
    expect: () => [
      NowPlayingSeriesLoading(),
      NowPlayingSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockNowPlayingSeries.execute());
    },
  );

  blocTest<NowPlayingSeriesBloc, NowPlayingSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockNowPlayingSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return nowPlayingSeriesBloc;
    },
    act: (bloc) => bloc.add(LoadNowPlayingSeries()),
    expect: () => [
      NowPlayingSeriesLoading(),
      NowPlayingSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockNowPlayingSeries.execute());
    },
  );
}
