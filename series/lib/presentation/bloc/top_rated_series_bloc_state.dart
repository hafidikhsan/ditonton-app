part of 'top_rated_series_bloc_bloc.dart';

abstract class TopRatedSeriesBlocState extends Equatable {
  const TopRatedSeriesBlocState();

  @override
  List<Object> get props => [];
}

class TopRatedSeriesEmpty extends TopRatedSeriesBlocState {}

class TopRatedSeriesLoading extends TopRatedSeriesBlocState {}

class TopRatedSeriesError extends TopRatedSeriesBlocState {
  final String message;

  const TopRatedSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedSeriesHasData extends TopRatedSeriesBlocState {
  final List<Series> result;

  const TopRatedSeriesHasData(this.result);

  @override
  List<Object> get props => [result];
}
