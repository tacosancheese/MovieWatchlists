import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:movie_watchlists/data/api/tmdb_user_config.dart';
import 'package:movie_watchlists/models/cast.dart';
import 'package:movie_watchlists/models/genre.dart';
import 'package:movie_watchlists/models/movie.dart';
import 'package:movie_watchlists/models/movie_details.dart';
import 'package:movie_watchlists/models/movie_selection.dart';
import 'package:movie_watchlists/shared/result.dart';

class ApiTmdb {

  static const String _API_KEY = "3aae9534b7c30ab8175268c95d82ec6f";
  static const String _BASE_URL = "api.themoviedb.org";

  final http.Client _client;
  final TmdbUserConfig _userConfig;

  ApiTmdb._(this._client, this._userConfig);

  ApiTmdb.create({
    @required final http.Client client,
    @required final TmdbUserConfig userConfig
  }) : this._client = client, this._userConfig = userConfig;

  // https://api.themoviedb.org/3/movie/{movie_id}/credits?api_key=<<api_key>>
  Future<Result<List<Cast>, Exception>> cast(final int movieId) async {
    final params = {
      'api_key' : _API_KEY,
      'include_adult' : _userConfig.adult.toString()
    };

    final Uri uri = Uri.https(_BASE_URL, '/3/movie/' + movieId.toString() + "/credits", params);

    final Result<List<Cast>, Exception> Function(Exception e) func =
      (Exception e) { return Result.failure(e); };

    return await _performGetRequest(
      uri: uri,
      onSuccess: (dynamic json) => Result.success(Cast.fromJsonResponse(json)),
      onFailure: (Exception e) => func(e)
    );
  }

  // https://api.themoviedb.org/3/genre/movie/{movieId}/?api_key=<<api_key>>
  Future<Result<MovieDetails, Exception>> details(final int movieId) async {
    final params = {
      'api_key' : _API_KEY,
      'include_adult' : _userConfig.adult.toString()
    };

    final Uri uri = Uri.https(_BASE_URL, '/3/movie/' + movieId.toString(), params);

    final Result<MovieDetails, Exception> Function(Exception e) func =
      (Exception e) { return Result.failure(e); };

    return await _performGetRequest(
      uri: uri,
      onSuccess: (dynamic json) => Result.success(MovieDetails.fromJson(json)),
      onFailure: (Exception e) => func(e)
    );
  }

  // https://api.themoviedb.org/3/genre/movie/list?api_key=<<api_key>>
  Future<Result<List<Genre>, Exception>> genres() async {
    final params = {
      'api_key' : _API_KEY,
      'include_adult' : _userConfig.adult.toString()
    };

    final Uri uri = Uri.https(_BASE_URL, '/3/genre/movie/list', params);

    final Result<List<Genre>, Exception> Function(Exception e) func =
      (Exception e) { return Result.failure(e); };

    return await _performGetRequest(
      uri: uri,
      onSuccess: (dynamic json) => Result.success(Genre.fromJsonResponse(json)),
      onFailure: (Exception e) => func(e)
    );
  }

  // https://api.themoviedb.org/3/movie/popular?api_key=<<api_key>>
  Future<Result<List<Movie>, Exception>> movies(
    final MovieSelection selection) async {

    final params = {
      'api_key' : _API_KEY,
      'include_adult' : _userConfig.adult.toString()
    };

    // query params
    Uri uri;
    if (selection == MovieSelection.POPULAR) {
      uri = Uri.https(_BASE_URL, '/3/movie/popular', params);
    } else if (selection == MovieSelection.UPCOMING){
      uri = Uri.https(_BASE_URL, '/3/movie/upcoming', params);
    }

    final Result<List<Movie>, Exception> Function(Exception e) func =
      (Exception e) { return Result.failure(e); };

    return await _performGetRequest(
      uri: uri,
      onSuccess: (dynamic json) => Result.success(Movie.fromJsonResponse(json)),
      onFailure: (Exception e) => func(e)
    );
  }

  Future<Result<dynamic, Exception>> _performGetRequest({
    @required final Uri uri,
    @required final Function(dynamic) onSuccess,
    @required final Function(Exception) onFailure}) async {

    try {
      debugPrint("GET operation to " + uri.toString());

      final response = await _client.get(uri);
      if (response.statusCode == 200) {
        final jsonString = json.decode(response.body);
        return onSuccess(jsonString);
      } else {
        // TODO: proper handling
        debugPrint("GET operation request status code was != 200");
        return onFailure(Exception("TODO"));
      }
    } catch (e) {
      // TODO: proper handling
      debugPrint("GET operation failed to perform request: ${e.toString()}");
      if (e is Exception) {
        return onFailure(e);
      }
      return onFailure(Exception("TODO"));
    }
  }
}