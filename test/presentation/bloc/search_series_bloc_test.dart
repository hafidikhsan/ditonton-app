import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/search_series.dart';
import 'package:ditonton/presentation/bloc/search_series_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/series_search_notifier_test.mocks.dart';

@GenerateMocks([SearchSeries])
void main() {
  late SearchSeriesBloc searchBloc;
  late MockSearchSeries mockSearchSeries;

  setUp(() {
    mockSearchSeries = MockSearchSeries();
    searchBloc = SearchSeriesBloc(mockSearchSeries);
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
  final tQuery = 'moon';

  test('initial state should be empty', () {
    expect(searchBloc.state, SearchSeriesEmpty());
  });

  blocTest<SearchSeriesBloc, SearchSeriesState>(
    'should get data from the usecase',
    build: () {
      when(mockSearchSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tSeriesList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnSeriesQueryChanged(tQuery)),
    verify: (bloc) {
      verify(mockSearchSeries.execute(tQuery));
    },
  );

  blocTest<SearchSeriesBloc, SearchSeriesState>(
    'should change state to loading when usecase is called',
    build: () {
      when(mockSearchSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tSeriesList));
      return searchBloc;
    },
    act: (bloc) => bloc.emit(SearchSeriesLoading()),
    expect: () => [
      SearchSeriesLoading(),
    ],
  );

  blocTest<SearchSeriesBloc, SearchSeriesState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockSearchSeries.execute(tQuery))
          .thenAnswer((_) async => Right(tSeriesList));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnSeriesQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchSeriesLoading(),
      SearchSeriesHasData(tSeriesList),
    ],
    verify: (bloc) {
      verify(mockSearchSeries.execute(tQuery));
    },
  );

  blocTest<SearchSeriesBloc, SearchSeriesState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockSearchSeries.execute(tQuery))
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return searchBloc;
    },
    act: (bloc) => bloc.add(OnSeriesQueryChanged(tQuery)),
    wait: const Duration(milliseconds: 500),
    expect: () => [
      SearchSeriesLoading(),
      SearchSeriesError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockSearchSeries.execute(tQuery));
    },
  );
}
