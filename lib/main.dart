import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';
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

import 'blocs/authentication_bloc.dart';
import 'data/auth/auth_handler.dart';
import 'data/repos/user_repository.dart';
import 'views/home/home_screen.dart';
import 'widgets/widget_factory.dart';

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

  final AuthenticationBloc authBloc = AuthenticationBloc(
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
        Provider<AuthenticationBloc>(
          builder: (ctx) => authBloc,
          dispose: (ctx, bloc) => bloc.dispose(),
        )
      ],
      child: MaterialApp(
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.black,
        ),
        home:_AuthenticationView()
      ),
    )
  );
}

class _AuthenticationView extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {
    final authBloc = Provider.of<AuthenticationBloc>(ctx);

    return Scaffold(
      body: StreamBuilder(
        builder: (ctx, AsyncSnapshot<AuthenticationView> snapshot) {
          if (snapshot == null || snapshot.data == null) {
            return WidgetFactory.createProgressWidget();
          }

          final view = snapshot.data;
          if (view.isLoading) {
            debugPrint("AuthenticationView => isLoading");
            return WidgetFactory.createProgressWidget();
          }

          if (view.hasError || view.isUnAuthenticated) {
            debugPrint("AuthenticationView => "
              "hasError || view.isUnAuthenticated");
            return LoginScreen();
          }

          debugPrint("AuthenticationView => HomeScreen");
          WidgetsBinding.instance.addPostFrameCallback((_) {
            HomeScreen.createRoute(ctx);
          });

          return WidgetFactory.createProgressWidget();
        },
        stream: authBloc.authView
      ),
    );
  }
}