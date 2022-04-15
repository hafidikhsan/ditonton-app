import 'package:bloc/bloc.dart';
// import 'package:ditonton/common/state_enum.dart';
import 'package:common/common.dart';
// import 'package:ditonton/domain/entities/episodes.dart';
// import 'package:ditonton/domain/entities/series.dart';
// import 'package:ditonton/domain/entities/series_detail.dart';
// import 'package:ditonton/domain/usecases/get_series_detail.dart';
// import 'package:ditonton/domain/usecases/get_series_episodes.dart';
// import 'package:ditonton/domain/usecases/get_series_recomendation.dart';
// import 'package:ditonton/domain/usecases/get_watchlist_status_series.dart';
// import 'package:ditonton/domain/usecases/remove_watchlist_series.dart';
// import 'package:ditonton/domain/usecases/save_watchlist_series.dart';
import 'package:equatable/equatable.dart';
import 'package:series/domain/entities/episodes.dart';
import 'package:series/domain/entities/series.dart';
import 'package:series/domain/entities/series_detail.dart';
import 'package:series/domain/usecase/get_series_detail.dart';
import 'package:series/domain/usecase/get_series_episodes.dart';
import 'package:series/domain/usecase/get_series_recomendation.dart';
import 'package:series/domain/usecase/get_watchlist_status_series.dart';
import 'package:watchlist/watchlist.dart';

part 'series_detail_event.dart';
part 'series_detail_state.dart';

class SeriesDetailBloc extends Bloc<SeriesDetailEvent, SeriesDetailState> {
  final GetSeriesDetail getSeriesDetail;
  final GetSeriesRecommendations getSeriesRecommendations;
  final GetSeriesEpisodes getSeriesEpisodes;
  final GetWatchListStatusSeries getWatchListStatus;
  final SaveWatchlistSeries saveWatchlist;
  final RemoveWatchlistSeries removeWatchlist;

  SeriesDetailBloc(
    this.getSeriesDetail,
    this.getSeriesRecommendations,
    this.getSeriesEpisodes,
    this.getWatchListStatus,
    this.saveWatchlist,
    this.removeWatchlist,
  ) : super(SeriesDetailInitial()) {
    on<OnSeriesDetail>((event, emit) async {
      final id = event.id;

      emit(state.copyWith(
        resultSeriesState: RequestState.Loading,
        recommentState: RequestState.Loading,
      ));

      final detailResult = await getSeriesDetail.execute(id);
      final recommendationResult = await getSeriesRecommendations.execute(id);

      detailResult.fold((failure) {
        emit(state.copyWith(
          resultSeriesState: RequestState.Error,
          message: failure.message,
        ));
      }, (series) {
        emit(state.copyWith(
          resultSeries: series,
          season: series.seasons,
          seasonValue: series.seasons[0],
          id: id,
        ));
        final seasonValue = series.seasons[0];
        recommendationResult.fold((failure) {
          emit(state.copyWith(
            recommentState: RequestState.Error,
            message: failure.message,
          ));
        }, (recomment) {
          emit(state.copyWith(
            recommentState: RequestState.Loaded,
            recomment: recomment,
          ));

          add(OnSeriesEpisode(id, seasonValue));
        });
        emit(state.copyWith(
          resultSeriesState: RequestState.Loaded,
        ));
      });
    });

    on<OnSeriesEpisode>((event, emit) async {
      final id = event.id;
      final season = event.season;

      emit(state.copyWith(
        episodeState: RequestState.Loading,
      ));

      final episodesResult = await getSeriesEpisodes.execute(id, season);

      episodesResult.fold((failure) {
        emit(state.copyWith(
          episodeState: RequestState.Error,
          message: failure.message,
        ));
      }, (episode) {
        emit(state.copyWith(
          episodeState: RequestState.Loaded,
          episode: episode,
        ));
      });
    });

    on<OnSeasonValue>((event, emit) {
      emit(
        state.copyWith(
          seasonValue: event.season,
        ),
      );
      add(OnSeriesEpisode(event.id, event.season));
    });

    on<OnAddDatabase>(
      ((event, emit) async {
        final movie = event.series;

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

        add(OnLoadWatchlistStatus(event.series.id));
      }),
    );

    on<OnRemoveDatabase>(
      ((event, emit) async {
        final movie = event.series;

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

        add(OnLoadWatchlistStatus(event.series.id));
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
