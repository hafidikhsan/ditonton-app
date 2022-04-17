import 'package:bloc_test/bloc_test.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/presentation/bloc/movie_detail_bloc.dart';
import 'package:movie/presentation/pages/movie_detail_page.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc movieDetailBloc;

  setUp(() {
    movieDetailBloc = MockMovieDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: movieDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(const MovieDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loading,
      resultMovie: testMovieDetail,
      resultMovieState: RequestState.Loading,
    ));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(
      id: 1,
    )));

    final progressFinder = find.byType(CircularProgressIndicator);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display progress bar when loading recomendation',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(const MovieDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loading,
      resultMovie: testMovieDetail,
      resultMovieState: RequestState.Loaded,
    ));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(
      id: 1,
    )));

    final progressFinder = find.byType(CircularProgressIndicator);

    expect(progressFinder, findsWidgets);
  });

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(const MovieDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loaded,
      resultMovie: testMovieDetail,
      resultMovieState: RequestState.Loaded,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(const MovieDetailState(
      isAdd: true,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loaded,
      resultMovie: testMovieDetail,
      resultMovieState: RequestState.Loaded,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets('Page should display Failure when Error',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(const MovieDetailState(
      isAdd: false,
      message: 'Failure',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loading,
      resultMovie: testMovieDetail,
      resultMovieState: RequestState.Error,
    ));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(
      id: 1,
    )));

    final progressFinder = find.text("Failure");

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display Failure when Error Recomendation',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(const MovieDetailState(
      isAdd: false,
      message: 'Failure.',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Error,
      resultMovie: testMovieDetail,
      resultMovieState: RequestState.Loaded,
    ));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(
      id: 1,
    )));

    final progressFinder = find.text("Failure.");

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display Page Not Found when Empty',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(const MovieDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Empty,
      resultMovie: testMovieDetail,
      resultMovieState: RequestState.Empty,
    ));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(
      id: 1,
    )));

    final progressFinder = find.text("Page Not Found");

    expect(progressFinder, findsOneWidget);
  });

  testWidgets('Page should display Container when Empty Recommendation',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(const MovieDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Empty,
      resultMovie: testMovieDetail,
      resultMovieState: RequestState.Loaded,
    ));

    await tester.pumpWidget(_makeTestableWidget(const MovieDetailPage(
      id: 1,
    )));

    final progressFinder = find.byType(Container);

    expect(progressFinder, findsWidgets);
  });
}
