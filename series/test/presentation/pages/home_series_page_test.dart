import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:series/domain/entities/series.dart';
import 'package:series/presentation/bloc/now_playing_series_bloc.dart';
import 'package:series/presentation/bloc/popular_series_bloc.dart';
import 'package:series/presentation/bloc/top_rated_series_bloc_bloc.dart';
import 'package:series/presentation/pages/home_series_page.dart';
import 'package:series/presentation/widgets/series_poster_list.dart';

class MockNowPlayingSeriesBloc
    extends MockBloc<NowPlayingSeriesEvent, NowPlayingSeriesState>
    implements NowPlayingSeriesBloc {}

class NowPlayingEventFake extends Fake implements NowPlayingSeriesEvent {}

class NowPlayingStateFake extends Fake implements NowPlayingSeriesState {}

class MockPopularSeriesBloc
    extends MockBloc<PopularSeriesEvent, PopularSeriesState>
    implements PopularSeriesBloc {}

class PopularEventFake extends Fake implements PopularSeriesEvent {}

class PopularStateFake extends Fake implements PopularSeriesState {}

class MockTopRatedSeriesBlocBloc
    extends MockBloc<TopRatedSeriesBlocEvent, TopRatedSeriesBlocState>
    implements TopRatedSeriesBlocBloc {}

class TopRatedEventFake extends Fake implements TopRatedSeriesBlocEvent {}

class TopRatedStateFake extends Fake implements TopRatedSeriesBlocState {}

void main() {
  late NowPlayingSeriesBloc nowPlayingBloc;
  late PopularSeriesBloc popularBloc;
  late TopRatedSeriesBlocBloc topRatedBloc;

  setUpAll(() {
    registerFallbackValue(NowPlayingEventFake());
    registerFallbackValue(NowPlayingStateFake());
    registerFallbackValue(PopularEventFake());
    registerFallbackValue(PopularStateFake());
    registerFallbackValue(TopRatedEventFake());
    registerFallbackValue(TopRatedStateFake());
  });

  setUp(() {
    nowPlayingBloc = MockNowPlayingSeriesBloc();
    popularBloc = MockPopularSeriesBloc();
    topRatedBloc = MockTopRatedSeriesBlocBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => nowPlayingBloc),
        BlocProvider(create: (context) => popularBloc),
        BlocProvider(create: (context) => topRatedBloc),
      ],
      child: Builder(
        builder: (_) => MaterialApp(
          home: body,
        ),
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
    when(() => nowPlayingBloc.stream)
        .thenAnswer((_) => Stream.value(NowPlayingSeriesLoading()));
    when(() => nowPlayingBloc.state).thenReturn(NowPlayingSeriesLoading());
    when(() => popularBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesLoading()));
    when(() => popularBloc.state).thenReturn(PopularSeriesLoading());
    when(() => topRatedBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesLoading()));
    when(() => topRatedBloc.state).thenReturn(TopRatedSeriesLoading());

    await tester.pumpWidget(_makeTestableWidget(const HomeSeriesPage()));

    final progressFinder = find.byType(CircularProgressIndicator);

    expect(progressFinder, findsWidgets);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => nowPlayingBloc.stream)
        .thenAnswer((_) => Stream.value(NowPlayingSeriesLoading()));
    when(() => nowPlayingBloc.state).thenReturn(NowPlayingSeriesLoading());
    when(() => nowPlayingBloc.stream).thenAnswer(
        (_) => Stream.value(const NowPlayingSeriesHasData(<Series>[])));
    when(() => nowPlayingBloc.state)
        .thenReturn(const NowPlayingSeriesHasData(<Series>[]));
    when(() => popularBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularSeriesHasData(<Series>[])));
    when(() => popularBloc.state)
        .thenReturn(const PopularSeriesHasData(<Series>[]));
    when(() => topRatedBloc.stream).thenAnswer(
        (_) => Stream.value(const TopRatedSeriesHasData(<Series>[])));
    when(() => topRatedBloc.state)
        .thenReturn(const TopRatedSeriesHasData(<Series>[]));
    when(() => popularBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesLoading()));
    when(() => popularBloc.state).thenReturn(PopularSeriesLoading());
    when(() => topRatedBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesLoading()));
    when(() => topRatedBloc.state).thenReturn(TopRatedSeriesLoading());

    await tester.pumpWidget(_makeTestableWidget(const HomeSeriesPage()));

    final progressFinder = find.byType(ListView);

    expect(progressFinder, findsWidgets);
  });

  testWidgets('Page should display when data is loaded with data',
      (WidgetTester tester) async {
    when(() => nowPlayingBloc.stream)
        .thenAnswer((_) => Stream.value(NowPlayingSeriesLoading()));
    when(() => nowPlayingBloc.state).thenReturn(NowPlayingSeriesLoading());
    when(() => nowPlayingBloc.stream).thenAnswer(
        (_) => Stream.value(const NowPlayingSeriesHasData(<Series>[tSeries])));
    when(() => nowPlayingBloc.state)
        .thenReturn(const NowPlayingSeriesHasData(<Series>[tSeries]));
    when(() => popularBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularSeriesHasData(<Series>[tSeries])));
    when(() => popularBloc.state)
        .thenReturn(const PopularSeriesHasData(<Series>[tSeries]));
    when(() => topRatedBloc.stream).thenAnswer(
        (_) => Stream.value(const TopRatedSeriesHasData(<Series>[tSeries])));
    when(() => topRatedBloc.state)
        .thenReturn(const TopRatedSeriesHasData(<Series>[tSeries]));
    when(() => popularBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesLoading()));
    when(() => popularBloc.state).thenReturn(PopularSeriesLoading());
    when(() => topRatedBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesLoading()));
    when(() => topRatedBloc.state).thenReturn(TopRatedSeriesLoading());

    await tester.pumpWidget(_makeTestableWidget(const HomeSeriesPage()));

    final progressFinder = find.byType(SeriesList);

    expect(progressFinder, findsWidgets);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => nowPlayingBloc.stream).thenAnswer(
        (_) => Stream.value(const NowPlayingSeriesError("Error Massage")));
    when(() => nowPlayingBloc.state)
        .thenReturn(const NowPlayingSeriesError("Error Massage"));
    when(() => popularBloc.stream).thenAnswer(
        (_) => Stream.value(const PopularSeriesError("Error Massage")));
    when(() => popularBloc.state)
        .thenReturn(const PopularSeriesError("Error Massage"));
    when(() => topRatedBloc.stream).thenAnswer(
        (_) => Stream.value(const TopRatedSeriesError("Error Massage")));
    when(() => topRatedBloc.state)
        .thenReturn(const TopRatedSeriesError("Error Massage"));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(const HomeSeriesPage()));

    expect(textFinder, findsWidgets);
  });
}
