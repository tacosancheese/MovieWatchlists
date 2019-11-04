
import * as functions from 'firebase-functions'
import firestore from './../../../db/db'

import { WatchlistMovie } from './../../../models/watchlist_movie'
import { watchlistPath } from '../../firebase_contract'

// copy content to main document
export const onContentCreated = functions
.firestore.document('watchlists/{watchlistId}/content/movies')
.onCreate(async (snapshot, context) => {
    const watchlistId = context.params.watchlistId;

    console.log("about to write, watchlistId: %s", watchlistId)
    const data = snapshot.data();
    
    if (data  == null) {
        return null;
    }
    
    const movies: Map<String, WatchlistMovie> = data.movies;
    if (movies === null) { // avoid infinite loop
        console.log("movies does not exist");
        return null;
    }
    
    console.log("about to complete write, watchlistId: %s", watchlistId)
    return firestore.doc(watchlistPath(watchlistId))
    .set({
        movies: movies
    }, {merge: true});
});