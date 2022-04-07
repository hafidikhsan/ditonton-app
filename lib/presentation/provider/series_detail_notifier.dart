import 'package:ditonton/domain/entities/episodes.dart';
import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/entities/series_detail.dart';
import 'package:ditonton/domain/usecases/get_series_detail.dart';
import 'package:ditonton/domain/usecases/get_series_episodes.dart';
import 'package:ditonton/domain/usecases/get_series_recomendation.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status_series.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_series.dart';
import 'package:ditonton/domain/usecases/save_watchlist_series.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/common/state_enum.dart';

class SeriesDetailNotifier extends ChangeNotifier {
  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetSeriesDetail getSeriesDetail;
  final GetSeriesRecommendations getSeriesRecommendations;
  final GetSeriesEpisodes getSeriesEpisodes;
  final GetWatchListStatusSeries getWatchListStatus;
  final SaveWatchlistSeries saveWatchlist;
  final RemoveWatchlistSeries removeWatchlist;

  SeriesDetailNotifier({
    required this.getSeriesDetail,
    required this.getSeriesRecommendations,
    required this.getSeriesEpisodes,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  });

  late SeriesDetail _series;
  SeriesDetail get series => _series;

  late List<int> _season;
  List<int> get season => _season;

  late int _seasonValue;
  int get seasonValue => _seasonValue;

  late int _id;
  int get id => _id;

  RequestState _seriesState = RequestState.Empty;
  RequestState get seriesState => _seriesState;

  List<Series> _seriesRecommendations = [];
  List<Series> get seriesRecommendations => _seriesRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  List<Episodes> _seriesEpisodes = [];
  List<Episodes> get seriesEpisodes => _seriesEpisodes;

  RequestState _episodesState = RequestState.Empty;
  RequestState get episodesState => _episodesState;

  String _message = '';
  String get message => _message;

  bool _isAddedtoWatchlist = false;
  bool get isAddedToWatchlist => _isAddedtoWatchlist;

  Future<void> fetchSeriesDetail(int id) async {
    _seriesState = RequestState.Loading;
    notifyListeners();
    final detailResult = await getSeriesDetail.execute(id);
    final recommendationResult = await getSeriesRecommendations.execute(id);
    detailResult.fold(
      (failure) {
        _seriesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (series) {
        _recommendationState = RequestState.Loading;
        _series = series;
        _season = series.seasons;
        _seasonValue = _season[0];
        _id = id;
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (movies) {
            _recommendationState = RequestState.Loaded;
            _seriesRecommendations = movies;
            notifyListeners();
            getEpisodes();
          },
        );
        _seriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }

  Future<void> getEpisodes() async {
    _episodesState = RequestState.Loading;
    notifyListeners();
    final episodesResult = await getSeriesEpisodes.execute(_id, _seasonValue);
    episodesResult.fold(
      (failure) {
        _episodesState = RequestState.Error;
        _message = failure.message;
        notifyListeners();
      },
      (movies) {
        _episodesState = RequestState.Loaded;
        _seriesEpisodes = movies;
        notifyListeners();
      },
    );
  }

  set selectedSeason(final int value) {
    this._seasonValue = value;
    getEpisodes();
    notifyListeners();
  }

  String _watchlistMessage = '';
  String get watchlistMessage => _watchlistMessage;

  Future<void> addWatchlist(SeriesDetail movie) async {
    final result = await saveWatchlist.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> removeFromWatchlist(SeriesDetail movie) async {
    final result = await removeWatchlist.execute(movie);

    await result.fold(
      (failure) async {
        _watchlistMessage = failure.message;
      },
      (successMessage) async {
        _watchlistMessage = successMessage;
      },
    );

    await loadWatchlistStatus(movie.id);
  }

  Future<void> loadWatchlistStatus(int id) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedtoWatchlist = result;
    notifyListeners();
  }
}
