import * as functions from 'firebase-functions'
import firestore from './../../db/db'
import { ellipsifyUserId } from './../utils'
import { userPath } from '../firebase_contract'

export const onAuthenticatedUserCreated = functions
.auth
.user()
.onCreate(async (user) => {
  const userId: string = user.uid;
  console.log("about to create, user: %s...", ellipsifyUserId(userId))
  
  const ref = firestore.doc(userPath(userId))
  const result = await ref.get()
 
  if (result.exists) {
    console.log("user already exists => returning early")
    return null;
  }

  console.log("about to complete update, user: %s...", ellipsifyUserId(userId))
  try {
    return await firestore.doc(userPath(userId))
    .create({
      alias: "John Doe",
      notifications: false,
      watched: [],
      watchlists: []  
    }
    );
  } catch(e) {
    console.log("failed to create user to /users/%s", ellipsifyUserId(userId))
    console.log(e)
    return null;
  }
});