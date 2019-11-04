const COLLECTION_USERS = "users"

const COLLECTION_WATCHLISTS = "watchlists"
const COLLECTION_CONTENT = "content"
const COLLECTION_USER_SETTINGS = "user_settings"
const COLLECTION_SETTINGS = "settings"

const COLLECTION_CONTENT_MOVIES = "movies"
const COLLECTION_SETTINGS_GENERAL = "general"

export function watchlistPath(watchlistId: string): string {
    return COLLECTION_WATCHLISTS + "/" + watchlistId
}

export function userPath(userId: string): string {
    return COLLECTION_USERS + "/" + userId
}

export function contentPath(watchlistId: string) {
    return watchlistPath(watchlistId) + "/" + COLLECTION_CONTENT + "/" + COLLECTION_CONTENT_MOVIES
}

export function settingsPath(watchlistId: string) {
    return watchlistPath(watchlistId) + "/" + COLLECTION_SETTINGS + "/" + COLLECTION_SETTINGS_GENERAL
}

export function userSettingsPath(watchlistId: string, userId: string) {
    return watchlistPath(watchlistId) + "/" + COLLECTION_USER_SETTINGS + "/" + userId
}