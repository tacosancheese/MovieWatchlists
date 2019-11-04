import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_watchlists/data/auth/auth_handler.dart';
import 'package:movie_watchlists/shared/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class LoginState extends Equatable {
  final AuthHandler user;

  LoginState({@required this.user});
}

class LoginView extends Equatable {

  final LoginViewState _viewState;
  final LoginState state;
  final Exception error;

  LoginView.acceptedTerms()
      : _viewState = LoginViewState.TERMS_ACCEPTED,
        state = LoginState(user: null),
        error = null;

  LoginView.ready()
      : _viewState = LoginViewState.READY,
        state = LoginState(user: null),
        error = null;

  LoginView.error({@required final Exception exception})
      : _viewState = LoginViewState.ERROR,
        state = LoginState(user: null),
        error = exception;

  LoginView.loggedIn({@required final AuthHandler handler})
      : _viewState = LoginViewState.LOGGED_IN,
        state = LoginState(user: handler),
        error = null;

  LoginView.loading()
      : _viewState = LoginViewState.LOADING,
        state = LoginState(user: null),
        error = null;

  bool get hasAcceptedTerms => _viewState == LoginViewState.TERMS_ACCEPTED;

  bool get hasLoggedIn => _viewState == LoginViewState.LOGGED_IN;

  bool get hasError => _viewState == LoginViewState.ERROR;

  bool get isLoading => _viewState == LoginViewState.LOADING;

  @override
  String toString() {
    return _viewState.toString();
  }
}

enum LoginViewState { READY, LOADING, ERROR, TERMS_ACCEPTED, LOGGED_IN }

class LoginBloc extends BaseBloc {

  final Sink<AuthType> _onAuthTypeSelected;
  final Sink<bool> _onTermsChanged;

  final Stream<LoginView> view;

  LoginBloc._({
    @required this.view,
    @required Sink<AuthType> onAuthTypeSelected,
    @required Sink<bool> onTermsChanged}):
      this._onAuthTypeSelected = onAuthTypeSelected,
      this._onTermsChanged = onTermsChanged;

  // TODO: pass auth handler factory as param?
  factory LoginBloc({
    @required final AuthHandler handler
  }) {

    // ignore: close_sinks
    final PublishSubject<AuthType> onAuthSelected = PublishSubject<AuthType>();

    // ignore: close_sinks
    final BehaviorSubject<bool> onTermsChanged = BehaviorSubject
      .seeded(false);

    // trigger login if terms have been accepted
    final loginObservable = onAuthSelected
        .startWith(AuthType.NONE)
        .where((_) => onTermsChanged.value)
        .distinct()
        .debounceTime(Duration(milliseconds: 200));

    // resume user session
    final Observable<LoginView> resumeSession =
        Observable.fromFuture(Future.value(AuthType.GOOGLE_FIREBASE))
            .map((authType) => authType)
            .flatMap((_) => Observable.fromFuture(handler.resume()))
            .delay(Duration(milliseconds: 500))
            .flatMap((result) {
      if (result.hasError) {
        if (result.exception is LoginRequiredException) {
          return Observable.just(LoginView.ready());
        } else {
          return Observable.just(LoginView.error(exception: result.exception));
        }
      }

      return Observable.just(LoginView.loggedIn(handler: handler));
    }).share();

    // terms
    final Observable<LoginView> termsState = onTermsChanged
        .map((value) => value ? LoginView.acceptedTerms() : LoginView.ready())
        .skip(1);

    // login via Google
    final Observable<LoginView> loginState = loginObservable
        .where((type) => type == AuthType.GOOGLE_FIREBASE)
        .flatMap((_) => Observable.fromFuture(handler.signIn()))
        .map((result) {
      if (result.hasError) {
        return LoginView.error(exception: result.exception);
      }

      return LoginView.loggedIn(handler: handler);
    });

    // loading
    final Observable<LoginView> loadingState =
        loginObservable.map((_) => LoginView.loading());

    // combined state
    final Observable<LoginView> loginViewState =
        Observable.merge([loadingState, loginState]);

    final Observable<LoginView> viewState =
        Observable.merge([resumeSession, termsState, loginViewState])
            .doOnEach((view) => debugPrint(view.toString()))
            .startWith(LoginView.loading());

    return LoginBloc._(
        view: viewState,
        onAuthTypeSelected: onAuthSelected,
        onTermsChanged: onTermsChanged);
  }

  void onAuthTypeSelect(final AuthType authType) =>
      _onAuthTypeSelected.add(authType);

  void onTermsChange(final bool value) =>
    _onTermsChanged.add(value);

  @override
  void dispose() {
    _onAuthTypeSelected.close();
    _onTermsChanged.close();
  }
}
