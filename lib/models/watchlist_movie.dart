import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/firebase_contract.dart';

class WatchlistMovie extends Equatable {

  final int id;
  final String title;
  final String overview;
  final String posterUrl;
  final String addedById;
  final List<String> genres;
  final List<String> watchedByIds;

  WatchlistMovie({
    @required this.id,
    @required this.title,
    @required this.overview,
    @required this.posterUrl,
    @required this.addedById,
    @required this.genres,
    @required this.watchedByIds
  });

  WatchlistMovie.fromSnapshot(final Map<String, dynamic> data):
      id = data[FirebaseContract.FIELD_ID],
      title = data[FirebaseContract.FIELD_MOVIE_TITLE],
      overview = data[FirebaseContract.FIELD_MOVIE_OVERVIEW],
      posterUrl = data[FirebaseContract.FIELD_MOVIE_POSTER_URL],
      addedById = data[FirebaseContract.FIELD_ADDED_BY],
      genres = List<String>.from(data[FirebaseContract.FIELD_MOVIE_GENRES]),
      watchedByIds = List<String>.from(data[FirebaseContract.FIELD_WATCHED_BY]);

  Map<String, dynamic> toSnapshot() => {
    FirebaseContract.FIELD_ID: id,
    FirebaseContract.FIELD_MOVIE_TITLE: title,
    FirebaseContract.FIELD_MOVIE_OVERVIEW: overview,
    FirebaseContract.FIELD_MOVIE_POSTER_URL: posterUrl,
    FirebaseContract.FIELD_ADDED_BY: addedById,
    FirebaseContract.FIELD_MOVIE_GENRES: genres,
    FirebaseContract.FIELD_WATCHED_BY: watchedByIds
  };
}