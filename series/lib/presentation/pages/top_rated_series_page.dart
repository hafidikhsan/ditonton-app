// import 'package:ditonton/presentation/bloc/top_rated_series_bloc_bloc.dart';
// import 'package:ditonton/presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:series/presentation/bloc/top_rated_series_bloc_bloc.dart';
import 'package:series/presentation/widgets/series_card_list.dart';

class TopRatedSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-series';

  @override
  State<TopRatedSeriesPage> createState() => _TopRatedSeriesPageState();
}

class _TopRatedSeriesPageState extends State<TopRatedSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<TopRatedSeriesBlocBloc>().add(LoadTopRatedSeries()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<TopRatedSeriesBlocBloc, TopRatedSeriesBlocState>(
          builder: (context, data) {
            if (data is TopRatedSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data is TopRatedSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final series = data.result[index];
                  return SeriesCard(series);
                },
                itemCount: data.result.length,
              );
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
      ),
    );
  }
}
