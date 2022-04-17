part of 'search_series_bloc.dart';

class SearchSeriesEvent extends Equatable {
  const SearchSeriesEvent();

  @override
  List<Object> get props => [];
}

class OnSeriesQueryChanged extends SearchSeriesEvent {
  final String query;

  const OnSeriesQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
