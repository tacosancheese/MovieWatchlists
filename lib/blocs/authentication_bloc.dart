import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_watchlists/data/auth/auth_handler.dart';
import 'package:movie_watchlists/shared/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

enum AuthenticationState {
  AUTHENTICATED, UNAUTHENTICATED, ERROR, LOADING
}

class AuthenticationView extends Equatable {

  final AuthenticationState state;
  final Exception error;

  AuthenticationView.error({@required final Exception exception}):
      state = AuthenticationState.ERROR,
      error = exception;

  AuthenticationView.authenticated({@required final AuthHandler handler}):
      state = AuthenticationState.AUTHENTICATED,
      error = null;

  AuthenticationView.unauthenticated():
      state = AuthenticationState.UNAUTHENTICATED,
      error = null;

  AuthenticationView.loading():
      state = AuthenticationState.LOADING,
      error = null;

  bool get hasAuthenticated => state == AuthenticationState.AUTHENTICATED;
  bool get isUnAuthenticated => state == AuthenticationState.UNAUTHENTICATED;
  bool get hasError => state == AuthenticationState.ERROR;
  bool get isLoading => state == AuthenticationState.LOADING;
}

class AuthenticationBloc extends BaseBloc {

  final Stream<AuthenticationView> authView;

  AuthenticationBloc._({
    @required Stream<AuthenticationView> authView
  }) : this.authView = authView;

  factory AuthenticationBloc ({
    @required final AuthHandler handler
  }) {
    // resume user session
    final Observable<AuthenticationView> authView =
      Observable.fromFuture(Future.value(AuthType.GOOGLE_FIREBASE))
        .map((authType) => authType)
        .flatMap((_) => Observable.fromFuture(handler.resume()))
        .delay(Duration(milliseconds: 500))
        .flatMap((result) {
        if (result.hasError) {
          if (result.exception is LoginRequiredException) {
            return Observable.just(AuthenticationView.unauthenticated());
          } else {
            return Observable.just(AuthenticationView.error(exception: result.exception));
          }
        }

        return Observable.just(AuthenticationView.authenticated(handler: handler));
      }).share();

    return AuthenticationBloc._(
      authView: authView
    );
  }

  @override
  void dispose() {

  }

}