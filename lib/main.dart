import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
import 'package:movie_watchlists/blocs/detail/detail_bloc.dart';
import 'package:movie_watchlists/blocs/login_bloc.dart';
import 'package:movie_watchlists/blocs/settings_bloc.dart';
import 'package:movie_watchlists/blocs/watchlist_create_bloc.dart';
import 'package:movie_watchlists/data/api/api_tmdb.dart';
import 'package:movie_watchlists/data/api/tmdb_user_config.dart';
import 'package:movie_watchlists/data/preferences/user_preferences.dart';
import 'package:movie_watchlists/data/repos/cast_repo.dart';
import 'package:movie_watchlists/data/repos/genre_repository.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/shared/package.dart';
import 'package:movie_watchlists/views/login/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/watchlist_detail_bloc.dart';
import 'data/auth/auth_handler.dart';
import 'data/repos/user_repository.dart';

void main() async {

  // firebase auth
  final AuthHandler handler = FirebaseAuthHandler(
    auth: FirebaseAuth.instance,
    signIn: GoogleSignIn()
  );

  final SharedPreferences prefs = await SharedPreferences
    .getInstance();

  // user preferences
  final userPrefs = UserPreferences(sharedPrefs: prefs);

  // api
  final api = ApiTmdb.create(
    client: Client(),
    userConfig: TmdbUserConfig(userPrefs: userPrefs)
  );

  final CastRepository castRepo = CastRepository(
    api: api
  );

  final GenreRepository genreRepo = GenreRepository(
    api: api
  );

  final MovieRepository movieRepo = MovieRepository(
    api: api
  );

  final UserRepository userRepo = UserRepository(
    firestore: Firestore.instance,
    handler: handler
  );

  final WatchlistRepository watchlistRepo = WatchlistRepository(
    firestore: Firestore.instance,
    handler: handler
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthHandler>(
          builder: (ctx) => handler,
        ),
        Provider<UserPreferences>(
          builder: (ctx) => userPrefs,
        ),
        Provider<Package>(
          builder: (ctx) => Package(),
        ),
        Provider<CastRepository>(
          builder: (ctx) => castRepo,
        ),
        Provider<GenreRepository>(
          builder: (ctx) => genreRepo,
        ),
        Provider<MovieRepository>(
          builder: (ctx) => movieRepo,
        ),
        Provider<UserRepository>(
          builder: (ctx) => userRepo,
        ),
        Provider<WatchlistRepository>(
          builder: (ctx) => watchlistRepo,
        ),
        Provider<LoginBloc>(
          dispose: (ctx, bloc) => bloc.dispose(),
          builder: (ctx) => LoginBloc(handler: handler),
        ),
        Provider<WatchlistDetailBloc>(
          dispose: (ctx, bloc) => bloc.dispose(),
          builder: (_) => WatchlistDetailBloc(
            movieRepo: movieRepo,
            userRepo: userRepo,
            watchListRepo: watchlistRepo
          ),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
        ),
        home: LoginScreen(),
      )
    )
  );
}
