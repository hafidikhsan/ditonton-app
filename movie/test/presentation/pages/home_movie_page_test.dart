import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/presentation/bloc/now_playing_movie_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movie_bloc.dart';
import 'package:movie/presentation/pages/home_movie_page.dart';
import 'package:movie/presentation/widgets/movie_poster_list.dart';

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

  const tMovieModel = Movie(
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
        _makeTestableWidget(const HomeMoviePage()),
      );

      final progressFinder = find.byType(CircularProgressIndicator);

      expect(progressFinder, findsWidgets);
    });

    testWidgets('Page should display when data is loaded',
        (WidgetTester tester) async {
      when(() => nowPlayingBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingMovieLoading()));
      when(() => nowPlayingBloc.state).thenReturn(NowPlayingMovieLoading());
      when(() => nowPlayingBloc.stream).thenAnswer(
          (_) => Stream.value(const NowPlayingMovieHasData(<Movie>[])));
      when(() => nowPlayingBloc.state)
          .thenReturn(const NowPlayingMovieHasData(<Movie>[]));
      when(() => popularBloc.stream).thenAnswer(
          (_) => Stream.value(const PopularMovieHasData(<Movie>[])));
      when(() => popularBloc.state)
          .thenReturn(const PopularMovieHasData(<Movie>[]));
      when(() => topRatedBloc.stream).thenAnswer(
          (_) => Stream.value(const TopRatedMovieHasData(<Movie>[])));
      when(() => topRatedBloc.state)
          .thenReturn(const TopRatedMovieHasData(<Movie>[]));
      when(() => popularBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieLoading()));
      when(() => popularBloc.state).thenReturn(PopularMovieLoading());
      when(() => topRatedBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
      when(() => topRatedBloc.state).thenReturn(TopRatedMovieLoading());

      await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

      final progressFinder = find.byType(ListView);

      expect(progressFinder, findsWidgets);
    });

    testWidgets('Page should display when data is loaded with data',
        (WidgetTester tester) async {
      when(() => nowPlayingBloc.stream)
          .thenAnswer((_) => Stream.value(NowPlayingMovieLoading()));
      when(() => nowPlayingBloc.state).thenReturn(NowPlayingMovieLoading());
      when(() => nowPlayingBloc.stream).thenAnswer((_) =>
          Stream.value(const NowPlayingMovieHasData(<Movie>[tMovieModel])));
      when(() => nowPlayingBloc.state)
          .thenReturn(const NowPlayingMovieHasData(<Movie>[tMovieModel]));
      when(() => popularBloc.stream).thenAnswer(
          (_) => Stream.value(const PopularMovieHasData(<Movie>[tMovieModel])));
      when(() => popularBloc.state)
          .thenReturn(const PopularMovieHasData(<Movie>[tMovieModel]));
      when(() => topRatedBloc.stream).thenAnswer((_) =>
          Stream.value(const TopRatedMovieHasData(<Movie>[tMovieModel])));
      when(() => topRatedBloc.state)
          .thenReturn(const TopRatedMovieHasData(<Movie>[tMovieModel]));
      when(() => popularBloc.stream)
          .thenAnswer((_) => Stream.value(PopularMovieLoading()));
      when(() => popularBloc.state).thenReturn(PopularMovieLoading());
      when(() => topRatedBloc.stream)
          .thenAnswer((_) => Stream.value(TopRatedMovieLoading()));
      when(() => topRatedBloc.state).thenReturn(TopRatedMovieLoading());

      await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

      final progressFinder = find.byType(MovieList);

      expect(progressFinder, findsWidgets);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      when(() => nowPlayingBloc.stream).thenAnswer(
          (_) => Stream.value(const NowPlayingMovieError("Error Massage")));
      when(() => nowPlayingBloc.state)
          .thenReturn(const NowPlayingMovieError("Error Massage"));
      when(() => popularBloc.stream).thenAnswer(
          (_) => Stream.value(const PopularMovieError("Error Massage")));
      when(() => popularBloc.state)
          .thenReturn(const PopularMovieError("Error Massage"));
      when(() => topRatedBloc.stream).thenAnswer(
          (_) => Stream.value(const TopRatedMovieError("Error Massage")));
      when(() => topRatedBloc.state)
          .thenReturn(const TopRatedMovieError("Error Massage"));

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const HomeMoviePage()));

      expect(textFinder, findsWidgets);
    });
  });
}
