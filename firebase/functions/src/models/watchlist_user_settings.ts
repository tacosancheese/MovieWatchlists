import * as admin from 'firebase-admin' // Would be nicer to import only types

export interface WatchlistUserSettings {
    readonly alias: string
    readonly notify: boolean
}

export function toUserSettingsFromSnapshot(snapshot: admin.firestore.DocumentSnapshot): WatchlistUserSettings {
    const data = snapshot.data()!!;
    return toUserSettingsFromDocumentData(data);
}

export function toUserSettingsFromDocumentData(data: admin.firestore.DocumentData): WatchlistUserSettings {
    return {
        alias: data.alias,
        notify: data.notify
    }
}