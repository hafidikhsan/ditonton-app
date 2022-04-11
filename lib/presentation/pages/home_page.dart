import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/home_series_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/popular_series_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/top_rated_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/provider/series_list_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_poster_list.dart';
import 'package:ditonton/presentation/widgets/series_poster_list.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MovieListNotifier>(context, listen: false)
        ..fetchPopularMovies()
        ..fetchTopRatedMovies();
      Provider.of<SeriesListNotifier>(context, listen: false)
        ..fetchPopularSeries()
        ..fetchTopRatedSeries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/circle-g.png'),
              ),
              accountName: Text('Ditonton'),
              accountEmail: Text('ditonton@dicoding.com'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  HomeMoviePage.ROUTE_NAME,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.tv),
              title: Text('Series'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  HomeSeriesPage.ROUTE_NAME,
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.save_alt),
              title: Text('Watchlist'),
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  WatchlistMoviesPage.ROUTE_NAME,
                );
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushReplacementNamed(
                  context,
                  AboutPage.ROUTE_NAME,
                );
              },
              leading: Icon(Icons.info_outline),
              title: Text('About'),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text('Ditonton'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SubHeading(
                title: 'Popular Movie',
                onTap: () => Navigator.pushNamed(
                  context,
                  PopularMoviesPage.ROUTE_NAME,
                ),
              ),
              Consumer<MovieListNotifier>(
                builder: (context, data, child) {
                  final state = data.popularMoviesState;
                  return PosterListMovie(
                    data: data.popularMovies,
                    state: state,
                  );
                },
              ),
              SubHeading(
                title: 'Top Rated Movie',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedMoviesPage.ROUTE_NAME,
                ),
              ),
              Consumer<MovieListNotifier>(
                builder: (context, data, child) {
                  final state = data.topRatedMoviesState;
                  return PosterListMovie(
                    data: data.topRatedMovies,
                    state: state,
                  );
                },
              ),
              SubHeading(
                title: 'Popular Series',
                onTap: () => Navigator.pushNamed(
                  context,
                  PopularSeriesPage.ROUTE_NAME,
                ),
              ),
              Consumer<SeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.popularSeriesState;
                  return PosterListSeries(
                    data: data.popularSeries,
                    state: state,
                  );
                },
              ),
              SubHeading(
                title: 'Top Rated Series',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedSeriesPage.ROUTE_NAME,
                ),
              ),
              Consumer<SeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.topRatedSeriesState;
                  return PosterListSeries(
                    data: data.topRatedSeries,
                    state: state,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
