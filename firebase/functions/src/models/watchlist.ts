import * as admin from 'firebase-admin' // Would be nicer to import only types
import 'reflect-metadata';

import { plainToClass, Type, classToPlain } from 'class-transformer';

import { WatchlistMovie } from './watchlist_movie'
import { WatchlistUser } from './watchlist_user'

export class Watchlist {
  
  readonly adult: boolean
  
  @Type(() => Map)
  readonly movies: Map<string, WatchlistMovie>;
  
  readonly name: string;

  readonly followerIds: string[]

  readonly ownerIds: string[]

  @Type(() => Map)
  readonly users: Map<string, WatchlistUser>;

  constructor(adult: boolean, movies: Map<string, WatchlistMovie>, 
    name: string, followerIds: string[], ownerIds: string[], users: Map<string, WatchlistUser>) {
    this.adult = adult;
    this.movies = movies;
    this.name = name;
    this.followerIds = followerIds;
    this.ownerIds = ownerIds;
    this.users = users;
  }
}

export function toWatchlist(snapshot: admin.firestore.DocumentSnapshot): Watchlist {
  const data = snapshot.data()!!;
  return plainToClass(Watchlist, data);
}

export function toPlain(watchlist: Watchlist): any {
  return {
      adult: watchlist.adult,
      movies: classToPlain(watchlist.movies),
      name: watchlist.name,
      followerIds: watchlist.followerIds,
      ownerIds: watchlist.ownerIds,
      users: classToPlain(watchlist.users)
  };
}