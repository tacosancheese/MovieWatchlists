import 'package:flutter/cupertino.dart';
import 'package:movie_watchlists/data/api/api_tmdb.dart';
import 'package:movie_watchlists/models/genre.dart';
import 'package:movie_watchlists/shared/base_repository.dart';
import 'package:movie_watchlists/shared/result.dart';

class GenreRepository implements BaseRepository {

  final ApiTmdb _api;
  final List<Genre> _cachedGenres;

  GenreRepository({
    @required final ApiTmdb api
  }) : this._api = api, _cachedGenres = <Genre>[];

  @override
  void dispose() {
    // TODO: implement dispose
  }

  Future<Result<List<Genre>, Exception>> all() async {
    debugPrint("GenreRepository => all");

    if (_cachedGenres.isNotEmpty) {
      debugPrint("GenreRepository => cache is not empty");
      return Future.value(Result.success(_cachedGenres));
    }

    return _api.genres()
      .then((result) => _cacheResult(result))
      .catchError((err) => debugPrint("GenreRepository: error $err"));
  }

  Future<Result<List<Genre>, Exception>>_cacheResult(final Result<List<Genre>, Exception> result) {
    if (result.hasResult) {
      debugPrint("GenreRepository => about to cache result");
      _cachedGenres.clear();
      _cachedGenres.addAll(result.result);
    } else {
      debugPrint("GenreRepository => unable to cache result due to an error");
    }
    return Future.value(result);
  }

}