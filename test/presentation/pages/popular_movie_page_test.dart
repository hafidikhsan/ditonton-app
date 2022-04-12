import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/popular_movie_bloc.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieLoading()));
    when(() => popularMovieBloc.state).thenReturn(PopularMovieLoading());

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

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
        .thenAnswer((_) => Stream.value(PopularMovieHasData(<Movie>[])));
    when(() => popularMovieBloc.state)
        .thenReturn(PopularMovieHasData(<Movie>[]));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    final progressFinder = find.byType(ListView);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieError("Error Massage")));
    when(() => popularMovieBloc.state)
        .thenReturn(PopularMovieError("Error Massage"));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}
