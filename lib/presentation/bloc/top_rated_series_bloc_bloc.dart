import 'package:bloc/bloc.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/usecases/get_top_rated_series.dart';
import 'package:equatable/equatable.dart';

part 'top_rated_series_bloc_event.dart';
part 'top_rated_series_bloc_state.dart';

class TopRatedSeriesBlocBloc
    extends Bloc<TopRatedSeriesBlocEvent, TopRatedSeriesBlocState> {
  final GetTopRatedSeries _getTopRatedSeries;

  TopRatedSeriesBlocBloc(this._getTopRatedSeries)
      : super(TopRatedSeriesEmpty()) {
    on<LoadTopRatedSeries>((event, emit) async {
      emit(TopRatedSeriesLoading());
      final result = await _getTopRatedSeries.execute();

      result.fold(
        (failure) {
          emit(TopRatedSeriesError(failure.message));
        },
        (data) {
          emit(TopRatedSeriesHasData(data));
        },
      );
    });
  }
}
