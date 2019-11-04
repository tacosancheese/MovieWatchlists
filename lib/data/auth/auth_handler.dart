import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:movie_watchlists/shared/result.dart';

class LoginRequiredException implements Exception {
  final String cause;

  LoginRequiredException(this.cause);
}

enum AuthType{
  NONE, GOOGLE_FIREBASE
}

abstract class AuthHandler<T, T1> {
  Future<Result<T, Exception>> currentUser();
  Future<Result<T1, Exception>> logout();
  Future<Result<T, Exception>> signIn();
  Future<Result<T, Exception>> resume();
  Future<Result<T1, Exception>> deleteUser();
}

class FirebaseAuthHandler extends AuthHandler<FirebaseUser, void> {

  final FirebaseAuth _auth;
  final GoogleSignIn _signIn;

  FirebaseAuthHandler({
    @required final FirebaseAuth auth,
    @required final GoogleSignIn signIn
  }): this._auth = auth, this._signIn = signIn;

  @override
  Future<Result<FirebaseUser, Exception>> currentUser() async {
    debugPrint("FirebaseAuthHandler => about to retrieve currentUser");
    return resume();
  }

  @override
  Future<Result<void, Exception>> logout() async {
    debugPrint("FirebaseAuthHandler => about to logout");
    final result = await _auth.signOut();
    return Result.success(result);
  }

  @override
  Future<Result<FirebaseUser, Exception>> resume() async {
    debugPrint("FirebaseAuthHandler => about to resume");
    final FirebaseUser user = await _auth.currentUser();
    if (user == null) {
      return Result.failure(LoginRequiredException("Signed-in user not found"));
    }

    return Result.success(user);
  }

  Future<Result<FirebaseUser, Exception>> signIn() async {
    debugPrint("FirebaseAuthHandler => about to signIn");
    final GoogleSignInAccount googleUser = await _signIn.signIn();
    if (googleUser == null) {
      return Result.failure(Exception("TODO")); // TODO: handle exceptions
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final AuthResult result = (await _auth.signInWithCredential(credential));
    final FirebaseUser user = result.user;
    if (user == null) {
      return Result.failure(Exception("TODO")); // TODO: handle exceptions
    }

    debugPrint("FirebaseAuthHandler => signed in " + user.displayName);
    return Result.success(user);
  }

  // TODO: unable to delete user: PlatformException(ERROR_REQUIRES_RECENT_LOGIN, This operation is sensitive and requires recent authentication. Log in again before retrying this request., null)
  @override
  Future<Result<void, Exception>> deleteUser() async {
    debugPrint("FirebaseAuthHandler => about to delete a user");
    try {
      final user = await signIn();
      return Result.success(await user.result.delete());
    } catch (e) {
      debugPrint("FirebaseAuthHandler => unable to delete user: $e");
      return Result.failure(e);
    }
  }
}