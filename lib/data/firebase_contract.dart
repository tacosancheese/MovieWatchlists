abstract class FirebaseContract {

  // watchlist related
  static const COLLECTION_WATCHLISTS = "watchlists";
  static const COLLECTION_CONTENT = "content";
  static const COLLECTION_SETTINGS = "settings";
  static const COLLECTION_USER_SETTINGS = "user_settings";
  static const COLLECTION_USERS = "users";
  static const COLLECTION_MOVIES = "movies";

  static String watchlistPath(final String watchlistId)
    => "$COLLECTION_WATCHLISTS/$watchlistId";

  static String watchlistMoviesPath(final String watchlistId)
    => "$COLLECTION_WATCHLISTS/$watchlistId/$COLLECTION_CONTENT/$COLLECTION_MOVIES";

  // shared
  static const FIELD_ID = "id";
  static const GENERAL_ID = "general";
  static const MOVIES_ID = "movies";

  // counters
  static const FIELD_COUNT = "count";

  // by
  static const FIELD_ADDED_BY = "addedBy";
  static const FIELD_WATCHED_BY = "watchedBy";

  // common(ish)
  static const FIELD_ADULT = "adult";
  static const FIELD_ALIAS = "alias";
  static const FIELD_FOLLOWER_IDS = "followerIds";
  static const FIELD_MODIFY = "modify";
  static const FIELD_MOVIES = "movies";
  static const FIELD_NAME = "name";
  static const FIELD_NOTIFICATIONS = "notifications";
  static const FIELD_NOTIFY = "notify";
  static const FIELD_OWNER_IDS = "ownerIds";
  static const FIELD_ROLE = "role";
  static const FIELD_USER_IDS = "userIds";
  static const FIELD_USERS = "users";
  static const FIELD_WATCHED = "watched";
  static const FIELD_WATCHLISTS = "watchlists";

  static const FIELD_VALUE_OWNER = "owner";
  static const FIELD_VALUE_USER = "user";

  // movie
  static const FIELD_MOVIE_TITLE = "title";
  static const FIELD_MOVIE_OVERVIEW = "overview";
  static const FIELD_MOVIE_POSTER_URL = "posterPathUrl";
  static const FIELD_MOVIE_BACKDROP_URL = "backdropPathUrl";
  static const FIELD_MOVIE_GENRES = "genres";
}
