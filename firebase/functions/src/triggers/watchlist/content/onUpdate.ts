
import * as functions from 'firebase-functions'
import firestore from './../../../db/db'

import { WatchlistMovie } from './../../../models/watchlist_movie'
import { watchlistPath } from '../../firebase_contract'

// copy content to main document
export const onContentUpdated = functions
.firestore.document('watchlists/{watchlistId}/content/movies')
.onUpdate(async (change, context) => {
    const watchlistId = context.params.watchlistId;

    console.log("about to write, watchlistId: %s", watchlistId)
    const data = change.after.data();
    const oldData = change.before.data();
    
    if (data  == null || oldData == null) {
        return null;
    }
    
    const movies: Map<String, WatchlistMovie> = data.movies;
    const oldMovies:  Map<String, WatchlistMovie> = oldData.movies;
    if (movies === null || oldMovies === null) { // avoid infinite loop
        console.log("movies or oldMovies does not exist");
        return null;
    }
    
    // TODO: check if user has seen the movie
    console.log("movies %s", JSON.stringify(movies))
    console.log("oldMovies %s", JSON.stringify(oldMovies))
    console.log("about to complete write, watchlistId: %s", watchlistId)
    return firestore.doc(watchlistPath(watchlistId))
    .update({
        movies: movies
    });
});