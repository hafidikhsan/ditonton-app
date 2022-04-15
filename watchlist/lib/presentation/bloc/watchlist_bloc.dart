import 'package:bloc/bloc.dart';
// import 'package:ditonton/domain/entities/database.dart';
// import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:watchlist/domain/entities/database.dart';
import 'package:watchlist/domain/usecases/get_watchlist_movies.dart';

part 'watchlist_event.dart';
part 'watchlist_state.dart';

class WatchlistBloc extends Bloc<WatchlistEvent, WatchlistState> {
  final GetWatchlist _getWatchlist;

  WatchlistBloc(this._getWatchlist) : super(WatchlistEmpty()) {
    on<WatchlistEvent>((event, emit) async {
      emit(WatchlistLoading());
      final result = await _getWatchlist.execute();

      result.fold(
        (failure) {
          emit(WatchlistError(failure.message));
        },
        (data) {
          emit(WatchlistHasData(data));
        },
      );
    });
  }
}
