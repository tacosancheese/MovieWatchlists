import 'package:flutter/material.dart';
import 'package:movie_watchlists/data/api/api_tmdb.dart';
import 'package:movie_watchlists/models/cast.dart';
import 'package:movie_watchlists/shared/base_repository.dart';
import 'package:movie_watchlists/shared/result.dart';

class CastRepository implements BaseRepository{

  final ApiTmdb _api;

  CastRepository({
    @required ApiTmdb api
  }): this._api = api;

  @override
  void dispose() {
    // TODO: implement dispose
  }

  Future<Result<List<Cast>, Exception>> getCast(final int movieId) {
    debugPrint("CastRepository => get " + movieId.toString());
    return _api.cast(movieId);
  }
}