part of 'series_detail_bloc.dart';

class SeriesDetailState extends Equatable {
  final SeriesDetail? resultSeries;
  final List<Series> recomment;
  final List<Episodes> episode;
  final List<int> season;
  final int seasonValue;
  final int id;
  final bool isAdd;
  final String message;
  final String messageWatchlist;
  final RequestState resultSeriesState;
  final RequestState recommentState;
  final RequestState episodeState;

  const SeriesDetailState({
    required this.resultSeries,
    required this.recomment,
    required this.episode,
    required this.season,
    required this.seasonValue,
    required this.id,
    required this.isAdd,
    required this.message,
    required this.messageWatchlist,
    required this.resultSeriesState,
    required this.recommentState,
    required this.episodeState,
  });

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  SeriesDetailState copyWith({
    SeriesDetail? resultSeries,
    List<Series>? recomment,
    List<Episodes>? episode,
    List<int>? season,
    int? seasonValue,
    int? id,
    bool? isAdd,
    String? message,
    String? messageWatchlist,
    RequestState? resultSeriesState,
    RequestState? recommentState,
    RequestState? episodeState,
  }) {
    return SeriesDetailState(
      episode: episode ?? this.episode,
      episodeState: episodeState ?? this.episodeState,
      id: id ?? this.id,
      isAdd: isAdd ?? this.isAdd,
      message: message ?? this.message,
      messageWatchlist: messageWatchlist ?? this.messageWatchlist,
      recomment: recomment ?? this.recomment,
      recommentState: recommentState ?? this.recommentState,
      resultSeries: resultSeries ?? this.resultSeries,
      resultSeriesState: resultSeriesState ?? this.resultSeriesState,
      season: season ?? this.season,
      seasonValue: seasonValue ?? this.seasonValue,
    );
  }

  @override
  List<Object?> get props => [
        episode,
        episodeState,
        id,
        isAdd,
        message,
        messageWatchlist,
        recomment,
        recommentState,
        resultSeries,
        resultSeriesState,
        season,
        seasonValue,
      ];
}

class SeriesDetailInitial extends SeriesDetailState {
  static List<Series> recommentInit = [];
  static List<Episodes> episodeInit = [];
  static List<int> seasonInit = [];
  static int seasonValueInit = 1;
  static int idInit = 1;
  static bool isAddInit = false;
  static String messageInit = '';
  static String messageWatchlistInit = '';
  static RequestState resultSeriesStateInit = RequestState.Empty;
  static RequestState recommentStateInit = RequestState.Empty;
  static RequestState episodeStateInit = RequestState.Empty;

  SeriesDetailInitial()
      : super(
          resultSeries: null,
          recomment: recommentInit,
          episode: episodeInit,
          season: seasonInit,
          seasonValue: seasonValueInit,
          id: idInit,
          isAdd: isAddInit,
          message: messageInit,
          messageWatchlist: messageWatchlistInit,
          resultSeriesState: resultSeriesStateInit,
          recommentState: recommentStateInit,
          episodeState: episodeStateInit,
        );
}
