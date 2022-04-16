import 'package:flutter_test/flutter_test.dart';
import 'package:series/data/models/genre_model.dart';
import 'package:series/domain/entities/genre.dart';

void main() {
  const tGenreModel = GenreModel(
    id: 1,
    name: 'Action',
  );

  const tGenre = Genre(
    id: 1,
    name: 'Action',
  );

  test('should be a subclass of Genre entity', () async {
    final result = tGenreModel.toEntity();
    expect(result, tGenre);
  });

  group('fromJson', () {
    test('should return a valid model from JSON', () async {
      // arrange
      final jsonMap = {
        "id": 1,
        "name": "Action",
      };
      // act
      final result = GenreModel.fromJson(jsonMap);
      // assert
      expect(result, tGenreModel);
    });
  });

  group('toJson', () {
    test('should return a JSON map containing proper data', () async {
      // arrange

      // act
      final result = tGenreModel.toJson();
      // assert
      final jsonMap = {
        "id": 1,
        "name": "Action",
      };
      expect(result, jsonMap);
    });
  });
}
