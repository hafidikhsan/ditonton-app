// import 'package:ditonton/common/constants.dart';
import 'package:common/common.dart';
// import 'package:ditonton/presentation/bloc/now_playing_series_bloc.dart';
// import 'package:ditonton/presentation/bloc/popular_series_bloc.dart';
// import 'package:ditonton/presentation/bloc/top_rated_series_bloc_bloc.dart';
// import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:about/about.dart';
import 'package:movie/movie.dart';
import 'package:watchlist/watchlist.dart';
// import 'package:ditonton/presentation/pages/home_movie_page.dart';
// import 'package:ditonton/presentation/pages/popular_series_page.dart';
// import 'package:ditonton/presentation/pages/search_page.dart';
// import 'package:ditonton/presentation/pages/top_rated_series_page.dart';
// import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
// import 'package:ditonton/presentation/widgets/series_poster_list.dart';
// import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:series/presentation/bloc/now_playing_series_bloc.dart';
import 'package:series/presentation/bloc/popular_series_bloc.dart';
import 'package:series/presentation/bloc/top_rated_series_bloc_bloc.dart';
import 'package:series/presentation/pages/popular_series_page.dart';
import 'package:series/presentation/pages/top_rated_series_page.dart';
import 'package:series/presentation/widgets/series_poster_list.dart';

class HomeSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-series';

  @override
  State<HomeSeriesPage> createState() => _HomeSeriesPageState();
}

class _HomeSeriesPageState extends State<HomeSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<NowPlayingSeriesBloc>().add(LoadNowPlayingSeries());
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
                Navigator.pop(context);
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
        title: Text('Series'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                SearchPage.ROUTE_NAME,
                arguments: false,
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
              BlocBuilder<NowPlayingSeriesBloc, NowPlayingSeriesState>(
                builder: (context, data) {
                  if (data is NowPlayingSeriesLoading) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (data is NowPlayingSeriesHasData) {
                    return SeriesList(data.result);
                  } else if (data is NowPlayingSeriesError) {
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
                title: 'Top Rated',
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
