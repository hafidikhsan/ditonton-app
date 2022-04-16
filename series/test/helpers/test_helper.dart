import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:series/data/datasource/series_local_data_source.dart';
import 'package:series/data/datasource/series_remote_data_source.dart';
import 'package:series/domain/repositories/series_repository.dart';
import 'package:watchlist/watchlist.dart';

@GenerateMocks([
  DatabaseHelper,
  SeriesRepository,
  SeriesRemoteDataSource,
  SeriesLocalDataSource,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
