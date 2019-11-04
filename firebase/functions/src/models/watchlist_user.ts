import * as admin from 'firebase-admin' // Would be nicer to import only types

import { WatchlistUserSettings } from './watchlist_user_settings'

export interface WatchlistUser {
    readonly alias: string;
    readonly notify: boolean;
    readonly role: string
}

export function watchlistUserFromSnapshot(data: admin.firestore.DocumentData): WatchlistUser {
    return {
        alias: data.alias,
        notify: data.notify,
        role: data.role
    }
}

export function toWatchlistUser(mainSnapshot: admin.firestore.DocumentSnapshot, userSettings: WatchlistUserSettings): WatchlistUser {
    const data = mainSnapshot.data()!!;
    return {
        alias: userSettings.alias,
        notify: userSettings.notify,
        role: data.role
    }
}