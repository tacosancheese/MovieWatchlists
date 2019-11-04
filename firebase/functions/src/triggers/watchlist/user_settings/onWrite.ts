import * as admin from 'firebase-admin' // Would be nicer to import only types
import * as functions from 'firebase-functions'
import firestore from './../../../db/db'

import { User, toUser } from '../../../models/user'
import { WatchlistUser, watchlistUserFromSnapshot } from '../../../models/watchlist_user'
import { ellipsifyUserId } from '../../utils'
import { userPath, watchlistPath } from '../../firebase_contract'

export const onUserSettingsWritten = functions
.firestore.document('watchlists/{watchlistId}/user_settings/{userId}')
.onWrite(async (change, context) => {
    const userId: string = context.params.userId;
    const watchlistId: string = context.params.watchlistId;
    console.log("about to write, watchlist: %s, user: %s...", watchlistId, ellipsifyUserId(userId))

    const data = change.after.data();
    const oldData = change.before.data();
    if (data === oldData || data == null) {
        console.log("data should not be null => could be a delete operation");
        return null;
    }

    return await firestore.runTransaction(async transaction => {
        let alias
        let notifications

        if (oldData == null) {
            console.log("new user has been added, populating from user's default fields")
            const userRef: admin.firestore.DocumentReference = firestore.doc(userPath(userId));
            const userSnapshot: admin.firestore.DocumentSnapshot = await transaction.get(userRef);
            const user: User = toUser(userSnapshot);
            
            alias = user.alias
            notifications = user.notifications

            transaction.update(change.after.ref, {
                alias: alias,
                notify: notifications
            });
        } else {
            console.log("old user has changed settings, populating from changed fields")
            const user: WatchlistUser = watchlistUserFromSnapshot(data);

            alias = user.alias
            notifications = user.notify
        }
        
        const watchlistRef: admin.firestore.DocumentReference = firestore.doc(watchlistPath(watchlistId));

        console.log("about to complete write, watchlist: %s, user: %s...", watchlistId, ellipsifyUserId(userId))
        return transaction.update(watchlistRef, {
            ["users."+userId+".alias"] : alias,
            ["users."+userId+".notify"] : notifications,
        });
    });
});