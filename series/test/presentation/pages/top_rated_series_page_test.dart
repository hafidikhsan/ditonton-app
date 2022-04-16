import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/domain/entities/series.dart';
import 'package:series/presentation/bloc/top_rated_series_bloc_bloc.dart';
import 'package:series/presentation/pages/top_rated_series_page.dart';
import 'package:series/presentation/widgets/series_card_list.dart';

class MockBloc extends Mock implements TopRatedSeriesBlocBloc {}

class TopRatedSeriesBlocEventFake extends Fake
    implements TopRatedSeriesBlocEvent {}

class TopRatedSeriesBlocStateFake extends Fake
    implements TopRatedSeriesBlocState {}

void main() {
  late TopRatedSeriesBlocBloc topRatedSeriesBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedSeriesBlocEventFake());
    registerFallbackValue(TopRatedSeriesBlocStateFake());
  });

  setUp(() {
    topRatedSeriesBloc = MockBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedSeriesBlocBloc>.value(
      value: topRatedSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tSeries = Series(
    backdropPath: 'backdropPath',
    firstAir: 'firstAir',
    genreIds: const [1, 2, 3],
    id: 1,
    name: 'Moon Knight',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    voteAverage: 1,
    voteCount: 1,
  );

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => topRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesLoading()));
    when(() => topRatedSeriesBloc.state).thenReturn(TopRatedSeriesLoading());

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(progressFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => topRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesLoading()));
    when(() => topRatedSeriesBloc.state).thenReturn(TopRatedSeriesLoading());
    when(() => topRatedSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(TopRatedSeriesHasData(const <Series>[])));
    when(() => topRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesHasData(const <Series>[]));

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

    final progressFinder = find.byType(ListView);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded with data',
      (WidgetTester tester) async {
    when(() => topRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesLoading()));
    when(() => topRatedSeriesBloc.state).thenReturn(TopRatedSeriesLoading());
    when(() => topRatedSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(TopRatedSeriesHasData(<Series>[tSeries])));
    when(() => topRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesHasData(<Series>[tSeries]));

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

    final progressFinder = find.byType(SeriesCard);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => topRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesError("Error Massage")));
    when(() => topRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesError("Error Massage"));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
