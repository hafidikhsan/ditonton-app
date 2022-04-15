import 'package:equatable/equatable.dart';

class Seasons extends Equatable {
  Seasons({
    required this.episodeCount,
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  final int episodeCount;
  final int id;
  final String name;
  final String overview;
  final String? posterPath;
  final int seasonNumber;

  @override
  List<Object?> get props => [
        id,
        episodeCount,
        name,
        overview,
        posterPath,
        seasonNumber,
      ];
}
