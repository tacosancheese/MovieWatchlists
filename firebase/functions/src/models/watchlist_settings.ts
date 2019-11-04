import * as admin from 'firebase-admin' // Would be nicer to import only types

export interface WatchlistSettings {
    readonly adult: boolean
    readonly name: string
    readonly followerIds: string[]
    readonly ownerIds: string[]
}

export function toWatchlistSettings(data: admin.firestore.DocumentData): WatchlistSettings {
    return {
        adult: data.adult,
        name: data.name,
        followerIds: Array.from(new Set(data.followerIds)),
        ownerIds: Array.from(new Set(data.ownerIds))
    }
}