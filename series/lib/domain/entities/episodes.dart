import 'package:equatable/equatable.dart';

class Episodes extends Equatable {
  Episodes({
    required this.airDate,
    required this.episodeNumber,
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.stillPath,
    required this.voteAverage,
    required this.voteCount,
  });

  final String airDate;
  final int episodeNumber;
  final int id;
  final String name;
  final String overview;
  final int seasonNumber;
  final String? stillPath;
  final double voteAverage;
  final int voteCount;

  @override
  List<Object?> get props => [
        id,
        airDate,
        episodeNumber,
        name,
        overview,
        stillPath,
        seasonNumber,
        voteAverage,
        voteCount,
      ];
}
