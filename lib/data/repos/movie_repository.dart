import 'package:flutter/material.dart';
import 'package:movie_watchlists/data/api/api_tmdb.dart';
import 'package:movie_watchlists/models/movie_.dart';
import 'package:movie_watchlists/models/movie_details.dart';
import 'package:movie_watchlists/models/movie_selection.dart';
import 'package:movie_watchlists/shared/base_repository.dart';
import 'package:movie_watchlists/shared/result.dart';

class MovieRepository implements BaseRepository {

  final ApiTmdb _api;
  final Map<MovieSelection, List<Movie_>> _cachedSelections;

  MovieRepository({
    @required ApiTmdb api
  }): this._api = api, _cachedSelections = {};

  @override
  void dispose() {
    // TODO: implement dispose
  }

  Future<Result<List<Movie_>, Exception>> all(final MovieSelection selection) {
    debugPrint("MovieRepository => all " + selection.toString());

    if (_cachedSelections.containsKey(selection)) {
      debugPrint("MovieRepository => cache is not empty for $selection");
      return Future.value(Result.success(_cachedSelections[selection]));
    }

    return _api.movies(selection)
      .then((result) => _cacheResult(selection, result))
      .catchError((err) => debugPrint("MovieRepository: error $err"));
  }

  Future<Result<List<Movie_>, Exception>>_cacheResult(
    final MovieSelection selection,
    final Result<List<Movie_>, Exception> result) {
    if (result.hasResult) {
      debugPrint("GenreRepository => about to cache result");
      _cachedSelections.putIfAbsent(selection, () => result.result);
    } else {
      debugPrint("GenreRepository => unable to cache result due to an error");
    }
    return Future.value(result);
  }

  Future<Result<MovieDetails, Exception>> get(final int id) {
    debugPrint("MovieRepository => get " + id.toString());
    return _api.details(id);
  }
}
