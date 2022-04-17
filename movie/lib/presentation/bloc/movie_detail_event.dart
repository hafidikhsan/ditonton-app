part of 'movie_detail_bloc.dart';

class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class OnMovieDetail extends MovieDetailEvent {
  final int id;

  const OnMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class OnLoadWatchlistStatus extends MovieDetailEvent {
  final int id;

  const OnLoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class OnAddDatabase extends MovieDetailEvent {
  final MovieDetail movie;

  const OnAddDatabase(this.movie);

  @override
  List<Object> get props => [movie];
}

class OnRemoveDatabase extends MovieDetailEvent {
  final MovieDetail movie;

  const OnRemoveDatabase(this.movie);

  @override
  List<Object> get props => [movie];
}
