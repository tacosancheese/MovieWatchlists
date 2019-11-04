import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/models/watchlist_movie.dart';
import 'package:test/test.dart';

main () {

  test('should deserialize', () {
    final data = {
      FirebaseContract.FIELD_ID: 10,
      FirebaseContract.FIELD_MOVIE_TITLE: "movieTitle",
      FirebaseContract.FIELD_MOVIE_OVERVIEW: "overview",
      FirebaseContract.FIELD_MOVIE_POSTER_URL: "posterUrl",
      FirebaseContract.FIELD_ADDED_BY: "abcdef",
      FirebaseContract.FIELD_MOVIE_GENRES: ["action", "drama"],
      FirebaseContract.FIELD_WATCHED_BY: ["1", "2" , "3"]
    };

    final movie = WatchlistMovie.fromSnapshot(data);

    expect(movie.id, equals(10));
    expect(movie.addedById, equals("abcdef"));
    expect(movie.title, equals("movieTitle"));
    expect(movie.overview, equals("overview"));
    expect(movie.posterUrl, equals("posterUrl"));
    expect(movie.genres, isNotEmpty);
    expect(movie.watchedByIds, isNotEmpty);
  });
}