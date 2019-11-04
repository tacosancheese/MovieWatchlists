import * as admin from 'firebase-admin' // Would be nicer to import only types
import * as functions from 'firebase-functions'
import firestore from './../../../db/db'

import { WatchlistSettings, toWatchlistSettings } from './../../../models/watchlist_settings'
import { ellipsifyUserId } from './../../utils'
import { userSettingsPath, watchlistPath } from '../../firebase_contract'

import 'reflect-metadata';

// copy settings to the main document
export const onSettingsWritten = functions
.firestore.document('watchlists/{watchlistId}/settings/general')
.onWrite(async (change, context) => {
  const watchlistId: string = context.params.watchlistId
  console.log("about to write, watchlist: %s", watchlistId)
  
  const data: admin.firestore.DocumentData = change.after.data()!!
  const oldData: admin.firestore.DocumentData = change.before.data()!!
  
  if (data === oldData || data == null) { // avoid infinite loop
    return null
  }
  
  const settings: WatchlistSettings = toWatchlistSettings(data)
  let oldSettings: WatchlistSettings
  
  if (oldData != null) {
    oldSettings = toWatchlistSettings(oldData)
  } else {
    oldSettings = {
      adult: false,
      followerIds: [],
      name: "",
      ownerIds: []
    }
  }
  
  const newIds = settings.ownerIds.concat(settings.followerIds)
  const oldIds = oldSettings.ownerIds.concat(oldSettings.followerIds)
  
  // TODO: Set + difference could be smarter?
  const newUsers = newIds
    .filter(id => oldIds.indexOf(id) === -1)
  
  const removedUsers = oldIds
    .filter(id => newIds.indexOf(id) === -1)  
  
  return await firestore.runTransaction(async transaction => {
    if (newUsers.length > -1) {
      newUsers.forEach(userId => {
        // TODO: watched content needs to be updated (add userId)

        // create user to user_settings
        const ref = firestore.doc(userSettingsPath(watchlistId, userId))
        transaction.set(ref, {});
        console.log("user %s... has been added to the watchlist", ellipsifyUserId(userId))
      })
    }
    
    if (removedUsers.length > -1) {
      removedUsers.forEach(userId => {
        // TODO: watched content needs to be updated (remove userId)

        // delete user from user_settings
        const ref = firestore.doc(userSettingsPath(watchlistId, userId))
        transaction.delete(ref);
        console.log("user %s... has been removed from the watchlist", ellipsifyUserId(userId))
      })
    }
    
    const watchlistRef: admin.firestore.DocumentReference = firestore.doc(watchlistPath(watchlistId))
    
    console.log("about to complete write, watchlist: %s", watchlistId)
    const followerIds = Array.from(new Set(settings.followerIds))
    const ownerIds = Array.from(new Set(settings.ownerIds))

    return await transaction.update(watchlistRef, {
      "adult": settings.adult,
      "name": settings.name,
      "userIds": Array.from(new Set(followerIds.concat(ownerIds))),
      "followerIds": followerIds,
      "ownerIds": ownerIds
    });
  });
});