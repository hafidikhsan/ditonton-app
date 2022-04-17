import 'package:flutter_test/flutter_test.dart';
import 'package:movie/presentation/bloc/search_movie_bloc.dart';

void main() {
  group('SearchMovieEvent', () {
    group('Load', () {
      test('Load Movie data', () {
        const tQuery = "moon";
        expect(
          const OnQueryChanged(tQuery),
          const OnQueryChanged(tQuery),
        );
      });
      test('Load Movie', () {
        expect(
          const SearchMovieEvent(),
          const SearchMovieEvent(),
        );
      });
    });
  });
}
