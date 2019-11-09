import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_watchlists/data/api/api_tmdb.dart';
import 'package:movie_watchlists/models/cast.dart';
import 'package:movie_watchlists/models/genre.dart';
import 'package:movie_watchlists/models/movie.dart';
import 'package:movie_watchlists/models/movie_details.dart';
import 'package:movie_watchlists/models/movie_selection.dart';
import 'package:movie_watchlists/shared/result.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

void main() {

  test("request movies json via HTTPS", () async {
    final client = Client();
    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: client,
      userConfig: config
    );

    final Result<List<Movie>, Exception> result = await api.movies(MovieSelection.UPCOMING);

    expect(result.result, isNotNull);
  });

  test("request genre json via HTTPS", () async {
    final client = Client();
    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: client,
      userConfig: config
    );

    final Result<List<Genre>, Exception> result = await api.genres();

    expect(result.result, isNotNull);
  });

  test("request details json via HTTPS", () async {
    final client = Client();
    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: client,
      userConfig: config
    );

    final Result<MovieDetails, Exception> result = await api.details(299534);

    expect(result.result, isNotNull);
  });

  test("request cast json via HTTPS", () async {
    final client = Client();
    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: client,
      userConfig: config
    );

    final Result<List<Cast>, Exception> result = await api.cast(420818);

    expect(result.result, isNotNull);
  });

  test("verify that mock movies request contains req params", () async {
    final mockClient = MockClient((req) async {
      final params = req.url.queryParameters;

      expect(params, isNotEmpty);
      expect(params, contains("api_key"));
      expect(params["api_key"], isNotEmpty);

      expect(params, contains("include_adult"));
      expect(params["include_adult"], isNotEmpty);

      return Response("", 200); // we don't care about the response in this test
    });

    final config = MockTmdbConfig();
    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );
    await api.movies(MovieSelection.UPCOMING);
  });

  test("verify that genres request contains req params", () async {
    final mockClient = MockClient((req) async {
      final params = req.url.queryParameters;

      expect(params, isNotEmpty);
      expect(params, contains("api_key"));
      expect(params["api_key"], isNotEmpty);

      expect(params, contains("include_adult"));
      expect(params["include_adult"], isNotEmpty);

      return Response("", 200); // we don't care about the response in this test
    });

    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );
    await api.genres();
  });

  test("verify that details request contains req params", () async {
    final mockClient = MockClient((req) async {
      final params = req.url.queryParameters;

      expect(params, isNotEmpty);
      expect(params, contains("api_key"));
      expect(params["api_key"], isNotEmpty);

      expect(params, contains("include_adult"));
      expect(params["include_adult"], isNotEmpty);

      return Response("", 200); // we don't care about the response in this test
    });

    final config = MockTmdbConfig();
    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );
    await api.details(0);
  });

  test("verify that cast request contains req params", () async {
    final mockClient = MockClient((req) async {
      final params = req.url.queryParameters;

      expect(params, isNotEmpty);
      expect(params, contains("api_key"));
      expect(params["api_key"], isNotEmpty);

      expect(params, contains("include_adult"));
      expect(params["include_adult"], isNotEmpty);

      return Response("", 200); // we don't care about the response in this test
    });

    final config = MockTmdbConfig();
    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );
    await api.cast(123456789);
  });

  test("verify that details request contains movie id", () async {
    final mockClient = MockClient((req) async {
      final url = req.url;

      expect(url.path, contains("1234567890"));

      return Response("", 200); // we don't care about the response in this test
    });

    final config = MockTmdbConfig();
    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );
    await api.details(1234567890);
  });

  test("verify that mock movies request succeeds with status code of 200", () async {
    final json = await readStringFromFile(MOVIES_JSON_PATH);

    final mockClient = MockClient((req) async {
      return Response(json, 200);
    });

    final config = MockTmdbConfig();
    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );

    final Result<List<Movie>, Exception> result = await api.movies(MovieSelection.UPCOMING);

    expect(result.result, isNotNull);
  });

  test("verify that mock genres request succeeds with status code of 200", () async {
    final json = await readStringFromFile(GENRE_JSON_PATH);

    final mockClient = MockClient((req) async {
      return Response(json, 200);
    });

    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );

    final result = await api.genres();

    expect(result.result, isNotNull);
  });

  test("verify that mock details request succeeds with status code of 200", () async {
    final json = await readStringFromFile(MOVIE_DETAILS_JSON_PATH);

    final mockClient = MockClient((req) async {
      return Response(json, 200);
    });

    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );

    final result = await api.details(1234);

    expect(result.result, isNotNull);
  });

  test("verify that mock cast request succeeds with status code of 200", () async {
    final json = await readStringFromFile(CAST_JSON_PATH);

    final mockClient = MockClient((req) async {
      return Response(json, 200);
    });

    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );

    final result = await api.cast(1234);

    expect(result.result, isNotNull);
  });

  test("verify that mock movies request fails with status code of != 200", () async {
    final mockClient = MockClient((req) async {
      return Response("", 400);
    });

    final config = MockTmdbConfig();
    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );

    final result = await api.movies(MovieSelection.UPCOMING);

    expect(result.exception, isNotNull);
  });

  test("verify that mock genres request fails with status code of != 200", () async {
    final mockClient = MockClient((req) async {
      return Response("", 400);
    });

    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );

    final result = await api.genres();

    expect(result.exception, isNotNull);
  });

  test("verify that mock genres request fails with status code of != 200", () async {
    final mockClient = MockClient((req) async {
      return Response("", 400);
    });

    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );

    final result = await api.details(1234);

    expect(result.exception, isNotNull);
  });

  test("verify that mock cast request fails with status code of != 200", () async {
    final mockClient = MockClient((req) async {
      return Response("", 400);
    });

    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );

    final result = await api.cast(1234);

    expect(result.exception, isNotNull);
  });

  test('verify that popular request url contains popular', () async {
    final mockClient = MockClient((req) async {
      final url = req.url;

      expect(url.toString(), contains("popular"));

      return Response("", 200); // we don't care about the response in this test
    });

    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );
    await api.movies(MovieSelection.POPULAR);
  });

  test('verify that request contains upcoming sort param', () async {
    final mockClient = MockClient((req) async {
      final url = req.url;

      expect(url.toString(), contains("upcoming"));

      return Response("", 200); // we don't care about the response in this test
    });

    final config = MockTmdbConfig();
    when(config.adult).thenReturn(false);

    final api = ApiTmdb.create(
      client: mockClient,
      userConfig: config
    );
    await api.movies(MovieSelection.UPCOMING);
  });

}