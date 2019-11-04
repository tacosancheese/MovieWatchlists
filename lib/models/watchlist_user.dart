import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/firebase_contract.dart';

class WatchlistUser extends Equatable {

  final String id;
  final String alias;
  final bool notifications;
  final List<String> watched;
  final List<String> watchlists;

  WatchlistUser({
    @required this.id,
    @required this.alias,
    @required this.notifications,
    @required this.watched,
    @required this.watchlists
  });

  WatchlistUser.fromSnapshot(final String id, final Map<String, dynamic> data):
      id = id,
      alias = data[FirebaseContract.FIELD_ALIAS],
      notifications = data[FirebaseContract.FIELD_NOTIFICATIONS],
      watched = List<String>.from(data[FirebaseContract.FIELD_WATCHED]),
      watchlists = List<String>.from(data[FirebaseContract.FIELD_WATCHLISTS]);
}
