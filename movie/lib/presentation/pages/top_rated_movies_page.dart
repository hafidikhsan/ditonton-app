// import 'package:ditonton/presentation/bloc/top_rated_movie_bloc.dart';
// import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie/presentation/bloc/top_rated_movie_bloc.dart';
import 'package:movie/presentation/widgets/movie_card_list.dart';

class TopRatedMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedMoviesPageState createState() => _TopRatedMoviesPageState();
}

class _TopRatedMoviesPageState extends State<TopRatedMoviesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TopRatedMovieBloc>().add(LoadTopRatedMovie()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedMovieBloc, TopRatedMovieState>(
          builder: (context, data) {
            if (data is TopRatedMovieLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data is TopRatedMovieHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.result[index];
                  return MovieCard(movie);
                },
                itemCount: data.result.length,
              );
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
      ),
    );
  }
}