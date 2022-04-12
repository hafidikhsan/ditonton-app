part of 'top_rated_series_bloc_bloc.dart';

abstract class TopRatedSeriesBlocEvent extends Equatable {
  const TopRatedSeriesBlocEvent();

  @override
  List<Object> get props => [];
}

class LoadTopRatedSeries extends TopRatedSeriesBlocEvent {}
