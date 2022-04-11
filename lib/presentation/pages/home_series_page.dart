import 'package:ditonton/common/constants.dart';
import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/home_movie_page.dart';
import 'package:ditonton/presentation/pages/popular_series_page.dart';
import 'package:ditonton/presentation/pages/search_page.dart';
import 'package:ditonton/presentation/pages/top_rated_series_page.dart';
import 'package:ditonton/presentation/pages/watchlist_movies_page.dart';
import 'package:ditonton/presentation/provider/series_list_notifier.dart';
import 'package:ditonton/presentation/widgets/series_poster_list.dart';
import 'package:ditonton/presentation/widgets/sub_heading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/home-series';

  @override
  State<HomeSeriesPage> createState() => _HomeSeriesPageState();
}

class _HomeSeriesPageState extends State<HomeSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => Provider.of<SeriesListNotifier>(context, listen: false)
          ..fetchNowPlayingSeries()
          ..fetchPopularSeries()
          ..fetchTopRatedSeries());
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
              Consumer<SeriesListNotifier>(
                builder: (context, data, child) {
                  final state = data.nowPlayingState;
                  return PosterListSeries(
                    data: data.nowPlayingSeries,
                    state: state,
                  );
                },
              ),
              SubHeading(
                title: 'Popular',
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
                title: 'Top Rated',
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
