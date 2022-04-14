part of 'movie_detail_bloc.dart';

class MovieDetailState extends Equatable {
  final MovieDetail? resultMovie;
  final List<Movie> recomment;
  final bool isAdd;
  final String message;
  final String messageWatchlist;
  final RequestState resultMovieState;
  final RequestState recommentState;

  const MovieDetailState({
    required this.resultMovie,
    required this.recomment,
    required this.isAdd,
    required this.message,
    required this.messageWatchlist,
    required this.resultMovieState,
    required this.recommentState,
  });

  static const watchlistAddSuccessMessage = 'Added to Watchlist';
  static const watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  MovieDetailState copyWith({
    MovieDetail? resultMovie,
    List<Movie>? recomment,
    bool? isAdd,
    String? message,
    String? messageWatchlist,
    RequestState? resultMovieState,
    RequestState? recommentState,
  }) {
    return MovieDetailState(
      resultMovie: resultMovie ?? this.resultMovie,
      recomment: recomment ?? this.recomment,
      isAdd: isAdd ?? this.isAdd,
      message: message ?? this.message,
      messageWatchlist: messageWatchlist ?? this.messageWatchlist,
      resultMovieState: resultMovieState ?? this.resultMovieState,
      recommentState: recommentState ?? this.recommentState,
    );
  }

  @override
  List<Object?> get props => [
        resultMovie,
        recomment,
        isAdd,
        message,
        messageWatchlist,
        resultMovieState,
        recommentState,
        watchlistAddSuccessMessage,
        watchlistRemoveSuccessMessage,
      ];
}

class MovieDetailInitial extends MovieDetailState {
  static bool isAddInit = false;
  static String messageInit = '';
  static String messageWatchlistInit = '';
  static List<Movie> recommentInit = [];
  static RequestState recommentStateInit = RequestState.Empty;
  static RequestState resultMovieStateInit = RequestState.Empty;

  MovieDetailInitial()
      : super(
          resultMovie: null,
          recomment: recommentInit,
          isAdd: isAddInit,
          message: messageInit,
          messageWatchlist: messageWatchlistInit,
          resultMovieState: resultMovieStateInit,
          recommentState: recommentStateInit,
        );
}
