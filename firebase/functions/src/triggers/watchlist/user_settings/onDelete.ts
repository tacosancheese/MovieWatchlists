import * as admin from 'firebase-admin' // Would be nicer to import only types
import * as functions from 'firebase-functions'
import firestore from './../../../db/db'

import { Watchlist, toWatchlist } from './../../../models/watchlist'
import { ellipsifyUserId } from './../../utils'

import 'reflect-metadata';

import { classToPlain } from 'class-transformer'
import { watchlistPath, settingsPath, contentPath } from '../../firebase_contract'

// delete user information from the main document
export const onUserSettingsDeleted = functions
.firestore.document('watchlists/{watchlistId}/user_settings/{userId}')
.onDelete(async (snapshot, context) => {
  const userId: string = context.params.userId;
  const watchlistId: string = context.params.watchlistId;

  console.log("about to delete, watchlist: %s, userId: %s", watchlistId, ellipsifyUserId(userId))

  return await firestore.runTransaction(async transaction => {
    const watchlistRef: admin.firestore.DocumentReference = firestore.doc(watchlistPath(watchlistId));
    const watchlistSnapshot: admin.firestore.DocumentSnapshot = await transaction.get(watchlistRef);
    const watchlist: Watchlist = toWatchlist(watchlistSnapshot); 
    
    const followerIds = watchlist.followerIds
      .filter(id => id !== userId)

    const ownerIds = watchlist.ownerIds
      .filter(id => id !== userId)

    const allUserIds = Array.from(new Set(followerIds.concat(ownerIds)))

    // delete the watchlist 
    if (allUserIds.length == 0) { 
      console.log("no users left in the watchlist => deleting the watchlist and subcollections")
      console.log("about to complete delete, watchlist: %s, userId: %s", watchlistId, ellipsifyUserId(userId))

      const contentRef: admin.firestore.DocumentReference = firestore.doc(contentPath(watchlistId));
      transaction.delete(contentRef)

      const settingsRef: admin.firestore.DocumentReference = firestore.doc(settingsPath(watchlistId));
      transaction.delete(settingsRef)

      return await transaction.delete(watchlistRef);
    }

    // update the watchlist
    watchlist.users.delete(userId);
    
    console.log("about to complete delete, watchlist: %s, userId: %s", watchlistId, ellipsifyUserId(userId))
    return await transaction.update(watchlistRef, {
      adult: watchlist.adult,
      movies: classToPlain(watchlist.movies),
      name: watchlist.name,
      followerIds: followerIds,
      ownerIds: ownerIds,
      userIds: allUserIds,
      users: classToPlain(watchlist.users)
    });
  });
});