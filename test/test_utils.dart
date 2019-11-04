import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_watchlists/data/api/api_tmdb.dart';
import 'package:movie_watchlists/data/api/tmdb_user_config.dart';
import 'package:movie_watchlists/data/auth/auth_handler.dart';
import 'package:movie_watchlists/data/preferences/user_preferences.dart';
import 'package:movie_watchlists/data/repos/cast_repo.dart';
import 'package:movie_watchlists/data/repos/genre_repository.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/shared/package.dart';

// Test resources
const String CAST_JSON_PATH = "test_resources/cast.json";
const String GENRE_JSON_PATH = "test_resources/genres.json";
const String MOVIE_DETAILS_JSON_PATH = "test_resources/movie_details.json";
const String MOVIES_JSON_PATH = "test_resources/movies.json";

// auth
class MockFirebaseAuth extends Mock implements FirebaseAuth {}
class MockGoogleSignIn extends Mock implements GoogleSignIn {}
class MockFirebaseUser extends Mock implements FirebaseUser {}
class MockGoogleSignInAccount extends Mock implements GoogleSignInAccount {}
class MockGoogleSignInAuthentication extends Mock implements GoogleSignInAuthentication {}

// firestore
class MockFirestore extends Mock implements Firestore {}
class MockCollectionReference extends Mock implements CollectionReference {}
class MockDocumentReference extends Mock implements DocumentReference {}
class MockQuery extends Mock implements Query {}
class MockQuerySnapshot extends Mock implements QuerySnapshot {}

// App related
class MockAuthHandler extends Mock implements AuthHandler {}
class MockApi extends Mock implements ApiTmdb {}
class MockCastRepo extends Mock implements CastRepository {}
class MockGenreRepo extends Mock implements GenreRepository {}
class MockMovieRepo extends Mock implements MovieRepository {}
class MockTmdbConfig extends Mock implements TmdbUserConfig {}
class MockPackage extends Mock implements Package {}
class MockUserPreferences extends Mock implements UserPreferences {}

// misc utils
Future<Map<String, dynamic>> readJsonStringFromFile(final String filePath) async {
  final file = new File(filePath);
  return json.decode(await file.readAsString());
}

Future<String> readStringFromFile(final String filePath) async {
  final file = new File(filePath);
  return await file.readAsString();
}