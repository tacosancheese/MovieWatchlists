import * as admin from 'firebase-admin' // Would be nicer to import only types
import * as functions from 'firebase-functions'
import firestore from './../../db/db'

import { Watchlist, toWatchlist } from './../../models/watchlist'

// delete watchlist and all related information
export const onWatchlistDeleted = functions
.firestore.document('watchlists/{watchlistId}')
.onDelete(async (snapshot, context) => {
  const watchlistId: string = context.params.watchlistId;
  
  console.log("about to delete, watchlist: %s", watchlistId)

  const watchlist: Watchlist = toWatchlist(snapshot);
  const batch: admin.firestore.WriteBatch = firestore.batch()

  // delete content
  const content = "watchlists/" + watchlistId + "/content"
  const contentDoc = firestore.doc(content)
  batch.delete(contentDoc)

  // delete settings
  const settings = "watchlists/" + watchlistId + "/settings"
  const settingsDoc = firestore.doc(settings)
  batch.delete(settingsDoc)

  // delete user settings
  Array.from(new Set(watchlist.followerIds.concat(watchlist.ownerIds)))
    .forEach(userId => {
      const userSettings = "watchlists/" + watchlistId + "/user_settings/" + userId
      const userSettingsDoc = firestore.doc(userSettings)
      batch.delete(userSettingsDoc)
    })

  console.log("about to complete delete, watchlist: %s", watchlistId)
  return batch.commit()
});