import * as functions from 'firebase-functions'
import firestore from './../../db/db'
import { ellipsifyUserId } from '../utils'
import { userPath } from '../firebase_contract'

export const onAuthenticatedUserDeleted = functions
  .auth
  .user()
  .onDelete(async (user) => {
    const userId: string = user.uid;
    console.log("about to delete, user: %s...", ellipsifyUserId(userId))
    
    try {
      console.log("about to complete delete, user: %s...", ellipsifyUserId(userId))
      return await firestore.doc(userPath(userId))
        .delete();
    } catch(e) {
      console.log("failed to delete from /users/%s", ellipsifyUserId(userId))
      console.log(e)
      return null;
    }
});