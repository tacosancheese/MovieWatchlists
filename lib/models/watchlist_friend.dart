import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/firebase_contract.dart';

class WatchlistFriend extends Equatable {

  final String id;
  final String alias;
  final bool notify;

  WatchlistFriend({
    @required this.id,
    @required this.alias,
    @required this.notify,
  });

  WatchlistFriend.fromSnapshot(final Map<String, dynamic> data):
      id = data[FirebaseContract.FIELD_ID],
      alias = data[FirebaseContract.FIELD_ALIAS],
      notify = data[FirebaseContract.FIELD_NOTIFY];
}
