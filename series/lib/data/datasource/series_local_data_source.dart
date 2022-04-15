// import 'package:ditonton/common/exception.dart';
import 'package:common/common.dart';
// import 'package:ditonton/data/datasources/db/database_helper.dart';
// import 'package:ditonton/data/models/database_model.dart';
// import 'package:watchlist/data/models/database_model.dart';
import 'package:watchlist/watchlist.dart';

abstract class SeriesLocalDataSource {
  Future<String> insertWatchlist(DatabaseModel series);
  Future<String> removeWatchlist(DatabaseModel series);
  Future<DatabaseModel?> getSeriesById(int id);
}

class SeriesLocalDataSourceImpl implements SeriesLocalDataSource {
  final DatabaseHelper databaseHelper;

  SeriesLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<String> insertWatchlist(DatabaseModel series) async {
    try {
      await databaseHelper.insertWatchlist(series);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(DatabaseModel series) async {
    try {
      await databaseHelper.removeWatchlist(series);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<DatabaseModel?> getSeriesById(int id) async {
    final result = await databaseHelper.getById(id);

    if (result != null) {
      return DatabaseModel.fromMap(result);
    } else {
      return null;
    }
  }
}
