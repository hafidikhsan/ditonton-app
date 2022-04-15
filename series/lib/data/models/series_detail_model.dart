// import 'package:ditonton/data/models/genre_model.dart';
// import 'package:ditonton/data/models/season_model.dart';
// import 'package:ditonton/domain/entities/series_detail.dart';
import 'package:equatable/equatable.dart';
import 'package:series/data/models/genre_model.dart';
import 'package:series/data/models/season_model.dart';
import 'package:series/domain/entities/series_detail.dart';

class SeriesDetailResponse extends Equatable {
  SeriesDetailResponse({
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
  final List<GenreModel> genres;
  final int id;
  final String name;
  final String originalName;
  final String overview;
  final double popularity;
  final String? posterPath;
  final double voteAverage;
  final int voteCount;
  final List<Season> seasons;

  factory SeriesDetailResponse.fromJson(Map<String, dynamic> json) =>
      SeriesDetailResponse(
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        firstAir: json["first_air_date"],
        genres: List<GenreModel>.from(
            json["genres"].map((x) => GenreModel.fromJson(x))),
        id: json["id"],
        name: json["name"],
        originalName: json["original_name"],
        overview: json["overview"],
        popularity: json["popularity"].toDouble(),
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"].toDouble(),
        voteCount: json["vote_count"],
        seasons:
            List<Season>.from(json["seasons"].map((x) => Season.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "adult": adult,
        "backdrop_path": backdropPath,
        "first_air_date": firstAir,
        "genres": List<dynamic>.from(genres.map((x) => x.toJson())),
        "id": id,
        "name": name,
        "original_name": originalName,
        "overview": overview,
        "popularity": popularity,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "vote_count": voteCount,
        "seasons": List<dynamic>.from(seasons.map((x) => x.toJson())),
      };

  SeriesDetail toEntity() {
    return SeriesDetail(
      adult: this.adult,
      backdropPath: this.backdropPath,
      firstAir: this.firstAir,
      genres: this.genres.map((genre) => genre.toEntity()).toList(),
      id: this.id,
      name: this.name,
      originalName: this.originalName,
      overview: this.overview,
      popularity: this.popularity,
      posterPath: this.posterPath,
      voteAverage: this.voteAverage,
      voteCount: this.voteCount,
      seasons: this.seasons.map((e) => e.seasonNumber).toList(),
    );
  }

  @override
  List<Object?> get props => [
        adult,
        backdropPath,
        firstAir,
        genres,
        id,
        name,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
        seasons,
      ];
}
