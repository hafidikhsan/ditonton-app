import 'package:equatable/equatable.dart';
import 'package:watchlist/domain/entities/database.dart';
import 'package:movie/movie.dart';
import 'package:series/series.dart';

class DatabaseModel extends Equatable {
  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final int isMovie;

  const DatabaseModel({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.isMovie,
  });

  factory DatabaseModel.fromMovieEntity(MovieDetail movie) => DatabaseModel(
        id: movie.id,
        title: movie.title,
        posterPath: movie.posterPath,
        overview: movie.overview,
        isMovie: 1,
      );

  factory DatabaseModel.fromSeriesEntity(SeriesDetail series) => DatabaseModel(
        id: series.id,
        title: series.name,
        posterPath: series.posterPath,
        overview: series.overview,
        isMovie: 0,
      );

  factory DatabaseModel.fromMap(Map<String, dynamic> map) => DatabaseModel(
        id: map['id'],
        title: map['title'],
        posterPath: map['posterPath'],
        overview: map['overview'],
        isMovie: map['isMovie'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'posterPath': posterPath,
        'overview': overview,
        'isMovie': isMovie,
      };

  Database toEntity() {
    return Database(
      id: id,
      overview: overview,
      posterPath: posterPath,
      title: title,
      isMovie: isMovie,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        posterPath,
        overview,
        isMovie,
      ];
}
