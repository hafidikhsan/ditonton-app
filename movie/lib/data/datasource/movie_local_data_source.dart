import 'package:common/common.dart';
import 'package:watchlist/watchlist.dart';

abstract class MovieLocalDataSource {
  Future<String> insertWatchlist(DatabaseModel movie);
  Future<String> removeWatchlist(DatabaseModel movie);
  Future<DatabaseModel?> getMovieById(int id);
  Future<List<DatabaseModel>> getWatchlist();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final DatabaseHelper databaseHelper;

  MovieLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(DatabaseModel movie) async {
    try {
      await databaseHelper.insertWatchlist(movie);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(DatabaseModel movie) async {
    try {
      await databaseHelper.removeWatchlist(movie);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<DatabaseModel?> getMovieById(int id) async {
    final result = await databaseHelper.getById(id);

    if (result != null) {
      return DatabaseModel.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<DatabaseModel>> getWatchlist() async {
    final result = await databaseHelper.getWatchlist();

    return result.map((data) => DatabaseModel.fromMap(data)).toList();
  }
}
