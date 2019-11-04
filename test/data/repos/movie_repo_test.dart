import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/models/movie_.dart';
import 'package:movie_watchlists/models/movie_details.dart';
import 'package:movie_watchlists/models/movie_selection.dart';
import 'package:movie_watchlists/shared/result.dart';

import '../../test_utils.dart';


main() async {

  test('loading movies from the API caches the result', () async {
    final mockApi = MockApi();
    final repo = MovieRepository(
      api: mockApi
    );

    final json = await readJsonStringFromFile(MOVIES_JSON_PATH);
    final items = Movie_.fromJsonResponse(json);

    final Result<List<Movie_>, Exception> result = Result.success(items);
    when(mockApi.movies(MovieSelection.POPULAR))
      .thenAnswer((_) => Future.value(result));

    when(mockApi.movies(MovieSelection.UPCOMING))
      .thenAnswer((_) => Future.value(result));

    // first request
    final response1 = await repo.all(MovieSelection.POPULAR);

    expect(response1.result, isNotEmpty);
    verify(mockApi.movies(MovieSelection.POPULAR)).called(1);

    // second not cached request
    final response2 = await repo.all(MovieSelection.UPCOMING);

    expect(response2.result, isNotEmpty);
    verify(mockApi.movies(MovieSelection.UPCOMING)).called(1);
    verifyNoMoreInteractions(mockApi);

    // third cached request
    final response3 = await repo.all(MovieSelection.POPULAR);
    expect(response3.result, isNotEmpty);
  });

  test('load movie details', () async {
    final mockApi = MockApi();
    final repo = MovieRepository(
      api: mockApi
    );

    final json = await readJsonStringFromFile(MOVIE_DETAILS_JSON_PATH);
    final item = MovieDetails.fromJson(json);

    final Result<MovieDetails, Exception> result = Result.success(item);
    when(mockApi.details(123))
      .thenAnswer((_) => Future.value(result));

    final response = await repo.get(123);

    expect(response.result, isNotNull);
    verify(mockApi.details(123)).called(1);
    verifyNoMoreInteractions(mockApi);
  });
}