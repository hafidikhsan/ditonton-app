import 'package:equatable/equatable.dart';
import 'package:series/domain/entities/season.dart';

class Season extends Equatable {
  const Season({
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

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        episodeCount: json["episode_count"],
        id: json["id"],
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "episode_count": episodeCount,
        "id": id,
        "name": name,
        "overview": overview,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };

  Seasons toEntity() {
    return Seasons(
      id: id,
      episodeCount: episodeCount,
      name: name,
      overview: overview,
      posterPath: posterPath,
      seasonNumber: seasonNumber,
    );
  }

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
