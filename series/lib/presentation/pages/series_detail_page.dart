import 'package:cached_network_image/cached_network_image.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:series/domain/entities/episodes.dart';
import 'package:series/domain/entities/genre.dart';
import 'package:series/domain/entities/series.dart';
import 'package:series/domain/entities/series_detail.dart';
import 'package:series/presentation/bloc/series_detail_bloc.dart';

class SeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-series';

  final int id;
  const SeriesDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<SeriesDetailPage> createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<SeriesDetailBloc>().add(OnSeriesDetail(widget.id));
      context.read<SeriesDetailBloc>().add(OnLoadWatchlistStatus(widget.id));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SeriesDetailBloc, SeriesDetailState>(
        builder: (context, data) {
          if (data.resultSeriesState == RequestState.Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (data.resultSeriesState == RequestState.Loaded) {
            final series = data.resultSeries;
            return SafeArea(
              child: DetailContent(
                series!,
                data.recomment,
                data.episode,
                data.isAdd,
                widget.id,
              ),
            );
          } else if (data.resultSeriesState == RequestState.Error) {
            return Center(
              key: const Key('error_message'),
              child: Text(
                data.message,
                style: kHeading6,
              ),
            );
          } else {
            return Center(
              child: Text(
                'Page Not Found',
                style: kHeading6,
              ),
            );
          }
        },
      ),
    );
  }
}

class DetailContent extends StatelessWidget {
  final SeriesDetail series;
  final List<Series> recommendations;
  final List<Episodes> episodes;
  final bool isAddedWatchlist;
  final int id;

  const DetailContent(this.series, this.recommendations, this.episodes,
      this.isAddedWatchlist, this.id,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${series.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: kRichBlack,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 16),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              series.name,
                              style: kHeading5,
                            ),
                            BlocListener<SeriesDetailBloc, SeriesDetailState>(
                              listener: (context, state) {
                                if (state.messageWatchlist ==
                                        SeriesDetailState
                                            .watchlistAddSuccessMessage ||
                                    state.messageWatchlist ==
                                        SeriesDetailState
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(state.messageWatchlist),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(state.messageWatchlist),
                                      );
                                    },
                                  );
                                }
                              },
                              listenWhen: (previous, current) {
                                final checkMassage =
                                    previous.messageWatchlist !=
                                            current.messageWatchlist &&
                                        previous.messageWatchlist != '';
                                return checkMassage;
                              },
                              child: ElevatedButton(
                                onPressed: () async {
                                  if (!isAddedWatchlist) {
                                    context
                                        .read<SeriesDetailBloc>()
                                        .add(OnAddDatabase(series));
                                  } else {
                                    context
                                        .read<SeriesDetailBloc>()
                                        .add(OnRemoveDatabase(series));
                                  }
                                },
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    isAddedWatchlist
                                        ? const Icon(Icons.check)
                                        : const Icon(Icons.add),
                                    const Text('Watchlist'),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              _showGenres(series.genres),
                            ),
                            Row(
                              children: [
                                RatingBarIndicator(
                                  rating: series.voteAverage / 2,
                                  itemCount: 5,
                                  itemBuilder: (context, index) => const Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${series.voteAverage}')
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              series.overview,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            BlocBuilder<SeriesDetailBloc, SeriesDetailState>(
                              builder: (context, data) {
                                if (data.recommentState ==
                                    RequestState.Loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.recommentState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                } else if (data.recommentState ==
                                    RequestState.Loaded) {
                                  return SizedBox(
                                    height: (recommendations.isEmpty) ? 0 : 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final serie = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                SeriesDetailPage.ROUTE_NAME,
                                                arguments: serie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${serie.posterPath}',
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: recommendations.length,
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            BlocBuilder<SeriesDetailBloc, SeriesDetailState>(
                              builder: (context, data) {
                                return SizedBox(
                                  width: 130,
                                  child: DropdownButton(
                                    value: data.seasonValue,
                                    style: const TextStyle(color: Colors.white),
                                    elevation: 16,
                                    items: data.season
                                        .map<DropdownMenuItem<int>>(
                                            (int value) {
                                      return DropdownMenuItem<int>(
                                        value: value,
                                        child: Text("Season $value"),
                                      );
                                    }).toList(),
                                    isExpanded: true,
                                    onChanged: (final int? newValue) {
                                      context
                                          .read<SeriesDetailBloc>()
                                          .add(OnSeasonValue(
                                            newValue!,
                                            series.id,
                                          ));
                                    },
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Episodes',
                              style: kHeading6,
                            ),
                            BlocBuilder<SeriesDetailBloc, SeriesDetailState>(
                              builder: (context, data) {
                                if (data.episodeState == RequestState.Loading) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.episodeState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                } else if (data.episodeState ==
                                    RequestState.Loaded) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      final episode = episodes[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0,
                                          vertical: 10.0,
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: ClipRRect(
                                                child: (episode.stillPath ==
                                                        null)
                                                    ? Center(
                                                        child: Container(
                                                          width: 220,
                                                          height: 70,
                                                          color: Colors.grey,
                                                          child: const Icon(
                                                            Icons.error,
                                                          ),
                                                        ),
                                                      )
                                                    : CachedNetworkImage(
                                                        imageUrl:
                                                            '$BASE_IMAGE_URL${episode.stillPath}',
                                                        width: 220,
                                                        placeholder:
                                                            (context, url) =>
                                                                const Center(
                                                          child:
                                                              CircularProgressIndicator(),
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Center(
                                                          child: Container(
                                                            width: 220,
                                                            height: 70,
                                                            color: Colors.grey,
                                                            child: const Icon(
                                                              Icons.error,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(8),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 2,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 10.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        episode.name,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: kSubtitle,
                                                      ),
                                                      Text(
                                                        episode.overview,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: kBodyText,
                                                      ),
                                                    ],
                                                  ),
                                                )),
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: episodes.length,
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
                    Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        color: Colors.white,
                        height: 4,
                        width: 48,
                      ),
                    ),
                  ],
                ),
              );
            },
            minChildSize: 0.25,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: kRichBlack,
            foregroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        )
      ],
    );
  }
}

String _showGenres(List<Genre> genres) {
  String result = '';
  for (var genre in genres) {
    result += genre.name + ', ';
  }

  if (result.isEmpty) {
    return result;
  }

  return result.substring(0, result.length - 2);
}
