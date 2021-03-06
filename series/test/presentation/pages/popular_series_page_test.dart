import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/domain/entities/series.dart';
import 'package:series/presentation/bloc/popular_series_bloc.dart';
import 'package:series/presentation/pages/popular_series_page.dart';
import 'package:series/presentation/widgets/series_card_list.dart';

class MockBloc extends Mock implements PopularSeriesBloc {}

class PopularSeriesEventFake extends Fake implements PopularSeriesEvent {}

class PopularSeriesStateFake extends Fake implements PopularSeriesState {}

void main() {
  late PopularSeriesBloc popularSeriesBloc;

  setUpAll(() {
    registerFallbackValue(PopularSeriesEventFake());
    registerFallbackValue(PopularSeriesStateFake());
  });

  setUp(() {
    popularSeriesBloc = MockBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<PopularSeriesBloc>.value(
      value: popularSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  const tSeries = Series(
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

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => popularSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesLoading()));
    when(() => popularSeriesBloc.state).thenReturn(PopularSeriesLoading());

    await tester.pumpWidget(_makeTestableWidget(const PopularSeriesPage()));

    final progressFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    expect(progressFinder, findsOneWidget);
    expect(centerFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => popularSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesLoading()));
    when(() => popularSeriesBloc.state).thenReturn(PopularSeriesLoading());
    when(() => popularSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularSeriesHasData(<Series>[])));
    when(() => popularSeriesBloc.state)
        .thenReturn(const PopularSeriesHasData(<Series>[]));

    await tester.pumpWidget(_makeTestableWidget(const PopularSeriesPage()));

    final progressFinder = find.byType(ListView);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display when data is loaded with data',
      (WidgetTester tester) async {
    when(() => popularSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesLoading()));
    when(() => popularSeriesBloc.state).thenReturn(PopularSeriesLoading());
    when(() => popularSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularSeriesHasData(<Series>[tSeries])));
    when(() => popularSeriesBloc.state)
        .thenReturn(const PopularSeriesHasData(<Series>[tSeries]));

    await tester.pumpWidget(_makeTestableWidget(const PopularSeriesPage()));

    final progressFinder = find.byType(SeriesCard);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display container when Empty',
      (WidgetTester tester) async {
    when(() => popularSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesEmpty()));
    when(() => popularSeriesBloc.state).thenReturn(PopularSeriesEmpty());

    await tester.pumpWidget(_makeTestableWidget(const PopularSeriesPage()));

    final progressFinder = find.byType(Container);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => popularSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularSeriesError("Error Massage")));
    when(() => popularSeriesBloc.state)
        .thenReturn(const PopularSeriesError("Error Massage"));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const PopularSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
