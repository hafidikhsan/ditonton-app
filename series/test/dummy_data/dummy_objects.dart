import 'package:series/domain/entities/episodes.dart';
import 'package:series/domain/entities/genre.dart';
import 'package:series/domain/entities/series_detail.dart';
import 'package:watchlist/data/models/database_model.dart';

const testSeriesTable = DatabaseModel(
  id: 1,
  title: 'title',
  posterPath: 'posterPath',
  overview: 'overview',
  isMovie: 0,
);
final testSeriesMap = {
  'id': 1,
  'overview': 'overview',
  'posterPath': 'posterPath',
  'title': 'title',
  'isMovie': 0,
};

final testSeriesDetail = SeriesDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  overview: 'overview',
  posterPath: 'posterPath',
  voteAverage: 1,
  voteCount: 1,
  firstAir: '2022-04-08',
  name: 'title',
  originalName: 'Original Name',
  popularity: 1,
  seasons: [],
);

final testEpisode = Episodes(
  airDate: 'airDate',
  episodeNumber: 1,
  id: 1,
  name: 'name',
  overview: 'overview',
  seasonNumber: 1,
  stillPath: 'stillPath',
  voteAverage: 1,
  voteCount: 1,
);
