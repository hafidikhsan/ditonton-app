import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_series.dart';
import 'package:ditonton/presentation/bloc/top_rated_series_bloc_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/top_rated_series_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedSeries])
void main() {
  late TopRatedSeriesBlocBloc topRatedSeriesBloc;
  late MockGetTopRatedSeries mockTopRatedSeries;

  setUp(() {
    mockTopRatedSeries = MockGetTopRatedSeries();
    topRatedSeriesBloc = TopRatedSeriesBlocBloc(mockTopRatedSeries);
  });

  final tSeries = Series(
    backdropPath: 'backdropPath',
    firstAir: 'firstAir',
    genreIds: [1, 2, 3],
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
    expect(topRatedSeriesBloc.state, TopRatedSeriesEmpty());
  });

  blocTest<TopRatedSeriesBlocBloc, TopRatedSeriesBlocState>(
    'should get data from the usecase',
    build: () {
      when(mockTopRatedSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return topRatedSeriesBloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedSeries()),
    verify: (bloc) {
      verify(mockTopRatedSeries.execute());
    },
  );

  blocTest<TopRatedSeriesBlocBloc, TopRatedSeriesBlocState>(
    'should change state to loading when usecase is called',
    build: () {
      when(mockTopRatedSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return topRatedSeriesBloc;
    },
    act: (bloc) => bloc.emit(TopRatedSeriesLoading()),
    expect: () => [
      TopRatedSeriesLoading(),
    ],
  );

  blocTest<TopRatedSeriesBlocBloc, TopRatedSeriesBlocState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockTopRatedSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return topRatedSeriesBloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedSeries()),
    expect: () => [
      TopRatedSeriesLoading(),
      TopRatedSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockTopRatedSeries.execute());
    },
  );

  blocTest<TopRatedSeriesBlocBloc, TopRatedSeriesBlocState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockTopRatedSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedSeriesBloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedSeries()),
    expect: () => [
      TopRatedSeriesLoading(),
      TopRatedSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockTopRatedSeries.execute());
    },
  );
}
