import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/models/watchlist.dart';
import 'package:test/test.dart';

main() {

  test('should deserialize', () {
    final values = {
      FirebaseContract.FIELD_ID: '10',
      FirebaseContract.FIELD_ADULT: true,
      FirebaseContract.FIELD_NAME: 'watchlist name',
      FirebaseContract.FIELD_MOVIES: {
        "movieId": {
          FirebaseContract.FIELD_ID: 10,
          FirebaseContract.FIELD_MOVIE_TITLE: "movieTitle",
          FirebaseContract.FIELD_MOVIE_OVERVIEW: "overview",
          FirebaseContract.FIELD_MOVIE_POSTER_URL: "posterUrl",
          FirebaseContract.FIELD_ADDED_BY: "abcdef",
          FirebaseContract.FIELD_MOVIE_GENRES: ["action", "drama"],
          FirebaseContract.FIELD_WATCHED_BY: ["1", "2" , "3"]
        }
      },
      FirebaseContract.FIELD_USERS: {
        "userId": {
          FirebaseContract.FIELD_ALIAS: 'alias1',
          FirebaseContract.FIELD_ID: 'uid1',
          FirebaseContract.FIELD_NOTIFY: false
        }
      },
      FirebaseContract.FIELD_FOLLOWER_IDS: ["uid1"],
      FirebaseContract.FIELD_USER_IDS: ["uid1"],
      FirebaseContract.FIELD_OWNER_IDS: ["uid1"]
    };

    final watchlist = Watchlist.fromSnapshot(values);

    expect(watchlist.id, equals("10"));
    expect(watchlist.adult, isTrue);
    expect(watchlist.name, equals("watchlist name"));
    expect(watchlist.movies, isNotEmpty);
    expect(watchlist.users, isNotEmpty);
    expect(watchlist.followerIds, isNotEmpty);
    expect(watchlist.userIds, isNotEmpty);
    expect(watchlist.ownerIds, isNotEmpty);
  });
}