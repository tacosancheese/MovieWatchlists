import 'package:mockito/mockito.dart';
import 'package:movie_watchlists/data/repos/cast_repo.dart';
import 'package:movie_watchlists/models/cast.dart';
import 'package:movie_watchlists/shared/result.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

main() {

  test('load cast', () async {
    final mockApi = MockApi();
    final repo = CastRepository(
      api: mockApi
    );

    final json = await readJsonStringFromFile(CAST_JSON_PATH);
    final items = Cast.fromJsonResponse(json);

    final Result<List<Cast>, Exception> result = Result.success(items);
    when(repo.getCast(1234567890))
      .thenAnswer((_) => Future.value(result));

    final response = await repo.getCast(1234567890);

    expect(response.result, isNotEmpty);
    verify(mockApi.cast(1234567890)).called(1);
    verifyNoMoreInteractions(mockApi);
  });
}