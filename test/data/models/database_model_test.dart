import 'package:ditonton/data/models/database_model.dart';
import 'package:ditonton/domain/entities/database.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tDatabaseModel = DatabaseModel(
    id: 1,
    isMovie: 1,
    overview: 'overview.',
    posterPath: '/path.jpg',
    title: 'title',
  );

  final tDatabase = Database(
    id: 1,
    isMovie: 1,
    overview: 'overview.',
    posterPath: '/path.jpg',
    title: 'title',
  );

  test('should be a subclass of Database entity', () async {
    final result = tDatabaseModel.toEntity();
    expect(result, tDatabase);
  });
}
