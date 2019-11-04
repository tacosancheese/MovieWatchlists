import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/models/watchlist_friend.dart';
import 'package:test/test.dart';

main() {

  test('should deserialize', () {
    final values = {
      FirebaseContract.FIELD_ID: '10',
      FirebaseContract.FIELD_ALIAS: 'danielsan',
      FirebaseContract.FIELD_NOTIFY: true
    };

    final friend = WatchlistFriend.fromSnapshot(values);

    expect(friend.id, equals("10"));
    expect(friend.alias, equals("danielsan"));
    expect(friend.notify, isTrue);
  });
}