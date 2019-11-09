import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/models/tmdb_image.dart';
import 'package:test/test.dart';

main() {
  test('should deserialize from API response', () {
    final data = {
      'backdrop_path': "posterUrl",
      'poster_path': "backdropUrl"
    };

    final image = TmdbImage.fromSnapshot(data);
    expect(image.posterPath, isNotNull);
    expect(image.backdropPath, isNotNull);
  });

  test('should deserialize from Firebase snapshot', () {
    final data = {
      FirebaseContract.FIELD_MOVIE_POSTER_URL: "posterUrl",
      FirebaseContract.FIELD_MOVIE_BACKDROP_URL: "backdropUrl"
    };

    final image = TmdbImage.fromSnapshot(data);
    expect(image.posterPath, isNotNull);
    expect(image.backdropPath, isNotNull);
  });
}