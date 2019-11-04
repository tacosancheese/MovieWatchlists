import * as admin from 'firebase-admin' // Would be nicer to import only types

export interface User {
  readonly alias: string
  readonly notifications: boolean
  readonly watched: string[]
  readonly watchlists: string[]
}

export function toUser(snapshot: admin.firestore.DocumentSnapshot) : User {
  const data = snapshot.data()!!
  return toUserFromDocumentData(data);
}

export function toUserFromDocumentData(data: admin.firestore.DocumentData) : User {
  return {
    alias: data.alias,
    notifications: data.notifications,
    watched: data.watched,
    watchlists: data.watchlists  
  };
}