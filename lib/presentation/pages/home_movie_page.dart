import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_series_page.dart';
import 'package:ditonton/presentation/pages/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/movie_list_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_poster_list.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/home-movie';

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<MovieListNotifier>(context, listen: false)
          ..fetchNowPlayingMovies()
          ..fetchPopularMovies()
          ..fetchTopRatedMovies());
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
                Navigator.pushReplacementNamed(
                  context,
                  '/home',
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.movie),
              title: Text('Movies'),
              onTap: () {
                Navigator.pop(context);
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
        title: Text('Movie'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SearchPage.ROUTE_NAME,
                arguments: true,
              );
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Now Playing',
                style: kHeading6,
              ),
              Consumer<MovieListNotifier>(
                builder: (context, data, child) {
                  final state = data.nowPlayingState;
                  return PosterListMovie(
                    data: data.nowPlayingMovies,
                    state: state,
                  );
                },
              ),
              SubHeading(
                title: 'Popular',
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
                title: 'Top Rated',
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
            ],
          ),
        ),
      ),
    );
  }
}
