part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class OnMovieDetail extends MovieDetailEvent {
  final int id;

  OnMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class OnLoadWatchlistStatus extends MovieDetailEvent {
  final int id;

  OnLoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class OnAddDatabase extends MovieDetailEvent {
  final MovieDetail movie;

  OnAddDatabase(this.movie);

  @override
  List<Object> get props => [movie];
}

class OnRemoveDatabase extends MovieDetailEvent {
  final MovieDetail movie;

  OnRemoveDatabase(this.movie);

  @override
  List<Object> get props => [movie];
}
