import 'package:bloc/bloc.dart';
// import 'package:ditonton/common/state_enum.dart';
import 'package:common/common.dart';
// import 'package:ditonton/domain/entities/movie.dart';
// import 'package:ditonton/domain/entities/movie_detail.dart';
// import 'package:ditonton/domain/usecases/get_movie_detail.dart';
// import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
// import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
// import 'package:ditonton/domain/usecases/remove_watchlist.dart';
// import 'package:ditonton/domain/usecases/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:movie/domain/entities/movie.dart';
import 'package:movie/domain/entities/movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:movie/domain/usecases/get_movie_recommendations.dart';
import 'package:movie/domain/usecases/get_watchlist_status.dart';
import 'package:watchlist/watchlist.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc(
    this.getMovieDetail,
    this.getMovieRecommendations,
    this.getWatchListStatus,
    this.saveWatchlist,
    this.removeWatchlist,
  ) : super(MovieDetailInitial()) {
    on<OnMovieDetail>(
      ((event, emit) async {
        final id = event.id;

        emit(state.copyWith(
          resultMovieState: RequestState.Loading,
          recommentState: RequestState.Loading,
        ));

        final detailResult = await getMovieDetail.execute(id);
        final recommendationResult = await getMovieRecommendations.execute(id);

        detailResult.fold((failure) {
          emit(state.copyWith(
            resultMovieState: RequestState.Error,
            message: failure.message,
          ));
        }, (movie) {
          emit(state.copyWith(
            resultMovieState: RequestState.Loaded,
            resultMovie: movie,
            recommentState: RequestState.Loading,
          ));
          recommendationResult.fold((failure) {
            emit(state.copyWith(
              message: failure.message,
              recommentState: RequestState.Error,
            ));
          }, (recomment) {
            emit(state.copyWith(
              recommentState: RequestState.Loaded,
              recomment: recomment,
            ));
          });
        });
      }),
    );

    on<OnAddDatabase>(
      ((event, emit) async {
        final movie = event.movie;

        final result = await saveWatchlist.execute(movie);

        result.fold((failure) {
          emit(state.copyWith(
            messageWatchlist: failure.message,
          ));
        }, (successMessage) {
          emit(state.copyWith(
            messageWatchlist: successMessage,
          ));
        });

        add(OnLoadWatchlistStatus(event.movie.id));
      }),
    );

    on<OnRemoveDatabase>(
      ((event, emit) async {
        final movie = event.movie;

        final result = await removeWatchlist.execute(movie);

        result.fold((failure) {
          emit(state.copyWith(
            messageWatchlist: failure.message,
          ));
        }, (successMessage) {
          emit(state.copyWith(
            messageWatchlist: successMessage,
          ));
        });

        add(OnLoadWatchlistStatus(event.movie.id));
      }),
    );

    on<OnLoadWatchlistStatus>((event, emit) async {
      final id = event.id;

      final result = await getWatchListStatus.execute(id);

      emit(state.copyWith(
        isAdd: result,
      ));
    });
  }
}
