import 'package:ditonton/domain/entities/database.dart';
import 'package:ditonton/presentation/bloc/watchlist_bloc.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class MockBloc extends Mock implements WatchlistBloc {}

class WatchlistEventFake extends Fake implements WatchlistEvent {}

class WatchlistStateFake extends Fake implements WatchlistState {}

void main() {
  late WatchlistBloc watchlistBloc;

  setUpAll(() {
    registerFallbackValue(WatchlistEventFake());
    registerFallbackValue(WatchlistStateFake());
  });

  setUp(() {
    watchlistBloc = MockBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WatchlistBloc>.value(
      value: watchlistBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => watchlistBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistLoading()));
    when(() => watchlistBloc.state).thenReturn(WatchlistLoading());

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(progressFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded empty',
      (WidgetTester tester) async {
    when(() => watchlistBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistLoading()));
    when(() => watchlistBloc.state).thenReturn(WatchlistLoading());
    when(() => watchlistBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistHasData(<Database>[])));
    when(() => watchlistBloc.state).thenReturn(WatchlistHasData(<Database>[]));

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    final progressFinder = find.byType(Center);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => watchlistBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistLoading()));
    when(() => watchlistBloc.state).thenReturn(WatchlistLoading());
    when(() => watchlistBloc.stream).thenAnswer(
        (_) => Stream.value(WatchlistHasData(<Database>[testWatchlistMovie])));
    when(() => watchlistBloc.state)
        .thenReturn(WatchlistHasData(<Database>[testWatchlistMovie]));

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    final progressFinder = find.byType(ListView);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => watchlistBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistError("Error Massage")));
    when(() => watchlistBloc.state).thenReturn(WatchlistError("Error Massage"));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(WatchlistMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
}