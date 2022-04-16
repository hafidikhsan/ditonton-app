import 'package:equatable/equatable.dart';
import 'package:series/domain/entities/genre.dart';

class SeriesDetail extends Equatable {
  const SeriesDetail({
    required this.adult,
    required this.backdropPath,
    required this.firstAir,
    required this.genres,
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
    required this.seasons,
  });

  final bool adult;
  final String? backdropPath;
  final String firstAir;
  final List<Genre> genres;
  final int id;
  final String name;
  final String originalName;
  final double popularity;
  final String? posterPath;
  final String overview;
  final double voteAverage;
  final int voteCount;
  final List<int> seasons;

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        firstAir,
        genres,
        id,
        name,
        originalName,
        popularity,
        posterPath,
        overview,
        voteAverage,
        voteCount,
        seasons,
      ];
}
