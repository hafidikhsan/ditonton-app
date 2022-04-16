import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:movie/movie.dart';
import 'package:series/series.dart';
import 'package:watchlist/data/datasource/database_helper.dart';

@GenerateMocks([
  DatabaseHelper,
  MovieRepository,
  SeriesRepository,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
