import 'package:ditonton/data/models/episodes_model.dart';
import 'package:equatable/equatable.dart';

class EpisodesRespons extends Equatable {
  EpisodesRespons({
    required this.id,
    required this.episodes,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.seasonNumber,
  });

  final List<Episode> episodes;
  final String name;
  final String overview;
  final int id;
  final String? posterPath;
  final int seasonNumber;

  factory EpisodesRespons.fromJson(Map<String, dynamic> json) =>
      EpisodesRespons(
        id: json["id"],
        episodes: List<Episode>.from(
            json["episodes"].map((x) => Episode.fromJson(x))),
        name: json["name"],
        overview: json["overview"],
        posterPath: json["poster_path"],
        seasonNumber: json["season_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "episodes": List<dynamic>.from(episodes.map((x) => x.toJson())),
        "name": name,
        "overview": overview,
        "poster_path": posterPath,
        "season_number": seasonNumber,
      };

  @override
  List<Object?> get props => [
        id,
        episodes,
        name,
        overview,
        posterPath,
        seasonNumber,
      ];
}
