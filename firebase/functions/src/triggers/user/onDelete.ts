import * as admin from 'firebase-admin' // Would be nicer to import only types
import * as functions from 'firebase-functions'
import firestore from './../../db/db'

import { WatchlistSettings, toWatchlistSettings } from '../../models/watchlist_settings'
import { User, toUserFromDocumentData } from '../../models/user'
import { ellipsifyUserId } from '../utils'
import { settingsPath } from '../firebase_contract'

export const onUserDeleted = functions
.firestore.document('users/{userId}')
.onDelete(async (snapshot, context) => {
  const userId: string = context.params.userId
  console.log("about to delete, user: %s...", ellipsifyUserId(userId))
  
  const data = snapshot.data();
  if (data == null) {
    console.log("data should not be null")
    return null
  }

  const user: User = toUserFromDocumentData(data);
  if (user.watchlists.length === 0) {
    console.log("about to complete delete, user %s... didn't have any watchlists", ellipsifyUserId(userId))
    return null;
  }
  
  try {
    return await firestore.runTransaction(async transaction => {
      const refs: admin.firestore.DocumentReference[] = user.watchlists
        .map(watchlistId => firestore.doc(settingsPath(watchlistId)))
      
      const docs: admin.firestore.DocumentSnapshot[] = await transaction.getAll(...refs)
      
      docs.forEach(async doc => {
        const settings: WatchlistSettings = toWatchlistSettings(doc.data()!!)
        
        console.log("about to complete update, data: %s...", doc.id)
        await transaction.update(doc.ref, {
          adult: settings.adult,
          name: settings.name,
          followerIds: settings.followerIds
            .filter(id => id !== userId),
          ownerIds: settings.ownerIds
            .filter(id => id !== userId)
        })
      })

      return transaction  
    })
  } catch (e) {
    console.log("failed to update watchlist data, user: %s...", ellipsifyUserId(userId))
    console.log(e)
    return null
  }
});