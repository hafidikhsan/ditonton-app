import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:watchlist/domain/entities/database.dart';
import 'package:watchlist/presentation/bloc/watchlist_bloc.dart';
import 'package:watchlist/presentation/pages/watchlist_movies_page.dart';
import 'package:watchlist/presentation/widgets/watchlist_card_list.dart';

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

  const testWatchlistMovie = Database(
    id: 1,
    title: 'title',
    posterPath: 'posterPath',
    overview: 'overview',
    isMovie: 1,
  );

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

    await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

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
        .thenAnswer((_) => Stream.value(const WatchlistHasData(<Database>[])));
    when(() => watchlistBloc.state)
        .thenReturn(const WatchlistHasData(<Database>[]));

    await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

    final progressFinder = find.byType(Center);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => watchlistBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistLoading()));
    when(() => watchlistBloc.state).thenReturn(WatchlistLoading());
    when(() => watchlistBloc.stream).thenAnswer((_) =>
        Stream.value(const WatchlistHasData(<Database>[testWatchlistMovie])));
    when(() => watchlistBloc.state)
        .thenReturn(const WatchlistHasData(<Database>[testWatchlistMovie]));

    await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

    final progressFinder = find.byType(ListView);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded with data',
      (WidgetTester tester) async {
    when(() => watchlistBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistLoading()));
    when(() => watchlistBloc.state).thenReturn(WatchlistLoading());
    when(() => watchlistBloc.stream).thenAnswer((_) =>
        Stream.value(const WatchlistHasData(<Database>[testWatchlistMovie])));
    when(() => watchlistBloc.state)
        .thenReturn(const WatchlistHasData(<Database>[testWatchlistMovie]));

    await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

    final cardFinder = find.byType(WatchlistCard);
    final textFinder = find.text("Watchlist");
    final tmovieFinder = find.text("title");

    expect(cardFinder, findsOneWidget);
    expect(textFinder, findsOneWidget);
    expect(tmovieFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Errorrr',
      (WidgetTester tester) async {
    when(() => watchlistBloc.stream)
        .thenAnswer((_) => Stream.value(const WatchlistError("Error Massage")));
    when(() => watchlistBloc.state)
        .thenReturn(const WatchlistError("Error Massage"));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

    expect(textFinder, findsOneWidget);
  });
  testWidgets('Page should display container when Empty',
      (WidgetTester tester) async {
    when(() => watchlistBloc.stream)
        .thenAnswer((_) => Stream.value(WatchlistEmpty()));
    when(() => watchlistBloc.state).thenReturn(WatchlistEmpty());

    final containerFinder = find.byType(Container);

    await tester.pumpWidget(_makeTestableWidget(const WatchlistMoviesPage()));

    expect(containerFinder, findsOneWidget);
  });
}
