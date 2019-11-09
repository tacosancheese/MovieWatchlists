import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/data/tmdb_contract.dart';

class TmdbImage extends Equatable{

  final String baseImageUrl;
  final String posterPath;
  final String backdropPath;

  TmdbImage({
    @required this.posterPath,
    @required this.backdropPath
  }): this.baseImageUrl = TmdbContract.baseImageUrl;

  String get originalPosterPathUrl => posterPath != null
    ? baseImageUrl + "original" + posterPath : null;

  String get smallPosterPathUrl => posterPath != null
    ? baseImageUrl + "w300" + posterPath : null;

  String get originalBackdropPathUrl => backdropPath != null
    ? baseImageUrl + "original" + backdropPath : null;

  String get smallBackdropPathUrl => backdropPath != null
    ? baseImageUrl + "w300" + backdropPath : null;

  TmdbImage.fromSnapshot(final Map<String, dynamic> data) :
      baseImageUrl = TmdbContract.baseImageUrl,
      backdropPath = data[FirebaseContract.FIELD_MOVIE_BACKDROP_URL] ?? data["backdrop_path"],
      posterPath = data[FirebaseContract.FIELD_MOVIE_POSTER_URL] ?? data["poster_path"];
}