import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

import '../../dummy_data/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<MovieDetailEvent, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MovieDetailBloc movieDetailBloc;

  setUp(() {
    movieDetailBloc = MockMovieDetailBloc();
  });

  tearDown(() => reset(movieDetailBloc));

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
    when(() => movieDetailBloc.state).thenReturn(MovieDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loading,
      resultMovie: testMovieDetail,
      resultMovieState: RequestState.Loading,
    ));

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(
      id: 1,
    )));

    final progressFinder = find.byType(CircularProgressIndicator);

    expect(progressFinder, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(MovieDetailState(
      isAdd: false,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loaded,
      resultMovie: testMovieDetail,
      resultMovieState: RequestState.Loaded,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    when(() => movieDetailBloc.state).thenReturn(MovieDetailState(
      isAdd: true,
      message: '',
      messageWatchlist: '',
      recomment: [],
      recommentState: RequestState.Loaded,
      resultMovie: testMovieDetail,
      resultMovieState: RequestState.Loaded,
    ));

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  // testWidgets('Watchlist button should display Snackbar when add to watchlist',
  //     (WidgetTester tester) async {
  //   when(() => movieDetailBloc.state).thenReturn(MovieDetailState(
  //     isAdd: false,
  //     message: '',
  //     messageWatchlist: '',
  //     recomment: [],
  //     recommentState: RequestState.Loaded,
  //     resultMovie: testMovieDetail,
  //     resultMovieState: RequestState.Loaded,
  //   ));

  //   final watchlistButton = find.byType(ElevatedButton);

  //   await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

  //   expect(watchlistButton, findsOneWidget);
  //   expect(find.byIcon(Icons.add), findsOneWidget);

  //   await tester.tap(watchlistButton);
  //   await tester.pump();

  //   expect(find.byIcon(Icons.add), findsNothing);
  //   // final watchlistButtonIcon = find.byIcon(Icons.check);

  //   // expect(find.byType(SnackBar), findsOneWidget);
  //   // expect(watchlistButtonIcon, findsOneWidget);
  //   // expect(find.text('Added to Watchlist'), findsOneWidget);
  // });

  // testWidgets(
  //     'Watchlist button should display AlertDialog when add to watchlist failed',
  //     (WidgetTester tester) async {
  //   when(() => movieDetailBloc.state).thenReturn(MovieDetailState(
  //     isAdd: false,
  //     message: '',
  //     messageWatchlist: 'Failed',
  //     recomment: [],
  //     recommentState: RequestState.Loaded,
  //     resultMovie: testMovieDetail,
  //     resultMovieState: RequestState.Loaded,
  //   ));

  //   final watchlistButton = find.byType(ElevatedButton);

  //   await tester.pumpWidget(_makeTestableWidget(MovieDetailPage(id: 1)));

  //   expect(find.byIcon(Icons.add), findsOneWidget);

  //   await tester.tap(watchlistButton);
  //   await tester.pump();

  //   expect(find.byType(AlertDialog), findsOneWidget);
  //   expect(find.text('Failed'), findsOneWidget);
  // });
}
