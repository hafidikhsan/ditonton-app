import 'package:bloc_test/bloc_test.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/presentation/bloc/series_detail_bloc.dart';
import 'package:series/presentation/pages/series_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<SeriesDetailEvent, SeriesDetailState>
    implements SeriesDetailBloc {}

void main() {
  late SeriesDetailBloc seriesDetailBloc;

  setUp(() {
    seriesDetailBloc = MockMovieDetailBloc();
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
    when(() => seriesDetailBloc.state.copyWith()).thenReturn(SeriesDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: const [],
      recommentState: RequestState.Loading,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loading,
      episode: const [],
      episodeState: RequestState.Loading,
      id: 1,
      seasonValue: 1,
      season: const [],
    ));

    await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(
      id: 1,
    )));

    final progressFinder = find.byType(CircularProgressIndicator);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets(
      "'Watchlist button should display add icon when series not added to watchlist'",
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state.copyWith()).thenReturn(SeriesDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: const [],
      recommentState: RequestState.Loaded,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loaded,
      episode: const [],
      episodeState: RequestState.Loaded,
      id: 1,
      seasonValue: 0,
      season: const [],
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when series is added to wathclist',
      (WidgetTester tester) async {
    when(() => seriesDetailBloc.state.copyWith()).thenReturn(SeriesDetailState(
      isAdd: true,
      message: '',
      messageWatchlist: '',
      recomment: const [],
      recommentState: RequestState.Loaded,
      resultSeries: testSeriesDetail,
      resultSeriesState: RequestState.Loaded,
      episode: const [],
      episodeState: RequestState.Loaded,
      id: 1,
      seasonValue: 0,
      season: const [],
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  // testWidgets(
  //     'Watchlist button should display Snackbar when added to watchlist',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.seriesState).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.series).thenReturn(testSeriesDetail);
  //   when(mockNotifier.episodesState).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.seriesEpisodes).thenReturn(<Episodes>[]);
  //   when(mockNotifier.seasonValue).thenReturn(0);
  //   when(mockNotifier.season).thenReturn(<int>[]);
  //   when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.seriesRecommendations).thenReturn(<Series>[]);
  //   when(mockNotifier.isAddedToWatchlist).thenReturn(false);
  //   when(mockNotifier.id).thenReturn(1);
  //   when(mockNotifier.watchlistMessage).thenReturn('Added to Watchlist');

  //   final watchlistButton = find.byType(ElevatedButton);

  //   await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

  //   expect(find.byIcon(Icons.add), findsOneWidget);

  //   await tester.tap(watchlistButton);
  //   await tester.pump();

  //   expect(find.byType(SnackBar), findsOneWidget);
  //   expect(find.text('Added to Watchlist'), findsOneWidget);
  // });

  // testWidgets(
  //     'Watchlist button should display AlertDialog when add to watchlist failed',
  //     (WidgetTester tester) async {
  //   when(mockNotifier.seriesState).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.series).thenReturn(testSeriesDetail);
  //   when(mockNotifier.episodesState).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.seriesEpisodes).thenReturn(<Episodes>[]);
  //   when(mockNotifier.seasonValue).thenReturn(0);
  //   when(mockNotifier.season).thenReturn(<int>[]);
  //   when(mockNotifier.recommendationState).thenReturn(RequestState.Loaded);
  //   when(mockNotifier.seriesRecommendations).thenReturn(<Series>[]);
  //   when(mockNotifier.isAddedToWatchlist).thenReturn(false);
  //   when(mockNotifier.id).thenReturn(1);
  //   when(mockNotifier.watchlistMessage).thenReturn('Failed');

  //   final watchlistButton = find.byType(ElevatedButton);

  //   await tester.pumpWidget(_makeTestableWidget(SeriesDetailPage(id: 1)));

  //   expect(find.byIcon(Icons.add), findsOneWidget);

  //   await tester.tap(watchlistButton);
  //   await tester.pump();

  //   expect(find.byType(AlertDialog), findsOneWidget);
  //   expect(find.text('Failed'), findsOneWidget);
  // });
}
