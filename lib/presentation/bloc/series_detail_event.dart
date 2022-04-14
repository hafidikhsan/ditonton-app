part of 'series_detail_bloc.dart';

abstract class SeriesDetailEvent extends Equatable {
  const SeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class OnSeriesDetail extends SeriesDetailEvent {
  final int id;

  OnSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class OnSeasonValue extends SeriesDetailEvent {
  final int season;
  final int id;

  OnSeasonValue(this.season, this.id);

  @override
  List<Object> get props => [season, id];
}

class OnSeriesEpisode extends SeriesDetailEvent {
  final int id;
  final int season;

  OnSeriesEpisode(this.id, this.season);

  @override
  List<Object> get props => [id, season];
}

class OnLoadWatchlistStatus extends SeriesDetailEvent {
  final int id;

  OnLoadWatchlistStatus(this.id);

  @override
  List<Object> get props => [id];
}

class OnAddDatabase extends SeriesDetailEvent {
  final SeriesDetail series;

  OnAddDatabase(this.series);

  @override
  List<Object> get props => [series];
}

class OnRemoveDatabase extends SeriesDetailEvent {
  final SeriesDetail series;

  OnRemoveDatabase(this.series);

  @override
  List<Object> get props => [series];
}
