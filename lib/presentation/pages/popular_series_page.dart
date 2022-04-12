import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/bloc/popular_series_bloc.dart';
import 'package:ditonton/presentation/provider/popular_series_notifier.dart';
import 'package:ditonton/presentation/widgets/series_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class PopularSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-series';

  @override
  State<PopularSeriesPage> createState() => _PopularSeriesPageState();
}

class _PopularSeriesPageState extends State<PopularSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<PopularSeriesBloc>().add(LoadPopularSeries()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularSeriesBloc, PopularSeriesState>(
          builder: (context, data) {
            if (data is PopularSeriesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (data is PopularSeriesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = data.result[index];
                  return SeriesCard(movie);
                },
                itemCount: data.result.length,
              );
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
      ),
    );
  }
}
