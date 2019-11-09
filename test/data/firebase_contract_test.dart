import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:test/test.dart';

void main() {

  test('should retrieve watchlist path with id', () {
    final path = FirebaseContract.watchlistPath("123");
    expect(path, equals("watchlists/123"));
  });

  test('should retrieve movies path with id', () {
    final path = FirebaseContract.watchlistMoviesPath("123");
    expect(path, equals("watchlists/123/content/movies"));
  });
}