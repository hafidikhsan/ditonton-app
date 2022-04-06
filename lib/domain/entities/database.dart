import 'package:equatable/equatable.dart';

class Database extends Equatable {
  Database({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
    required this.isMovie,
  });

  final int id;
  final String? title;
  final String? posterPath;
  final String? overview;
  final int isMovie;

  @override
  List<Object?> get props => [
        id,
        title,
        posterPath,
        overview,
        isMovie,
      ];
}
