import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../provider/movie_list_notifier_test.mocks.dart';

@GenerateMocks([GetTopRatedMovies])
void main() {
  late TopRatedMovieBloc topRatedMoviesBloc;
  late MockGetTopRatedMovies mockTopRatedMovies;

  setUp(() {
    mockTopRatedMovies = MockGetTopRatedMovies();
    topRatedMoviesBloc = TopRatedMovieBloc(mockTopRatedMovies);
  });

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  final tMovieList = <Movie>[tMovieModel];

  test('initial state should be empty', () {
    expect(topRatedMoviesBloc.state, TopRatedMovieEmpty());
  });

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'should get data from the usecase',
    build: () {
      when(mockTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedMovie()),
    verify: (bloc) {
      verify(mockTopRatedMovies.execute());
    },
  );

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'should change state to loading when usecase is called',
    build: () {
      when(mockTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.emit(TopRatedMovieLoading()),
    expect: () => [
      TopRatedMovieLoading(),
    ],
  );

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockTopRatedMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedMovie()),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockTopRatedMovies.execute());
    },
  );

  blocTest<TopRatedMovieBloc, TopRatedMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockTopRatedMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return topRatedMoviesBloc;
    },
    act: (bloc) => bloc.add(LoadTopRatedMovie()),
    expect: () => [
      TopRatedMovieLoading(),
      TopRatedMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockTopRatedMovies.execute());
    },
  );
}
