import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/blocs/watchlist_create_bloc.dart';
import 'package:movie_watchlists/data/auth/auth_handler.dart';
import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/models/watchlist.dart';
import 'package:movie_watchlists/shared/base_repository.dart';
import 'package:movie_watchlists/shared/result.dart';
import 'package:rxdart/rxdart.dart';

class WatchlistRepository implements BaseRepository {

  final AuthHandler handler;
  final Firestore firestore;
  final List<StreamSubscription> _streamSubscriptions = [];

  WatchlistRepository({
    @required AuthHandler handler,
    @required Firestore firestore
  }): this.handler = handler, this.firestore = firestore;

  @override
  void dispose() async {
    _streamSubscriptions.forEach((subscription) async{
      await subscription.cancel();
    });
  }

  Future<Result<bool, Exception>> create(final WatchlistSettings settings) async {
    debugPrint("WatchlistRepository => about to create");
    try {
      final user = await handler.currentUser();
      final userId = user.result.uid;
      debugPrint("WatchlistRepository => userId is $userId");

      final watchlistDocRef = firestore.collection(FirebaseContract.COLLECTION_WATCHLISTS)
        .document();

      // watchlist
      final watchlistData = {
        FirebaseContract.FIELD_ID: watchlistDocRef.documentID,
        FirebaseContract.FIELD_ADULT: settings.adult,
        FirebaseContract.FIELD_MOVIES: {},
        FirebaseContract.FIELD_NAME: settings.name,
        FirebaseContract.FIELD_USER_IDS: [userId],
        FirebaseContract.FIELD_FOLLOWER_IDS: [],
        FirebaseContract.FIELD_OWNER_IDS: [userId],
        FirebaseContract.FIELD_USERS: {}
      };

      // watchlist content
      final contentDocRef = watchlistDocRef.collection(FirebaseContract.COLLECTION_CONTENT)
        .document(FirebaseContract.MOVIES_ID);

      final contentData = {
        FirebaseContract.FIELD_COUNT: 0,
        FirebaseContract.FIELD_MOVIES: {}
      };

      // watchlist settings
      final settingsDocRef = watchlistDocRef.collection(FirebaseContract.COLLECTION_SETTINGS)
        .document(FirebaseContract.GENERAL_ID);

      final settingsData = {
        FirebaseContract.FIELD_ADULT: settings.adult,
        FirebaseContract.FIELD_NAME: settings.name,
        FirebaseContract.FIELD_OWNER_IDS: [userId],
        FirebaseContract.FIELD_FOLLOWER_IDS: []
      };

      // watchlist user settings
      final userSettingsDocRef = watchlistDocRef.collection(FirebaseContract.COLLECTION_USER_SETTINGS)
        .document(userId);

      final Map<String, dynamic> userSettingsData = {};

      // update users
      final userDocRef = firestore.collection(FirebaseContract.COLLECTION_USERS)
        .document(userId);

      // TODO: should change to transaction
      final doc = await userDocRef.get();
      final watchlists = doc.data[FirebaseContract.FIELD_WATCHLISTS];
      final modifiedSet = watchlists.toSet();
      modifiedSet.add(watchlistDocRef.documentID);

      final userData = {
        FirebaseContract.FIELD_WATCHLISTS: modifiedSet.toList()
      };

      debugPrint("WatchlistRepository => about to write batchy batch");

      // batch writes
      final batch = firestore.batch();

      // update users
      batch.updateData(userDocRef, userData);

      // update watchlist
      batch.setData(watchlistDocRef, watchlistData);
      batch.setData(contentDocRef, contentData);
      batch.setData(settingsDocRef, settingsData, merge: true);
      batch.setData(userSettingsDocRef, userSettingsData, merge: true);
      await batch.commit();

      debugPrint("WatchlistRepository => about to return from create");
      return Result.success(true);
    } catch (e) {
      debugPrint("WatchlistRepository => failed: ${e.toString()}");
      return Result.failure(e); // TOOD: error handling
    }
  }

  Stream<Result<List<Watchlist>, Exception>> findAll() async* {
    debugPrint("WatchlistRepository => about to findAll");

    try {
      final user = await handler.currentUser();
      final userId = user.result.uid;
      debugPrint("WatchlistRepository => userId is $userId");

      final snapshots = Firestore.instance
        .collection(FirebaseContract.COLLECTION_WATCHLISTS)
        .where(FirebaseContract.FIELD_USER_IDS, arrayContains: userId)
        .snapshots();

      await for (final snapshot in snapshots) {
        debugPrint("WatchlistRepository => about to process snapshot");

        final watchlists = snapshot.documents
          .map((document) => Watchlist.fromSnapshot(document.data))
          .toList()
          ..sort((w1, w2) => w1.name.compareTo(w2.name));

        yield Result.success(watchlists);
      }
    } catch (e) {
      debugPrint("WatchlistRepository => failed: ${e.toString()}");
      yield Result.failure(e);
    }
  }

  Stream<Result<Watchlist, Exception>> findById(final String id) async* {
    debugPrint("WatchlistRepository => about to findAll");

    try {
      final user = await handler.currentUser();
      final userId = user.result.uid;
      debugPrint("WatchlistRepository => userId is $userId");

      final snapshots = Firestore.instance
        .document(FirebaseContract.watchlistPath(id))
        .snapshots();

      await for (final snapshot in snapshots) {
        debugPrint("WatchlistRepository => about to process snapshot");

        final watchlist = Watchlist.fromSnapshot(snapshot.data);
        yield Result.success(watchlist);
      }
    } catch (e) {
      debugPrint("WatchlistRepository => failed: ${e.toString()}");
      yield Result.failure(e);
    }
  }

  // updates are made to watchlists/<watchlistId>/content/movies
  Future<Result<bool, Exception>> update(final String watchlistId,
    final Map<String, dynamic> fields) async {
    debugPrint("WatchlistRepository => about to update");

    try {
      final user = await handler.currentUser();
      final userId = user.result.uid;
      debugPrint("WatchlistRepository => userId is $userId");

      final watchlistData = {
        FirebaseContract.FIELD_COUNT: fields.length,
        FirebaseContract.FIELD_MOVIES: fields,
      };

      await firestore.document(FirebaseContract.watchlistMoviesPath(watchlistId))
        .updateData(watchlistData);

      debugPrint("WatchlistRepository => update success");
      return Result.success(true);
    } catch (e) {
      debugPrint("WatchlistRepository => failed: ${e.toString()}");
      return Result.failure(e);
    }
  }
}