import 'package:flutter_test/flutter_test.dart';
import 'package:series/presentation/bloc/search_series_bloc.dart';

void main() {
  group('SearchSeriesEvent', () {
    group('Load', () {
      test('Load Series', () {
        expect(
          const SearchSeriesEvent(),
          const SearchSeriesEvent(),
        );
      });
      test('Load Series Query', () {
        expect(
          const OnSeriesQueryChanged("moon"),
          const OnSeriesQueryChanged("moon"),
        );
      });
    });
  });
}
