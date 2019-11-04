import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:movie_watchlists/data/auth/auth_handler.dart';
import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/data/preferences/user_preferences.dart';
import 'package:movie_watchlists/data/repos/user_repository.dart';
import 'package:movie_watchlists/models/watchlist_user.dart';
import 'package:movie_watchlists/shared/base_bloc.dart';
import 'package:movie_watchlists/shared/package.dart';
import 'package:movie_watchlists/shared/result.dart';
import 'package:movie_watchlists/views/settings/settings.dart';
import 'package:rxdart/rxdart.dart';

// shown in UI
class Settings extends Equatable {

  final String appVersion;
  final GeneralSettings generalSettings;
  final UserSettings userSettings;
  final ContentSettings contentSettings;

  Settings({
    @required this.appVersion,
    @required this.generalSettings,
    @required this.userSettings,
    @required this.contentSettings,
  });
}

enum _UserEvent {
  LOGOUT, DELETE_ACCOUNT
}

// UI states
enum SettingsViewState {
  LOADED,
  LOADING,
  LOGGED_OUT,
  DELETED
}

// UI state enumeration which bloc subscribes
class SettingsView extends Equatable {

  final SettingsViewState viewState;
  final Settings settings;

  SettingsView.loaded(final Settings settings):
      viewState = SettingsViewState.LOADED,
      settings = settings;

  SettingsView.loading():
      viewState = SettingsViewState.LOADING,
      settings = null;

  SettingsView.loggedOut():
      viewState = SettingsViewState.LOGGED_OUT,
      settings = null;

  SettingsView.deletedAccount():
      viewState = SettingsViewState.DELETED,
      settings = null;

  bool get hasLoaded => viewState == SettingsViewState.LOADED;
  bool get isLoading => viewState == SettingsViewState.LOADING;
  bool get isLoggedOut => viewState == SettingsViewState.LOGGED_OUT;
  bool get isDeleted => viewState == SettingsViewState.DELETED;
}

class SettingsBloc extends BaseBloc {

  //output
  final Stream<SettingsView> viewState;

  //inputs
  final Sink<bool> _analyticsSubject;
  final Sink<String> _aliasSubject;
  final Sink<bool> _notificationSubject;
  final Sink<bool> _adultSubject;
  final Sink<bool> _highQualitySubject;
  final Sink<_UserEvent> _logoutSubject;
  final Sink<_UserEvent> _deleteSubject;

  SettingsBloc._({
    @required Sink<bool> analyticsSubject,
    @required Sink<String> aliasSubject,
    @required Sink<bool> notificationSubject,
    @required Sink<bool> adultSubject,
    @required Sink<bool> highQualitySubject,
    @required Sink<_UserEvent> logoutSubject,
    @required Sink<_UserEvent> deleteSubject,
    @required this.viewState
  }):
      this._analyticsSubject = analyticsSubject,
      this._aliasSubject = aliasSubject,
      this._notificationSubject = notificationSubject,
      this._adultSubject = adultSubject,
      this._highQualitySubject = highQualitySubject,
      this._logoutSubject = logoutSubject,
      this._deleteSubject = deleteSubject;

