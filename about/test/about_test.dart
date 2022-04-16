import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:about/about.dart';
import 'package:movie/movie.dart';
import 'package:series/series.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MockPopularMovieBloc
    extends MockBloc<PopularMovieEvent, PopularMovieState>
    implements PopularMovieBloc {}

class MockTopRatedMovieBloc
    extends MockBloc<TopRatedMovieEvent, TopRatedMovieState>
    implements TopRatedMovieBloc {}

class MockPopularSeriesBloc
    extends MockBloc<PopularSeriesEvent, PopularSeriesState>
    implements PopularSeriesBloc {}

class MockTopRatedSeriesBlocBloc
    extends MockBloc<TopRatedSeriesBlocEvent, TopRatedSeriesBlocState>
    implements TopRatedSeriesBlocBloc {}

void main() {
  late PopularSeriesBloc popularSeriesBloc;
  late TopRatedSeriesBlocBloc topRatedSeriesBloc;
  late PopularMovieBloc popularMovieBloc;
  late TopRatedMovieBloc topRatedMovieBloc;

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

  testWidgets('Page should display image, text, and icon',
      (WidgetTester tester) async {
    await tester.pumpWidget(_makeTestableWidget(AboutPage()));

    final imageFinder = find.byType(Image);
    final iconFinder = find.byIcon(Icons.arrow_back);
    final textFinder = find.text(
        "Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.");

    expect(imageFinder, findsWidgets);
    expect(iconFinder, findsWidgets);
    expect(textFinder, findsWidgets);
  });
}
