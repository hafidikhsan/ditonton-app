import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/episodes.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/entities/series_detail.dart';
import 'package:ditonton/presentation/provider/series_detail_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class SeriesDetailPage extends StatefulWidget {
  static const ROUTE_NAME = '/detail-series';

  final int id;
  SeriesDetailPage({required this.id});

  @override
  State<SeriesDetailPage> createState() => _SeriesDetailPageState();
}

class _SeriesDetailPageState extends State<SeriesDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<SeriesDetailNotifier>(context, listen: false)
          .fetchSeriesDetail(widget.id);
      Provider.of<SeriesDetailNotifier>(context, listen: false)
          .loadWatchlistStatus(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<SeriesDetailNotifier>(
        builder: (context, provider, child) {
          if (provider.seriesState == RequestState.Loading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (provider.seriesState == RequestState.Loaded) {
            final series = provider.series;
            return SafeArea(
              child: DetailContent(
                series,
                provider.seriesRecommendations,
                provider.seriesEpisodes,
                provider.isAddedToWatchlist,
                widget.id,
              ),
            );
          } else {
            return Text(provider.message);
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

  DetailContent(this.series, this.recommendations, this.episodes,
      this.isAddedWatchlist, this.id);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: 'https://image.tmdb.org/t/p/w500${series.posterPath}',
          width: screenWidth,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
        Container(
          margin: const EdgeInsets.only(top: 48 + 8),
          child: DraggableScrollableSheet(
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
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
                            ElevatedButton(
                              onPressed: () async {
                                if (!isAddedWatchlist) {
                                  await Provider.of<SeriesDetailNotifier>(
                                    context,
                                    listen: false,
                                  ).addWatchlist(series);
                                } else {
                                  await Provider.of<SeriesDetailNotifier>(
                                    context,
                                    listen: false,
                                  ).removeFromWatchlist(series);
                                }

                                final message =
                                    Provider.of<SeriesDetailNotifier>(
                                  context,
                                  listen: false,
                                ).watchlistMessage;

                                if (message ==
                                        SeriesDetailNotifier
                                            .watchlistAddSuccessMessage ||
                                    message ==
                                        SeriesDetailNotifier
                                            .watchlistRemoveSuccessMessage) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(message),
                                    ),
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        content: Text(message),
                                      );
                                    },
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  isAddedWatchlist
                                      ? Icon(Icons.check)
                                      : Icon(Icons.add),
                                  Text('Watchlist'),
                                ],
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
                                  itemBuilder: (context, index) => Icon(
                                    Icons.star,
                                    color: kMikadoYellow,
                                  ),
                                  itemSize: 24,
                                ),
                                Text('${series.voteAverage}')
                              ],
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Overview',
                              style: kHeading6,
                            ),
                            Text(
                              series.overview,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Recommendations',
                              style: kHeading6,
                            ),
                            Consumer<SeriesDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.recommendationState ==
                                    RequestState.Loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.recommendationState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                } else if (data.recommendationState ==
                                    RequestState.Loaded) {
                                  return Container(
                                    height: (recommendations.isEmpty) ? 0 : 150,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        final movie = recommendations[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushReplacementNamed(
                                                context,
                                                SeriesDetailPage.ROUTE_NAME,
                                                arguments: movie.id,
                                              );
                                            },
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(8),
                                              ),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Icon(Icons.error),
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
                            SizedBox(height: 16),
                            Text(
                              'Seasons',
                              style: kHeading6,
                            ),
                            Consumer<SeriesDetailNotifier>(
                              builder: (context, data, child) {
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
                                      data.selectedSeason = newValue!;
                                    },
                                  ),
                                );
                              },
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Episodes',
                              style: kHeading6,
                            ),
                            Consumer<SeriesDetailNotifier>(
                              builder: (context, data, child) {
                                if (data.episodesState ==
                                    RequestState.Loading) {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else if (data.episodesState ==
                                    RequestState.Error) {
                                  return Text(data.message);
                                } else if (data.episodesState ==
                                    RequestState.Loaded) {
                                  return Container(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
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
                                                child: Container(
                                                  child: ClipRRect(
                                                    child: (episode.stillPath ==
                                                            null)
                                                        ? Center(
                                                            child: Container(
                                                              width: 220,
                                                              height: 70,
                                                              color:
                                                                  Colors.grey,
                                                              child: Icon(
                                                                Icons.error,
                                                              ),
                                                            ),
                                                          )
                                                        : CachedNetworkImage(
                                                            imageUrl:
                                                                '$BASE_IMAGE_URL${episode.stillPath}',
                                                            width: 220,
                                                            placeholder:
                                                                (context,
                                                                        url) =>
                                                                    Center(
                                                              child:
                                                                  CircularProgressIndicator(),
                                                            ),
                                                            errorWidget:
                                                                (context, url,
                                                                        error) =>
                                                                    Center(
                                                              child: Container(
                                                                width: 220,
                                                                height: 70,
                                                                color:
                                                                    Colors.grey,
                                                                child: Icon(
                                                                  Icons.error,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(8),
                                                    ),
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
                                    ),
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
              icon: Icon(Icons.arrow_back),
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
