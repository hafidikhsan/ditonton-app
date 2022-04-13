import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/presentation/bloc/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_series_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_series_bloc_bloc.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:ditonton/presentation/widgets/movie_poster_list.dart';
import 'package:ditonton/presentation/widgets/series_poster_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockPopularMovieBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

class PopularMovieEventFake extends Fake implements PopularMovieEvent {}

class PopularMovieStateFake extends Fake implements PopularMovieState {}

class MockTopRatedMovieBloc
    extends MockBloc<TopRatedMovieEvent, TopRatedMovieState>
    implements TopRatedMovieBloc {}

class TopRatedMovieEventFake extends Fake implements TopRatedMovieEvent {}

class TopRatedMovieStateFake extends Fake implements TopRatedMovieState {}

class MockPopularSeriesBloc
    extends MockBloc<PopularSeriesEvent, PopularSeriesState>
    implements PopularSeriesBloc {}

class PopularSeriesEventFake extends Fake implements PopularSeriesEvent {}

class PopularSeriesStateFake extends Fake implements PopularSeriesState {}

class MockTopRatedSeriesBlocBloc
    extends MockBloc<TopRatedSeriesBlocEvent, TopRatedSeriesBlocState>
    implements TopRatedSeriesBlocBloc {}

class TopRatedSeriesEventFake extends Fake implements TopRatedSeriesBlocEvent {}

class TopRatedSeriesStateFake extends Fake implements TopRatedSeriesBlocState {}

void main() {
  late PopularSeriesBloc popularSeriesBloc;
  late TopRatedSeriesBlocBloc topRatedSeriesBloc;
  late PopularMovieBloc popularMovieBloc;
  late TopRatedMovieBloc topRatedMovieBloc;

  setUpAll(() {
    registerFallbackValue(PopularMovieEventFake());
    registerFallbackValue(PopularMovieStateFake());
    registerFallbackValue(TopRatedMovieEventFake());
    registerFallbackValue(TopRatedMovieStateFake());
    registerFallbackValue(PopularSeriesEventFake());
    registerFallbackValue(PopularSeriesStateFake());
    registerFallbackValue(TopRatedSeriesEventFake());
    registerFallbackValue(TopRatedSeriesStateFake());
  });

  setUp(() {
    popularMovieBloc = MockPopularMovieBloc();
    topRatedMovieBloc = MockTopRatedMovieBloc();
    popularSeriesBloc = MockPopularSeriesBloc();
    topRatedSeriesBloc = MockTopRatedSeriesBlocBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => popularMovieBloc),
        BlocProvider(create: (context) => topRatedMovieBloc),
        BlocProvider(create: (context) => popularSeriesBloc),
        BlocProvider(create: (context) => topRatedSeriesBloc),
      ],
      child: Builder(
        builder: (_) => MaterialApp(
          home: body,
        ),
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

  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    when(() => popularSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesLoading()));
    when(() => popularSeriesBloc.state).thenReturn(PopularSeriesLoading());
    when(() => topRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesLoading()));
    when(() => topRatedSeriesBloc.state).thenReturn(TopRatedSeriesLoading());
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieLoading()));
    when(() => popularMovieBloc.state).thenReturn(PopularMovieLoading());
    when(() => topRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
    when(() => topRatedMovieBloc.state).thenReturn(TopRatedMovieLoading());

    await tester.pumpWidget(_makeTestableWidget(HomePage()));

    final progressFinder = find.byType(CircularProgressIndicator);

    expect(progressFinder, findsWidgets);
  });

  testWidgets('Page should display when data is loaded  with data',
      (WidgetTester tester) async {
    when(() => popularSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesLoading()));
    when(() => popularSeriesBloc.state).thenReturn(PopularSeriesLoading());
    when(() => topRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesLoading()));
    when(() => topRatedSeriesBloc.state).thenReturn(TopRatedSeriesLoading());
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieLoading()));
    when(() => popularMovieBloc.state).thenReturn(PopularMovieLoading());
    when(() => topRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
    when(() => topRatedMovieBloc.state).thenReturn(TopRatedMovieLoading());
    when(() => popularMovieBloc.stream).thenAnswer(
        (_) => Stream.value(PopularMovieHasData(<Movie>[tMovieModel])));
    when(() => popularMovieBloc.state)
        .thenReturn(PopularMovieHasData(<Movie>[tMovieModel]));
    when(() => topRatedMovieBloc.stream).thenAnswer(
        (_) => Stream.value(TopRatedMovieHasData(<Movie>[tMovieModel])));
    when(() => topRatedMovieBloc.state)
        .thenReturn(TopRatedMovieHasData(<Movie>[tMovieModel]));
    when(() => popularSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(PopularSeriesHasData(<Series>[tSeries])));
    when(() => popularSeriesBloc.state)
        .thenReturn(PopularSeriesHasData(<Series>[tSeries]));
    when(() => topRatedSeriesBloc.stream).thenAnswer(
        (_) => Stream.value(TopRatedSeriesHasData(<Series>[tSeries])));
    when(() => topRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesHasData(<Series>[tSeries]));

    await tester.pumpWidget(_makeTestableWidget(HomePage()));

    final seriesFinder = find.byType(SeriesList);
    final movieFinder = find.byType(MovieList);

    expect(seriesFinder, findsWidgets);
    expect(movieFinder, findsWidgets);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    when(() => popularSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesLoading()));
    when(() => popularSeriesBloc.state).thenReturn(PopularSeriesLoading());
    when(() => topRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesLoading()));
    when(() => topRatedSeriesBloc.state).thenReturn(TopRatedSeriesLoading());
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieLoading()));
    when(() => popularMovieBloc.state).thenReturn(PopularMovieLoading());
    when(() => topRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
    when(() => topRatedMovieBloc.state).thenReturn(TopRatedMovieLoading());
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieHasData(<Movie>[])));
    when(() => popularMovieBloc.state)
        .thenReturn(PopularMovieHasData(<Movie>[]));
    when(() => topRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieHasData(<Movie>[])));
    when(() => topRatedMovieBloc.state)
        .thenReturn(TopRatedMovieHasData(<Movie>[]));
    when(() => popularSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesHasData(<Series>[])));
    when(() => popularSeriesBloc.state)
        .thenReturn(PopularSeriesHasData(<Series>[]));
    when(() => topRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesHasData(<Series>[])));
    when(() => topRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesHasData(<Series>[]));

    await tester.pumpWidget(_makeTestableWidget(HomePage()));

    final progressFinder = find.byType(ListView);

    expect(progressFinder, findsWidgets);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => popularMovieBloc.stream)
        .thenAnswer((_) => Stream.value(PopularMovieError("Error Massage")));
    when(() => popularMovieBloc.state)
        .thenReturn(PopularMovieError("Error Massage"));
    when(() => topRatedMovieBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedMovieError("Error Massage")));
    when(() => topRatedMovieBloc.state)
        .thenReturn(TopRatedMovieError("Error Massage"));
    when(() => popularSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(PopularSeriesError("Error Massage")));
    when(() => popularSeriesBloc.state)
        .thenReturn(PopularSeriesError("Error Massage"));
    when(() => topRatedSeriesBloc.stream)
        .thenAnswer((_) => Stream.value(TopRatedSeriesError("Error Massage")));
    when(() => topRatedSeriesBloc.state)
        .thenReturn(TopRatedSeriesError("Error Massage"));

    final textFinder = find.byKey(Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(HomePage()));

    expect(textFinder, findsWidgets);
  });
}
