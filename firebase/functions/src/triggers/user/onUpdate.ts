import * as admin from 'firebase-admin' // Would be nicer to import only types
import * as functions from 'firebase-functions'
import firestore from './../../db/db'

import { toUserFromDocumentData, User } from '../../models/user';
import { userSettingsPath, settingsPath } from '../firebase_contract'
import { toWatchlistSettings } from '../../models/watchlist_settings';
import { DocumentSnapshot } from 'firebase-functions/lib/providers/firestore';

export const onUserUpdated = functions
.firestore.document('users/{userId}')
.onUpdate(async (change, context) => {
  const userId: string = context.params.userId
  console.log("about to update, user: %s...", userId.substring(0, 7))
  
  const data = change.after.data()
  const oldData = change.before.data()
  if (data === oldData || data == null || oldData == null) {
    console.log("data should not be null")
    return null;
  }
  
  const newUser: User = toUserFromDocumentData(data)
  const oldUser: User = toUserFromDocumentData(oldData)
  
  try {
    return firestore.runTransaction(async transaction => {
      
      // notify is not tracked because user can set his or hers notify status per watchlist
      // user's notify is used to track whether notifications should be sent altogether
      if (newUser.alias !== oldData.alias) {
        console.log("user has updated alias")
        const ids = newUser.watchlists
        
        ids.forEach((watchlistId) => {
          const ref: admin.firestore.DocumentReference = firestore
          .doc(userSettingsPath(watchlistId, userId))
          
          transaction.update(ref, {
            alias: newUser.alias
          });
        });
      } else if (newUser.watchlists !== oldUser.watchlists) { // update watchlists
        console.log("user has updated watchlists")
        if (newUser.watchlists.length > oldUser.watchlists.length) {
          console.log("user has added %d watchlist(s)", newUser.watchlists.length - oldUser.watchlists.length)
          
        } else { 
          console.log("user has removed %d watchlist(s)", oldUser.watchlists.length - newUser.watchlists.length)
          
          const oldIds = oldUser.watchlists
            .filter((watchlistId) => newUser.watchlists.indexOf(watchlistId) === -1)

          const refs = oldIds
            .map(watchlistId => firestore.doc(settingsPath(watchlistId)))

          const docs: DocumentSnapshot[] = await firestore
            .getAll(...refs)

          docs.forEach(async (doc) => {  
            const settings = toWatchlistSettings(doc)

            transaction.update(doc.ref, {
              followerIds: settings.followerIds
              .filter(id => id !== userId),
              ownerIds: settings.ownerIds
              .filter(id => id !== userId)
            });
          });
        }
      } else if (newUser.watched !== oldUser.watched) { // update watchlists
        console.log("user has changed list of watched movies")
        // TODO: update users watchlists 
      }
      
      console.log("about to complete update, user: %s...", userId.substring(0, 7))
      return await transaction;
    });
  } catch (e) {
    console.log("failed to update data, user: %s...", userId.substring(0, 7))
    console.log(e)
    return null;
  }
});