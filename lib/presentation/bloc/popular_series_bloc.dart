import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_popular_series.dart';
import 'package:equatable/equatable.dart';

part 'popular_series_event.dart';
part 'popular_series_state.dart';

class PopularSeriesBloc extends Bloc<PopularSeriesEvent, PopularSeriesState> {
  final GetPopularSeries _getPopularSeries;

  PopularSeriesBloc(this._getPopularSeries) : super(PopularSeriesEmpty()) {
    on<LoadPopularSeries>((event, emit) async {
      emit(PopularSeriesLoading());
      final result = await _getPopularSeries.execute();

      result.fold(
        (failure) {
          emit(PopularSeriesError(failure.message));
        },
        (data) {
          emit(PopularSeriesHasData(data));
        },
      );
    });
  }
}
