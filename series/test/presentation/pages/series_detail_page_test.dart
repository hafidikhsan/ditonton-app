import 'package:bloc_test/bloc_test.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/presentation/bloc/series_detail_bloc.dart';
import 'package:series/presentation/pages/series_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockSeriesDetailBloc
    extends MockBloc<SeriesDetailEvent, SeriesDetailState>
    implements SeriesDetailBloc {}

void main() {
  late MockSeriesDetailBloc seriesDetailBloc;

  setUp(() {
    seriesDetailBloc = MockSeriesDetailBloc();
  });

  tearDown(() => reset(seriesDetailBloc));

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<SeriesDetailBloc>.value(
      value: seriesDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state.copyWith())
        .thenReturn(const SeriesDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loading,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loading,
      episode: [],
      episodeState: RequestState.Loading,
      id: 1,
      seasonValue: 1,
      season: [],
    ));

    await tester.pumpWidget(_makeTestableWidget(const SeriesDetailPage(
      id: 1,
    )));

    final progressFinder = find.byType(CircularProgressIndicator);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display progress bar when recomendation loading',
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state.copyWith())
        .thenReturn(const SeriesDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loading,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loaded,
      episode: [],
      episodeState: RequestState.Loading,
      id: 1,
      seasonValue: 1,
      season: [],
    ));

    await tester.pumpWidget(_makeTestableWidget(const SeriesDetailPage(
      id: 1,
    )));

    final progressFinder = find.byType(CircularProgressIndicator);

    expect(progressFinder, findsWidgets);
  });

  testWidgets('Page should display progress bar when episode loading',
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state.copyWith())
        .thenReturn(const SeriesDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loaded,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loaded,
      episode: [],
      episodeState: RequestState.Loading,
      id: 1,
      seasonValue: 1,
      season: [],
    ));

    await tester.pumpWidget(_makeTestableWidget(const SeriesDetailPage(
      id: 1,
    )));

    final progressFinder = find.byType(CircularProgressIndicator);

    expect(progressFinder, findsWidgets);
  });

  testWidgets(
      "Watchlist button should display add icon when series not added to watchlist",
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state.copyWith())
        .thenReturn(const SeriesDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loaded,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loaded,
      episode: [],
      episodeState: RequestState.Loading,
      id: 1,
      seasonValue: 1,
      season: [],
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const SeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when series is added to wathclist',
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state.copyWith())
        .thenReturn(const SeriesDetailState(
      isAdd: true,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loaded,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loaded,
      episode: [],
      episodeState: RequestState.Loaded,
      id: 1,
      seasonValue: 0,
      season: [],
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const SeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Page should display Failure when Error',
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state).thenReturn(const SeriesDetailState(
      isAdd: true,
      message: 'Failure',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loaded,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Error,
      episode: [],
      episodeState: RequestState.Loaded,
      id: 1,
      seasonValue: 0,
      season: [],
    ));

    await tester.pumpWidget(_makeTestableWidget(const SeriesDetailPage(
      id: 1,
    )));

    final progressFinder = find.text("Failure");

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display Failure when Error Recomendations',
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state).thenReturn(const SeriesDetailState(
      isAdd: true,
      message: 'Failure',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Error,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loaded,
      episode: [],
      episodeState: RequestState.Loaded,
      id: 1,
      seasonValue: 0,
      season: [],
    ));

    await tester.pumpWidget(_makeTestableWidget(const SeriesDetailPage(
      id: 1,
    )));

    final progressFinder = find.text("Failure");

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display Failure when Error Episodes',
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state).thenReturn(const SeriesDetailState(
      isAdd: true,
      message: 'Failure',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loaded,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loaded,
      episode: [],
      episodeState: RequestState.Error,
      id: 1,
      seasonValue: 0,
      season: [],
    ));

    await tester.pumpWidget(_makeTestableWidget(const SeriesDetailPage(
      id: 1,
    )));

    final progressFinder = find.text("Failure");

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display Page Not Found when Empty',
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state).thenReturn(const SeriesDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Empty,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Empty,
      episode: [],
      episodeState: RequestState.Empty,
      id: 1,
      seasonValue: 0,
      season: [],
    ));

    await tester.pumpWidget(_makeTestableWidget(const SeriesDetailPage(
      id: 1,
    )));

    final progressFinder = find.text("Page Not Found");

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display Container when Empty Recommendation',
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state).thenReturn(const SeriesDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Empty,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loaded,
      episode: [],
      episodeState: RequestState.Empty,
      id: 1,
      seasonValue: 0,
      season: [],
    ));

    await tester.pumpWidget(_makeTestableWidget(const SeriesDetailPage(
      id: 1,
    )));

    final progressFinder = find.byType(Container);

    expect(progressFinder, findsWidgets);
  });

  testWidgets('Page should display Container when Empty Episode',
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state).thenReturn(const SeriesDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loaded,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loaded,
      episode: [],
      episodeState: RequestState.Empty,
      id: 1,
      seasonValue: 0,
      season: [],
    ));

    await tester.pumpWidget(_makeTestableWidget(const SeriesDetailPage(
      id: 1,
    )));

    final progressFinder = find.byType(Container);

    expect(progressFinder, findsWidgets);
  });
}
