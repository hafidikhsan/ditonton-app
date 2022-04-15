// import 'package:ditonton/common/constants.dart';
import 'package:common/common.dart';
// import 'package:ditonton/presentation/bloc/now_playing_movie_bloc.dart';
// import 'package:ditonton/presentation/bloc/popular_movie_bloc.dart';
// import 'package:ditonton/presentation/bloc/top_rated_movie_bloc.dart';
// import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:about/about.dart';
// import 'package:common/common.dart';
// import 'package:ditonton/presentation/pages/home_series_page.dart';
// import 'package:ditonton/presentation/pages/popular_movies_page.dart';
// import 'package:ditonton/presentation/pages/search_page.dart';
// import 'package:ditonton/presentation/pages/top_rated_movies_page.dart';
// import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
// import 'package:ditonton/presentation/widgets/movie_poster_list.dart';
// import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/now_playing_movie_bloc.dart';
import 'package:movie/presentation/bloc/popular_movie_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movie_bloc.dart';
import 'package:movie/presentation/pages/popular_movies_page.dart';
import 'package:movie/presentation/pages/top_rated_movies_page.dart';
import 'package:movie/presentation/widgets/movie_poster_list.dart';
import 'package:series/series.dart';
import 'package:watchlist/watchlist.dart';

class HomeMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/home-movie';

  @override
  _HomeMoviePageState createState() => _HomeMoviePageState();
}

class _HomeMoviePageState extends State<HomeMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingMovieBloc>().add(LoadNowPlayingMovie());
      context.read<PopularMovieBloc>().add(LoadPopularMovie());
      context.read<TopRatedMovieBloc>().add(LoadTopRatedMovie());
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
                Navigator.pushNamed(
                  context,
                  WatchlistMoviesPage.ROUTE_NAME,
                );
              },
            ),
            ListTile(
              onTap: () {
                Navigator.pushNamed(
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
              BlocBuilder<NowPlayingMovieBloc, NowPlayingMovieState>(
                builder: (context, data) {
                  if (data is NowPlayingMovieLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data is NowPlayingMovieHasData) {
                    return MovieList(data.result);
                  } else if (data is NowPlayingMovieError) {
                    return Center(
                      key: Key('error_message'),
                      child: Text(data.message),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SubHeading(
                title: 'Popular',
                onTap: () => Navigator.pushNamed(
                  context,
                  PopularMoviesPage.ROUTE_NAME,
                ),
              ),
              BlocBuilder<PopularMovieBloc, PopularMovieState>(
                builder: (context, data) {
                  if (data is PopularMovieLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data is PopularMovieHasData) {
                    return MovieList(data.result);
                  } else if (data is PopularMovieError) {
                    return Center(
                      key: Key('error_message'),
                      child: Text(data.message),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SubHeading(
                title: 'Top Rated',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedMoviesPage.ROUTE_NAME,
                ),
              ),
              BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
                builder: (context, data) {
                  if (data is TopRatedMovieLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data is TopRatedMovieHasData) {
                    return MovieList(data.result);
                  } else if (data is TopRatedMovieError) {
                    return Center(
                      key: Key('error_message'),
                      child: Text(data.message),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
