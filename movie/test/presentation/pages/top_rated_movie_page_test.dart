import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/top_rated_movie_bloc.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

class MockBloc extends Mock implements TopRatedMovieBloc {}

class TopRatedMovieEventFake extends Fake implements TopRatedMovieEvent {}

class TopRatedMovieStateFake extends Fake implements TopRatedMovieState {}

void main() {
  late TopRatedMovieBloc topRatedMovieBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedMovieEventFake());
    registerFallbackValue(TopRatedMovieStateFake());
  });

  setUp(() {
    topRatedMovieBloc = MockBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedMovieBloc>.value(
      value: topRatedMovieBloc,
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
    when(() => topRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
    when(() => topRatedMovieBloc.state).thenReturn(TopRatedMovieLoading());

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(progressFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => topRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
    when(() => topRatedMovieBloc.state).thenReturn(TopRatedMovieLoading());
    when(() => topRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(const TopRatedMovieHasData(<Movie>[])));
    when(() => topRatedMovieBloc.state)
        .thenReturn(const TopRatedMovieHasData(<Movie>[]));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    final progressFinder = find.byType(ListView);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded with data',
      (WidgetTester tester) async {
    when(() => topRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
    when(() => topRatedMovieBloc.state).thenReturn(TopRatedMovieLoading());
    when(() => topRatedMovieBloc.stream).thenAnswer(
        (_) => Stream.value(const TopRatedMovieHasData(<Movie>[tMovieModel])));
    when(() => topRatedMovieBloc.state)
        .thenReturn(const TopRatedMovieHasData(<Movie>[tMovieModel]));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    final progressFinder = find.byType(MovieCard);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display container when Empty',
      (WidgetTester tester) async {
    when(() => topRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieEmpty()));
    when(() => topRatedMovieBloc.state).thenReturn(TopRatedMovieEmpty());

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    final progressFinder = find.byType(Container);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => topRatedMovieBloc.stream).thenAnswer(
        (_) => Stream.value(const TopRatedMovieError("Error Massage")));
    when(() => topRatedMovieBloc.state)
        .thenReturn(const TopRatedMovieError("Error Massage"));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const TopRatedMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
