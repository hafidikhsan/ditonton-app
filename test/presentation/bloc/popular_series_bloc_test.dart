import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_popular_series.dart';
import 'package:ditonton/presentation/bloc/popular_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'popular_series_bloc_test.mocks.dart';

@GenerateMocks([GetPopularSeries])
void main() {
  late PopularSeriesBloc popularSeriesBloc;
  late MockGetPopularSeries mockPopularSeries;

  setUp(() {
    mockPopularSeries = MockGetPopularSeries();
    popularSeriesBloc = PopularSeriesBloc(mockPopularSeries);
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
    expect(popularSeriesBloc.state, PopularSeriesEmpty());
  });

  blocTest<PopularSeriesBloc, PopularSeriesState>(
    'should get data from the usecase',
    build: () {
      when(mockPopularSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(LoadPopularSeries()),
    verify: (bloc) {
      verify(mockPopularSeries.execute());
    },
  );

  blocTest<PopularSeriesBloc, PopularSeriesState>(
    'should change state to loading when usecase is called',
    build: () {
      when(mockPopularSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.emit(PopularSeriesLoading()),
    expect: () => [
      PopularSeriesLoading(),
    ],
  );

  blocTest<PopularSeriesBloc, PopularSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockPopularSeries.execute())
          .thenAnswer((_) async => Right(tSeriesList));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(LoadPopularSeries()),
    expect: () => [
      PopularSeriesLoading(),
      PopularSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockPopularSeries.execute());
    },
  );

  blocTest<PopularSeriesBloc, PopularSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockPopularSeries.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularSeriesBloc;
    },
    act: (bloc) => bloc.add(LoadPopularSeries()),
    expect: () => [
      PopularSeriesLoading(),
      PopularSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockPopularSeries.execute());
    },
  );
}
