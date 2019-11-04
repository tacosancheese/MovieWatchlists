import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/models/watchlist_friend.dart';
import 'package:movie_watchlists/models/watchlist_movie.dart';

class Watchlist extends Equatable {

  final String id;
  final bool adult;
  final String name;
  final Map<String, WatchlistMovie> movies;
  final Map<String, WatchlistFriend> users;
  final List<String> followerIds;
  final List<String> userIds;
  final List<String> ownerIds;

  int get totalUsers => users.length;

  bool containsMovie(final String id) => movies[id] != null;

  Watchlist({
    @required this.id,
    @required this.adult,
    @required this.name,
    @required this.movies,
    @required this.users,
    @required this.followerIds,
    @required this.userIds,
    @required this.ownerIds
  });

  Watchlist.fromSnapshot(final Map<String, dynamic> data):
      id = data[FirebaseContract.FIELD_ID],
      adult = data[FirebaseContract.FIELD_ADULT],
      name = data[FirebaseContract.FIELD_NAME],
      movies = Map<String, dynamic>.from (data[FirebaseContract.FIELD_MOVIES])
            .map((key, value) => MapEntry(key, WatchlistMovie.fromSnapshot(Map<String, dynamic>.from(value)))),
      users = Map<String, dynamic>.from (data[FirebaseContract.FIELD_USERS])
        .map((key, value) => MapEntry(key, WatchlistFriend.fromSnapshot(Map<String, dynamic>.from(value)))),
      followerIds = List<String>.from(data[FirebaseContract.FIELD_FOLLOWER_IDS]),
      userIds =  List<String>.from(data[FirebaseContract.FIELD_USER_IDS]),
      ownerIds =  List<String>.from(data[FirebaseContract.FIELD_OWNER_IDS]);
}