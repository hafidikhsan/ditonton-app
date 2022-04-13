import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/now_playing_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/popular_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/top_rated_movie_bloc.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/widgets/movie_poster_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNowPlayingMovieBloc
    extends MockBloc<NowPlayingMovieEvent, NowPlayingMovieState>
    implements NowPlayingMovieBloc {}

class NowPlayingEventFake extends Fake implements NowPlayingMovieEvent {}

class NowPlayingStateFake extends Fake implements NowPlayingMovieState {}

class MockPopularMovieBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

class PopularEventFake extends Fake implements PopularMovieEvent {}

class PopularStateFake extends Fake implements PopularMovieState {}

class MockTopRatedMovieBloc
    extends MockBloc<TopRatedMovieEvent, TopRatedMovieState>
    implements TopRatedMovieBloc {}

class TopRatedEventFake extends Fake implements TopRatedMovieEvent {}

class TopRatedStateFake extends Fake implements TopRatedMovieState {}

void main() {
  late NowPlayingMovieBloc nowPlayingBloc;
  late PopularMovieBloc popularBloc;
  late TopRatedMovieBloc topRatedBloc;

  setUpAll(() {
    registerFallbackValue(NowPlayingEventFake());
    registerFallbackValue(NowPlayingStateFake());
    registerFallbackValue(PopularEventFake());
    registerFallbackValue(PopularStateFake());
    registerFallbackValue(TopRatedEventFake());
    registerFallbackValue(TopRatedStateFake());
  });

  setUp(() {
    nowPlayingBloc = MockNowPlayingMovieBloc();
    popularBloc = MockPopularMovieBloc();
    topRatedBloc = MockTopRatedMovieBloc();
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

  group('Movie', () {
    testWidgets('Page should display progress bar when loading',
        (WidgetTester tester) async {
      when(() => nowPlayingBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingMovieLoading()));
      when(() => nowPlayingBloc.state).thenReturn(NowPlayingMovieLoading());
      when(() => popularBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieLoading()));
      when(() => popularBloc.state).thenReturn(PopularMovieLoading());
      when(() => topRatedBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
      when(() => topRatedBloc.state).thenReturn(TopRatedMovieLoading());

      await tester.pumpWidget(
        _makeTestableWidget(HomeMoviePage()),
      );

      final progressFinder = find.byType(CircularProgressIndicator);

      expect(progressFinder, findsWidgets);
    });

    testWidgets('Page should display when data is loaded',
        (WidgetTester tester) async {
      when(() => nowPlayingBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingMovieLoading()));
      when(() => nowPlayingBloc.state).thenReturn(NowPlayingMovieLoading());
      when(() => nowPlayingBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingMovieHasData(<Movie>[])));
      when(() => nowPlayingBloc.state)
          .thenReturn(NowPlayingMovieHasData(<Movie>[]));
      when(() => popularBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieHasData(<Movie>[])));
      when(() => popularBloc.state).thenReturn(PopularMovieHasData(<Movie>[]));
      when(() => topRatedBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieHasData(<Movie>[])));
      when(() => topRatedBloc.state)
          .thenReturn(TopRatedMovieHasData(<Movie>[]));
      when(() => popularBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieLoading()));
      when(() => popularBloc.state).thenReturn(PopularMovieLoading());
      when(() => topRatedBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
      when(() => topRatedBloc.state).thenReturn(TopRatedMovieLoading());

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      final progressFinder = find.byType(ListView);

      expect(progressFinder, findsWidgets);
    });

    testWidgets('Page should display when data is loaded with data',
        (WidgetTester tester) async {
      when(() => nowPlayingBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingMovieLoading()));
      when(() => nowPlayingBloc.state).thenReturn(NowPlayingMovieLoading());
      when(() => nowPlayingBloc.stream).thenAnswer(
          (_) => Stream.value(NowPlayingMovieHasData(<Movie>[tMovieModel])));
      when(() => nowPlayingBloc.state)
          .thenReturn(NowPlayingMovieHasData(<Movie>[tMovieModel]));
      when(() => popularBloc.stream).thenAnswer(
          (_) => Stream.value(PopularMovieHasData(<Movie>[tMovieModel])));
      when(() => popularBloc.state)
          .thenReturn(PopularMovieHasData(<Movie>[tMovieModel]));
      when(() => topRatedBloc.stream).thenAnswer(
          (_) => Stream.value(TopRatedMovieHasData(<Movie>[tMovieModel])));
      when(() => topRatedBloc.state)
          .thenReturn(TopRatedMovieHasData(<Movie>[tMovieModel]));
      when(() => popularBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieLoading()));
      when(() => popularBloc.state).thenReturn(PopularMovieLoading());
      when(() => topRatedBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
      when(() => topRatedBloc.state).thenReturn(TopRatedMovieLoading());

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      final progressFinder = find.byType(MovieList);

      expect(progressFinder, findsWidgets);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => nowPlayingBloc.stream).thenAnswer(
          (_) => Stream.value(NowPlayingMovieError("Error Massage")));
      when(() => nowPlayingBloc.state)
          .thenReturn(NowPlayingMovieError("Error Massage"));
      when(() => popularBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieError("Error Massage")));
      when(() => popularBloc.state)
          .thenReturn(PopularMovieError("Error Massage"));
      when(() => topRatedBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieError("Error Massage")));
      when(() => topRatedBloc.state)
          .thenReturn(TopRatedMovieError("Error Massage"));

      final textFinder = find.byKey(Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(HomeMoviePage()));

      expect(textFinder, findsWidgets);
    });
  });
}
