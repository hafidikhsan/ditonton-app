import 'package:equatable/equatable.dart';

class Series extends Equatable {
  Series({
    required this.backdropPath,
    required this.firstAir,
    required this.genreIds,
    required this.id,
    required this.name,
    required this.originalName,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.voteAverage,
    required this.voteCount,
  });

  String? backdropPath;
  String? firstAir;
  List<int>? genreIds;
  int? id;
  String? name;
  String? originalName;
  String? overview;
  double? popularity;
  String? posterPath;
  double? voteAverage;
  int? voteCount;

  @override
  List<Object?> get props => [
        backdropPath,
        firstAir,
        genreIds,
        id,
        name,
        originalName,
        overview,
        popularity,
        posterPath,
        voteAverage,
        voteCount,
      ];
}
