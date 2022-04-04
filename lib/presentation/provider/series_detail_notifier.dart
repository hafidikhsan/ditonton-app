import 'package:ditonton/domain/entities/series.dart';
import 'package:ditonton/domain/entities/series_detail.dart';
import 'package:ditonton/domain/usecases/get_series_detail.dart';
import 'package:ditonton/domain/usecases/get_series_recomendation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:ditonton/common/state_enum.dart';

class SeriesDetailNotifier extends ChangeNotifier {
  final GetSeriesDetail getSeriesDetail;
  final GetSeriesRecommendations getSeriesRecommendations;

  SeriesDetailNotifier({
    required this.getSeriesDetail,
    required this.getSeriesRecommendations,
  });

  late SeriesDetail _series;
  SeriesDetail get series => _series;

  RequestState _seriesState = RequestState.Empty;
  RequestState get seriesState => _seriesState;

  List<Series> _seriesRecommendations = [];
  List<Series> get seriesRecommendations => _seriesRecommendations;

  RequestState _recommendationState = RequestState.Empty;
  RequestState get recommendationState => _recommendationState;

  String _message = '';
  String get message => _message;

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
        notifyListeners();
        recommendationResult.fold(
          (failure) {
            _recommendationState = RequestState.Error;
            _message = failure.message;
          },
          (movies) {
            _recommendationState = RequestState.Loaded;
            _seriesRecommendations = movies;
          },
        );
        _seriesState = RequestState.Loaded;
        notifyListeners();
      },
    );
  }
}
