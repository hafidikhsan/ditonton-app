import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/presentation/bloc/search_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/search_series_bloc.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:ditonton/presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBloc extends Mock implements SearchMovieBloc {}

class SearchMovieEventFake extends Fake implements SearchMovieEvent {}

class SearchMovieStateFake extends Fake implements SearchMovieState {}

class MockSeriesBloc extends Mock implements SearchSeriesBloc {}

class SearchSeriesEventFake extends Fake implements SearchSeriesEvent {}

class SearchSeriesStateFake extends Fake implements SearchSeriesState {}

void main() {
  late SearchMovieBloc searchMovieBloc;
  late SearchSeriesBloc searchSeriesBloc;

  setUpAll(() {
    registerFallbackValue(SearchMovieEventFake());
    registerFallbackValue(SearchMovieStateFake());
    registerFallbackValue(SearchSeriesEventFake());
    registerFallbackValue(SearchSeriesStateFake());
  });

  setUp(() {
    searchMovieBloc = MockBloc();
    searchSeriesBloc = MockSeriesBloc();
  });

  Widget _makeTestableWidgetMovie(Widget body) {
    return BlocProvider<SearchMovieBloc>.value(
      value: searchMovieBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tMovieModel = Movie(
    adult: false,
    backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
    genreIds: [14, 28],
    id: 557,
    originalTitle: 'Spider-Man',
    overview:
        'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
    popularity: 60.441,
    posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
    releaseDate: '2002-05-01',
    title: 'Spider-Man',
    video: false,
    voteAverage: 7.2,
    voteCount: 13507,
  );

  Widget _makeTestableWidgetSeries(Widget body) {
    return BlocProvider<SearchSeriesBloc>.value(
      value: searchSeriesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  final tSeries = Series(
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

  group('Movies', () {
    testWidgets('Page should display progress bar when loading',
        (WidgetTester tester) async {
      when(() => searchMovieBloc.stream)
          .thenAnswer((_) => Stream.value(SearchLoading()));
      when(() => searchMovieBloc.state).thenReturn(SearchLoading());

      await tester.pumpWidget(
        _makeTestableWidgetMovie(
          SearchPage(
            isMovie: true,
          ),
        ),
      );

      final progressFinder = find.byType(CircularProgressIndicator);

      expect(progressFinder, findsOneWidget);
    });

    testWidgets('Page should display when data is loaded',
        (WidgetTester tester) async {
      when(() => searchMovieBloc.stream)
          .thenAnswer((_) => Stream.value(SearchLoading()));
      when(() => searchMovieBloc.state).thenReturn(SearchLoading());
      when(() => searchMovieBloc.stream)
          .thenAnswer((_) => Stream.value(SearchHasData(<Movie>[])));
      when(() => searchMovieBloc.state).thenReturn(SearchHasData(<Movie>[]));

      await tester.pumpWidget(
        _makeTestableWidgetMovie(
          SearchPage(
            isMovie: true,
          ),
        ),
      );

      final progressFinder = find.byType(ListView);

      expect(progressFinder, findsOneWidget);
    });

    testWidgets('Page should display when data is loaded with data',
        (WidgetTester tester) async {
      when(() => searchMovieBloc.stream)
          .thenAnswer((_) => Stream.value(SearchLoading()));
      when(() => searchMovieBloc.state).thenReturn(SearchLoading());
      when(() => searchMovieBloc.stream)
          .thenAnswer((_) => Stream.value(SearchHasData(<Movie>[tMovieModel])));
      when(() => searchMovieBloc.state)
          .thenReturn(SearchHasData(<Movie>[tMovieModel]));

      await tester.pumpWidget(
        _makeTestableWidgetMovie(
          SearchPage(
            isMovie: true,
          ),
        ),
      );

      final progressFinder = find.byType(MovieCard);

      expect(progressFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => searchMovieBloc.stream)
          .thenAnswer((_) => Stream.value(SearchError("Error Massage")));
      when(() => searchMovieBloc.state)
          .thenReturn(SearchError("Error Massage"));

      final textFinder = find.text("Error Massage");

      await tester.pumpWidget(
        _makeTestableWidgetMovie(
          SearchPage(
            isMovie: true,
          ),
        ),
      );

      expect(textFinder, findsOneWidget);
    });
  });

  group('Series', () {
    testWidgets('Page should display progress bar when loading',
        (WidgetTester tester) async {
      when(() => searchSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(SearchSeriesLoading()));
      when(() => searchSeriesBloc.state).thenReturn(SearchSeriesLoading());

      await tester.pumpWidget(
        _makeTestableWidgetSeries(
          SearchPage(
            isMovie: false,
          ),
        ),
      );

      final progressFinder = find.byType(CircularProgressIndicator);

      expect(progressFinder, findsOneWidget);
    });

    testWidgets('Page should display when data is loaded',
        (WidgetTester tester) async {
      when(() => searchSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(SearchSeriesLoading()));
      when(() => searchSeriesBloc.state).thenReturn(SearchSeriesLoading());
      when(() => searchSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(SearchSeriesHasData(<Series>[])));
      when(() => searchSeriesBloc.state)
          .thenReturn(SearchSeriesHasData(<Series>[]));

      await tester.pumpWidget(
        _makeTestableWidgetSeries(
          SearchPage(
            isMovie: false,
          ),
        ),
      );

      final progressFinder = find.byType(ListView);

      expect(progressFinder, findsOneWidget);
    });

    testWidgets('Page should display when data is loaded with data',
        (WidgetTester tester) async {
      when(() => searchSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(SearchSeriesLoading()));
      when(() => searchSeriesBloc.state).thenReturn(SearchSeriesLoading());
      when(() => searchSeriesBloc.stream).thenAnswer(
          (_) => Stream.value(SearchSeriesHasData(<Series>[tSeries])));
      when(() => searchSeriesBloc.state)
          .thenReturn(SearchSeriesHasData(<Series>[tSeries]));

      await tester.pumpWidget(
        _makeTestableWidgetSeries(
          SearchPage(
            isMovie: false,
          ),
        ),
      );

      final progressFinder = find.byType(SeriesCard);

      expect(progressFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => searchSeriesBloc.stream)
          .thenAnswer((_) => Stream.value(SearchSeriesError("Error Massage")));
      when(() => searchSeriesBloc.state)
          .thenReturn(SearchSeriesError("Error Massage"));

      final textFinder = find.text("Error Massage");

      await tester.pumpWidget(
        _makeTestableWidgetSeries(
          SearchPage(
            isMovie: false,
          ),
        ),
      );

      expect(textFinder, findsOneWidget);
    });
  });
}
