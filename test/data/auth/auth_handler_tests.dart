import 'package:firebase_auth/firebase_auth.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_watchlists/data/auth/auth_handler.dart';
import 'package:movie_watchlists/shared/result.dart';
import 'package:test/test.dart';

import '../../test_utils.dart';

main() {

  test('should logout with FirebaseAuthHandler', () async {
    final auth =  MockFirebaseAuth();

    final authHandler = FirebaseAuthHandler(
      auth: auth,
      signIn: MockGoogleSignIn()
    );

    when(auth.signOut())
      .thenAnswer((_) => Future.value(null));

    await authHandler.logout();
    verify(auth.signOut()).called(1);
    verifyNoMoreInteractions(auth);
  });

  test('resume with FirebaseAuthHandler should return a user when user is found', () async {
    final auth =  MockFirebaseAuth();

    final authHandler = FirebaseAuthHandler(
      auth: auth,
      signIn: MockGoogleSignIn()
    );

    final mockUser = MockFirebaseUser();
    when(auth.currentUser())
      .thenAnswer((_) => Future.value(mockUser));

    Result<FirebaseUser, Exception> result = await authHandler.resume();
    expect(result.result, isNotNull);
    expect(result.result, TypeMatcher<MockFirebaseUser>());

    verify(auth.currentUser()).called(1);
    verifyNoMoreInteractions(auth);
  });

  test('resume with FirebaseAuthHandler should return exception when no user is found', () async {
    final auth =  MockFirebaseAuth();

    final authHandler = FirebaseAuthHandler(
      auth: auth,
      signIn: MockGoogleSignIn()
    );

    when(auth.currentUser())
      .thenAnswer((_) => Future.value(null));

    Result<FirebaseUser, Exception> result = await authHandler.resume();
    expect(result.exception, isNotNull);
    expect(result.exception, TypeMatcher<LoginRequiredException>());

    verify(auth.currentUser()).called(1);
    verifyNoMoreInteractions(auth);
  });

  // TODO: "all" paths
  test('should sign in with FirebaseAuthHandler and return a user', () async {

  });
}