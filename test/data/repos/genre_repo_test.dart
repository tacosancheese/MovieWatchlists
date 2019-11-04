import 'package:mockito/mockito.dart';
import 'package:movie_watchlists/data/repos/genre_repository.dart';
import 'package:movie_watchlists/models/genre.dart';
import 'package:movie_watchlists/shared/result.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

main() async {

  final json = await readJsonStringFromFile(GENRE_JSON_PATH);
  final items = Genre.fromJsonResponse(json);

  test('loading genres from the API caches the result', () async {
    final mockApi = MockApi();
    final repo = GenreRepository(
      api: mockApi
    );

    final Result<List<Genre>, Exception> result = Result.success(items);
    when(mockApi.genres())
      .thenAnswer((_) => Future.value(result));

    // first request
    final response1 = await repo.all();

    expect(response1.result, isNotEmpty);
    verify(mockApi.genres()).called(1);
    verifyNoMoreInteractions(mockApi);

    // verify mock api is not called
    final response2 = await repo.all();
    expect(response2.result, isNotEmpty);
  });
}