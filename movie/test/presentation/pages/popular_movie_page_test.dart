import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/popular_movie_bloc.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

class MockBloc extends Mock implements PopularMovieBloc {}

class PopularMovieEventFake extends Fake implements PopularMovieEvent {}

class PopularMovieStateFake extends Fake implements PopularMovieState {}

void main() {
  late PopularMovieBloc popularMovieBloc;

  setUpAll(() {
    registerFallbackValue(PopularMovieEventFake());
    registerFallbackValue(PopularMovieStateFake());
  });

  setUp(() {
    popularMovieBloc = MockBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularMovieBloc>.value(
      value: popularMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

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

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieLoading()));
    when(() => popularMovieBloc.state).thenReturn(PopularMovieLoading());

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(progressFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieLoading()));
    when(() => popularMovieBloc.state).thenReturn(PopularMovieLoading());
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(const PopularMovieHasData(<Movie>[])));
    when(() => popularMovieBloc.state)
        .thenReturn(const PopularMovieHasData(<Movie>[]));

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    final progressFinder = find.byType(ListView);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded with data',
      (WidgetTester tester) async {
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieLoading()));
    when(() => popularMovieBloc.state).thenReturn(PopularMovieLoading());
    when(() => popularMovieBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularMovieHasData(<Movie>[tMovieModel])));
    when(() => popularMovieBloc.state)
        .thenReturn(const PopularMovieHasData(<Movie>[tMovieModel]));

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    final progressFinder = find.byType(MovieCard);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display container when Empty',
      (WidgetTester tester) async {
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieEmpty()));
    when(() => popularMovieBloc.state).thenReturn(PopularMovieEmpty());

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    final progressFinder = find.byType(Container);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => popularMovieBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularMovieError("Error Massage")));
    when(() => popularMovieBloc.state)
        .thenReturn(const PopularMovieError("Error Massage"));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
