import 'package:bloc/bloc.dart';
// import 'package:ditonton/domain/entities/series.dart';
// import 'package:ditonton/domain/usecases/get_now_playing_series.dart';
import 'package:equatable/equatable.dart';
import 'package:series/domain/entities/series.dart';
import 'package:series/domain/usecase/get_now_playing_series.dart';

part 'now_playing_series_event.dart';
part 'now_playing_series_state.dart';

class NowPlayingSeriesBloc
    extends Bloc<NowPlayingSeriesEvent, NowPlayingSeriesState> {
  final GetNowPlayingSeries _getNowPlayingSeries;

  NowPlayingSeriesBloc(this._getNowPlayingSeries)
      : super(NowPlayingSeriesEmpty()) {
    on<LoadNowPlayingSeries>((event, emit) async {
      emit(NowPlayingSeriesLoading());
      final result = await _getNowPlayingSeries.execute();

      result.fold(
        (failure) {
          emit(NowPlayingSeriesError(failure.message));
        },
        (data) {
          emit(NowPlayingSeriesHasData(data));
        },
      );
    });
  }
}