  factory SettingsBloc({
    @required final AuthHandler handler,
    @required final UserPreferences userPrefs,
    @required final Package package,
    @required final UserRepository userRepo,
  }) {

    // ignore: close_sinks
    final analyticsSubject = PublishSubject<bool>();

    // ignore: close_sinks
    final aliasSubject = PublishSubject<String>();

    // ignore: close_sinks
    final notificationSubject = PublishSubject<bool>();

    // ignore: close_sinks
    final adultSubject = PublishSubject<bool>();

    // ignore: close_sinks
    final highQualitySubject = PublishSubject<bool>();

    // ignore: close_sinks
    final logoutSubject = PublishSubject<_UserEvent>();

    // ignore: close_sinks
    final deleteSubject = PublishSubject<_UserEvent>();

    // read general settings
    final Observable<void> analyticsObservable = analyticsSubject
      .flatMap((value) => Observable.fromFuture(userPrefs.setAnalytics(value)));

    final Observable<void> generalSettings = Observable
      .merge([Observable.just(true), analyticsObservable])
      .map((value) => GeneralSettings(
        analytics: userPrefs.analytics,
        appTheme: ""
      ));

    // user settings
    final Observable<Result<WatchlistUser, Exception>> aliasObservable = aliasSubject
      .flatMap((value) => Observable.fromFuture(userRepo.updateUser({
        FirebaseContract.FIELD_ALIAS: value
      })));

    final Observable<Result<WatchlistUser, Exception>> notificationObservable = notificationSubject
      .flatMap((value) => Observable.fromFuture(userRepo.updateUser({
          FirebaseContract.FIELD_NOTIFICATIONS: value
        })));

    final Observable<UserSettings> userSettings = Observable
      .merge([Observable.just(true), aliasObservable, notificationObservable])
      .flatMap((value) => Observable.fromFuture(userRepo.getUser())
      .map((result) {
        if (result.hasResult) {
          final userResult = result.result;
          return UserSettings(
            alias: userResult.alias,
            notifications: userResult.notifications
          );
        } else {
          throw Exception(result.exception);
        }
      }));

    // content settings
    final Observable<void> adultObservable = adultSubject
      .flatMap((value) => Observable.fromFuture(userPrefs.setAdult(value)));

    final Observable<void> highQualityObservable = highQualitySubject
      .flatMap((value) => Observable.fromFuture(userPrefs.setHighQualityImages(value)));

    final Observable<ContentSettings> contentSettings = Observable
      .merge([Observable.just(true), adultObservable, highQualityObservable])
      .map((value) => ContentSettings(
        adultContent: userPrefs.adult,
        highQualityImages: userPrefs.highQualityImages
      ));

    // get app version
    final Observable<String> appVersion = Observable
      .fromFuture(package.appVersion());

    // logout
    final Observable<_UserEvent> logout = logoutSubject
      .where((value) => value == _UserEvent.LOGOUT)
      .map((_) => handler.logout())
      .map((_) => _UserEvent.LOGOUT);

    // duration added because after deleteUser token is still valid and gets redirected as logged in user
    final Observable<bool> deleteAccount = deleteSubject
      .where((value) => value == _UserEvent.DELETE_ACCOUNT)
      .map((_) => handler.deleteUser())
      .delay(Duration(seconds: 2))
      .map((_) => true);

    final Observable<SettingsView> deleteIndicator = deleteSubject
      .where((value) => value == _UserEvent.DELETE_ACCOUNT)
      .map((_) => SettingsView.loading());

    final Observable<SettingsView> accountObservable = Observable
      .merge([logout, deleteAccount])
      .map((value) => (value == _UserEvent.DELETE_ACCOUNT)
        ? SettingsView.deletedAccount() : SettingsView.loggedOut());

    final Observable<SettingsView> settingsObservable = Observable
      .combineLatest4(appVersion, generalSettings, userSettings, contentSettings,
        (version, general, user, content) => Settings(
          appVersion: version,
          generalSettings: general,
          contentSettings: content,
          userSettings: user
        ))
      .map((settings) => SettingsView.loaded(settings))
      .startWith(SettingsView.loading());

    final Observable<SettingsView> viewState = Observable
      .merge([accountObservable, deleteIndicator, settingsObservable]);

    // combine into viewstate
    return SettingsBloc._(
      adultSubject: adultSubject,
      analyticsSubject: analyticsSubject,
      aliasSubject: aliasSubject,
      highQualitySubject: highQualitySubject,
      notificationSubject: notificationSubject,
      logoutSubject: logoutSubject,
      deleteSubject: deleteSubject,
      viewState: viewState,
    );
  }

  // general settings
  void toggleAnalytics(final bool analytics) =>
    _analyticsSubject.add(analytics);

  void toggleAppTheme(final bool theme) =>
    debugPrint("toggleAppTheme $theme");

  // user settings
  void changeAlias(final String alias) =>
    _aliasSubject.add(alias);

  void toggleNotifications(final bool notifications) =>
    _notificationSubject.add(notifications);

  // content settings
  void toggleAdultContent(final bool adult) =>
    _adultSubject.add(adult);

  void toggleHighQualityContent(final bool content) =>
    _highQualitySubject.add(content);

  void logout() =>
    _logoutSubject.add(_UserEvent.LOGOUT);

  void deleteAccount() =>
    _deleteSubject.add(_UserEvent.DELETE_ACCOUNT);

  @override
  void dispose() {
    _analyticsSubject.close();
    _aliasSubject.close();
    _notificationSubject.close();
    _adultSubject.close();
    _highQualitySubject.close();
    _deleteSubject.close();
    _logoutSubject.close();
  }
}