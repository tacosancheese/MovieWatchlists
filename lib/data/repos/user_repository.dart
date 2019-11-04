import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/auth/auth_handler.dart';
import 'package:movie_watchlists/models/watchlist_user.dart';
import 'package:movie_watchlists/shared/base_repository.dart';
import 'package:movie_watchlists/shared/result.dart';

import '../firebase_contract.dart';

class UserRepository implements BaseRepository{

  final AuthHandler handler;
  final Firestore firestore;

  UserRepository({
    @required AuthHandler handler,
    @required Firestore firestore
  }): this.handler = handler, this.firestore = firestore;

  @override
  void dispose() {
    // TODO: implement dispose
  }

  Future<Result<WatchlistUser, Exception>> getUser() async {
    debugPrint("UserRepository => getUser()");

    final Result<FirebaseUser, Exception> result = await handler.currentUser();
    if (result.hasResult) {
      final userId = result.result.uid;
      debugPrint("UserRepository => userId is $userId");

      final WatchlistUser user = await _getUser(userId);
      debugPrint("UserRepository => getUser() success ");
      return Result.success(user);
    }

    debugPrint("UserRepository => getUser() failed due to ${result.exception}");
    return Result.failure(result.exception);
  }

  Future<Result<WatchlistUser, Exception>> updateUser(final Map<String, dynamic> fields) async {
    debugPrint("UserRepository => updateUser()");

    final Result<WatchlistUser, Exception> result = await getUser();
    if (result.hasResult) {

      final user = result.result;
      final userId = user.id;
      debugPrint("UserRepository => userId is $userId}");

      final userData = {
        FirebaseContract.FIELD_ID: userId,
        FirebaseContract.FIELD_ALIAS: fields[FirebaseContract.FIELD_ALIAS] ?? user.alias,
        FirebaseContract.FIELD_NOTIFICATIONS: fields[FirebaseContract.FIELD_NOTIFICATIONS] ?? user.notifications,
        FirebaseContract.FIELD_WATCHED: fields[FirebaseContract.FIELD_WATCHED] ?? user.watched,
        FirebaseContract.FIELD_WATCHLISTS: fields[FirebaseContract.FIELD_WATCHLISTS] ?? user.watchlists
      };

      await firestore.collection(FirebaseContract.COLLECTION_USERS)
        .document(userId)
        .updateData(userData);

      debugPrint("UserRepository => updateUser() success ");
      return Result.success(user);
    }

    debugPrint("UserRepository => updateUser() failed due to ${result.exception}");
    return Result.failure(result.exception);
  }

  Future<WatchlistUser> _getUser(final String userId) async {
    final userDocRef = firestore.collection(FirebaseContract.COLLECTION_USERS)
      .document(userId);

    final doc = await userDocRef.get();
    return WatchlistUser.fromSnapshot(userDocRef.documentID, doc.data);
  }

}