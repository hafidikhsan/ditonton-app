// import 'package:ditonton/presentation/bloc/popular_movie_bloc.dart';
// import 'package:ditonton/presentation/bloc/popular_series_bloc.dart';
// import 'package:ditonton/presentation/bloc/top_rated_movie_bloc.dart';
// import 'package:ditonton/presentation/bloc/top_rated_series_bloc_bloc.dart';
// import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:about/about.dart';
import 'package:common/common.dart';
import 'package:series/series.dart';
import 'package:movie/movie.dart';
import 'package:watchlist/watchlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PopularMovieBloc>().add(LoadPopularMovie());
      context.read<TopRatedMovieBloc>().add(LoadTopRatedMovie());
      context.read<PopularSeriesBloc>().add(LoadPopularSeries());
      context.read<TopRatedSeriesBlocBloc>().add(LoadTopRatedSeries());
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
                title: 'Top Rated Movie',
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
              SubHeading(
                title: 'Popular Series',
                onTap: () => Navigator.pushNamed(
                  context,
                  PopularSeriesPage.ROUTE_NAME,
                ),
              ),
              BlocBuilder<PopularSeriesBloc, PopularSeriesState>(
                builder: (context, data) {
                  if (data is PopularSeriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data is PopularSeriesHasData) {
                    return SeriesList(data.result);
                  } else if (data is PopularSeriesError) {
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
                title: 'Top Rated Series',
                onTap: () => Navigator.pushNamed(
                  context,
                  TopRatedSeriesPage.ROUTE_NAME,
                ),
              ),
              BlocBuilder<TopRatedSeriesBlocBloc, TopRatedSeriesBlocState>(
                builder: (context, data) {
                  if (data is TopRatedSeriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data is TopRatedSeriesHasData) {
                    return SeriesList(data.result);
                  } else if (data is TopRatedSeriesError) {
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
