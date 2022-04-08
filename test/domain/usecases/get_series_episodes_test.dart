import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/episodes.dart';
import 'package:ditonton/domain/usecases/get_series_episodes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetSeriesEpisodes usecase;
  late MockSeriesRepository mockSeriesRpository;

  setUp(() {
    mockSeriesRpository = MockSeriesRepository();
    usecase = GetSeriesEpisodes(mockSeriesRpository);
  });

  final tSeries = <Episodes>[];

  group('GetSeriesEpisodes Tests', () {
    group('execute', () {
      test(
          'should get list of Episode from the repository when execute function is called',
          () async {
        // arrange
        when(mockSeriesRpository.getSeriesEpisodes(1, 1))
            .thenAnswer((_) async => Right(tSeries));
        // act
        final result = await usecase.execute(1, 1);
        // assert
        expect(result, Right(tSeries));
      });
    });
  });
}
