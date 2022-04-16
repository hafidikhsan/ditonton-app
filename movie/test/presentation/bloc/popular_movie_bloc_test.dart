import 'package:bloc_test/bloc_test.dart';
import 'package:common/common/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/usecases/get_popular_movies.dart';
import 'package:movie/presentation/bloc/popular_movie_bloc.dart';

import 'popular_movie_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late PopularMovieBloc popularMoviesBloc;
  late MockGetPopularMovies mockPopularMovies;

  setUp(() {
    mockPopularMovies = MockGetPopularMovies();
    popularMoviesBloc = PopularMovieBloc(mockPopularMovies);
  });

  const tMovieModel = Movie(
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
    expect(popularMoviesBloc.state, PopularMovieEmpty());
  });

  blocTest<PopularMovieBloc, PopularMovieState>(
    'should get data from the usecase',
    build: () {
      when(mockPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(LoadPopularMovie()),
    verify: (bloc) {
      verify(mockPopularMovies.execute());
    },
  );

  blocTest<PopularMovieBloc, PopularMovieState>(
    'should change state to loading when usecase is called',
    build: () {
      when(mockPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.emit(PopularMovieLoading()),
    expect: () => [
      PopularMovieLoading(),
    ],
  );

  blocTest<PopularMovieBloc, PopularMovieState>(
    'Should emit [Loading, HasData] when data is gotten successfully',
    build: () {
      when(mockPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(LoadPopularMovie()),
    expect: () => [
      PopularMovieLoading(),
      PopularMovieHasData(tMovieList),
    ],
    verify: (bloc) {
      verify(mockPopularMovies.execute());
    },
  );

  blocTest<PopularMovieBloc, PopularMovieState>(
    'Should emit [Loading, Error] when get search is unsuccessful',
    build: () {
      when(mockPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return popularMoviesBloc;
    },
    act: (bloc) => bloc.add(LoadPopularMovie()),
    expect: () => [
      PopularMovieLoading(),
      const PopularMovieError('Server Failure'),
    ],
    verify: (bloc) {
      verify(mockPopularMovies.execute());
    },
  );
}
