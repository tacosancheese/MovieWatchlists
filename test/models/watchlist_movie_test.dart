import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/models/tmdb_image.dart';
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
    expect(movie.tmdbImage.posterPath, contains("posterUrl"));
    expect(movie.genres, isNotEmpty);
    expect(movie.watchedByIds, isNotEmpty);
  });

  test('should serialize', () {
    final movie = WatchlistMovie(
      id: 1,
      title: "title",
      addedById: "123",
      genres: ["action"],
      overview: "overview",
      tmdbImage: TmdbImage(
        posterPath: "posterUrl",
        backdropPath: null
      ),
      watchedByIds: ["123"]
    );

    final snapshot = movie.toSnapshot();

    expect(snapshot[FirebaseContract.FIELD_ID], equals(1));
    expect(snapshot[FirebaseContract.FIELD_MOVIE_TITLE], equals("title"));
    expect(snapshot[FirebaseContract.FIELD_MOVIE_OVERVIEW], equals("overview"));
    expect(snapshot[FirebaseContract.FIELD_MOVIE_POSTER_URL], contains("posterUrl"));
    expect(snapshot[FirebaseContract.FIELD_ADDED_BY], isNotEmpty);
    expect(snapshot[FirebaseContract.FIELD_MOVIE_GENRES], isNotEmpty);
    expect(snapshot[FirebaseContract.FIELD_WATCHED_BY], isNotEmpty);
  });
}