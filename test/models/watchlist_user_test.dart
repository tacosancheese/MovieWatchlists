import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/models/watchlist_user.dart';
import 'package:test/test.dart';

main() {

  test('should deserialize', () {
    final values = {
      FirebaseContract.FIELD_ALIAS : '10',
      FirebaseContract.FIELD_NOTIFICATIONS: false,
      FirebaseContract.FIELD_WATCHED: ['mid1', 'mid2', 'mid3'],
      FirebaseContract.FIELD_WATCHLISTS: ['watchlistid1', 'watchlistid2']
    };

    final user = WatchlistUser.fromSnapshot("123", values);

    expect(user.id, equals("123"));
    expect(user.alias, equals("10"));
    expect(user.notifications, isFalse);
    expect(user.watched, isNotEmpty);
    expect(user.watchlists, isNotEmpty);
  });
}