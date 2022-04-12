import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/presentation/bloc/top_rated_series_bloc_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

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
    when(() => topRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesHasData(<Series>[])));
    when(() => topRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesHasData(<Series>[]));

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

    final progressFinder = find.byType(ListView);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => topRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesError("Error Massage")));
    when(() => topRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesError("Error Massage"));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedSeriesPage()));

    expect(textFinder, findsOneWidget);
  });
}
