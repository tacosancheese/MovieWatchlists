/** Auth */

import {
  onAuthenticatedUserCreated
} from './triggers/auth/onCreate'

import {
  onAuthenticatedUserDeleted
} from './triggers/auth/onDelete'

/** User **/
import {
  onUserDeleted
} from './triggers/user/onDelete'

import {
  onUserUpdated
} from './triggers/user/onUpdate'

/** Watchlist **/

/*
import {
  onWatchlistDeleted
} from './triggers/watchlist/onDelete'
*/

// content
import { 
  onContentCreated 
} from './triggers/watchlist/content/onCreate'

import { 
  onContentUpdated 
} from './triggers/watchlist/content/onUpdate'

// settings
import { 
  onSettingsWritten 
} from './triggers/watchlist/settings/onWrite'

// user settings
import {
  onUserSettingsWritten
} from './triggers/watchlist/user_settings/onWrite'

import {
  onUserSettingsDeleted
} from './triggers/watchlist/user_settings/onDelete'

export { 
  onAuthenticatedUserCreated,
  onAuthenticatedUserDeleted,
  onUserDeleted,
  onUserUpdated,
  onContentCreated, 
  onContentUpdated,
  onSettingsWritten,
  onUserSettingsDeleted,
  onUserSettingsWritten,
  //onWatchlistDeleted
}