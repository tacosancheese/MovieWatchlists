import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/shared/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class WatchlistSettings extends Equatable {

  final bool adultContent;
  final bool notifications;
  final String watchlistName;

  WatchlistSettings({
    @required this.adultContent,
    @required this.notifications,
    @required this.watchlistName
  });

  bool get adult => adultContent ? adultContent : false;
  bool get notification => notifications ? notifications : false;
  String get name => watchlistName.isNotEmpty ? watchlistName : "";
}

class CreateView extends Equatable {

  final CreateViewState viewState;
  final WatchlistSettings settings;
  final Exception error;

  CreateView.ready(final WatchlistSettings settings):
      viewState = CreateViewState.READY,
      settings = settings,
      error = null;

  CreateView.valid(final WatchlistSettings settings):
      viewState = CreateViewState.VALID,
      settings = settings,
      error = null;

  CreateView.error(final WatchlistSettings settings, final Exception e):
      viewState = CreateViewState.ERROR,
      settings = settings,
      error = e;

  CreateView.saved(final WatchlistSettings settings):
      viewState = CreateViewState.SAVED,
      settings = settings,
      error = null;

  CreateView.loading():
      viewState = CreateViewState.LOADING,
      settings = null,
      error = null;

  bool get isReady => viewState == CreateViewState.READY;
  bool get isValid => viewState == CreateViewState.VALID;
  bool get isSaved => viewState == CreateViewState.SAVED;
  bool get hasError => viewState == CreateViewState.ERROR;
  bool get isLoading => viewState == CreateViewState.LOADING;
}

enum CreateViewState {
  READY,
  VALID,
  LOADING,
  ERROR,
  SAVED
}

class WatchListCreateBloc extends BaseBloc {

  final Stream<CreateView> view;

  final Sink<bool> _enableAdult;
  final Sink<bool> _enableNotifications;
  final Sink<String> _watchListName;
  final Sink<void> _save;

  WatchListCreateBloc._({
    @required Sink<bool> enableAdult,
    @required Sink<bool> enableNotifications,
    @required Sink<String> watchListName,
    @required Sink<void> save,
    @required this.view,
  }):
    this._enableAdult = enableAdult,
    this._enableNotifications = enableNotifications,
    this._watchListName = watchListName,
    this._save = save;

  factory WatchListCreateBloc(final WatchlistRepository repo) {

    // ignore: close_sinks
    final enableAdult = PublishSubject<bool>();

    // ignore: close_sinks
    final enableNotifications = PublishSubject<bool>();

    // ignore: close_sinks
    final nameInput = PublishSubject<String>();

    // ignore: close_sinks
    final saveAction = PublishSubject<void>();

    final Observable<WatchlistSettings> settings = Observable
      .combineLatest3(
        enableAdult.startWith(false).doOnEach((value) => debugPrint("enableAdult")),
        enableNotifications.startWith(false).doOnEach((value) => debugPrint("enableNotifications")),
        nameInput.startWith("").doOnEach((value) => debugPrint("nameInput")),
        (adult, notification, name) {
          debugPrint("name: $name");
          return WatchlistSettings(
            adultContent: adult,
            notifications: notification,
            watchlistName: name
          );
        })
      .share();

    // save
    final Observable<CreateView> readyState = settings
      .where((settings) => settings.name.length < 1)
      .map((settings) => CreateView.ready(settings));

    final Observable<CreateView> invalidState = settings
      .where((settings) => settings.name.isNotEmpty)
      .where((settings) => settings.name.length >= 1)
      .where((settings) => settings.name.length <= 3)
      .map((settings) =>  CreateView.error(settings, Exception()));

    final Observable<CreateView> validState = settings
      .where((settings) => settings.name.isNotEmpty)
      .where((settings) => settings.name.length > 3)
      .map((settings) =>  CreateView.valid(settings));

    final Observable<CreateView> inputState = Observable
      .merge([readyState, invalidState, validState]);

    final Observable<CreateView> saveState = saveAction
      .withLatestFrom(settings, (_, settings) => settings)
      .where((settings) => settings.name.length > 3)
      .flatMap((settings) => Observable.concat([
        Observable.just(CreateView.loading()),
        Observable.fromFuture(repo.create(settings))
          .delay(Duration(seconds: 1))
          .map((_) => CreateView.saved(settings))
      ])
    );

    final Observable<CreateView> viewState = Observable
      .merge([inputState, saveState])
      .share();

    return WatchListCreateBloc._(
      enableAdult: enableAdult,
      enableNotifications: enableNotifications,
      save: saveAction,
      watchListName: nameInput,
      view: viewState,
    );
  }

  void toggleAdult(final bool adult) =>
    _enableAdult.add(adult);

  void enableNotifications(final bool notification) =>
    _enableNotifications.add(notification);

  void save() =>
    _save.add(true);

  void changeName(final String name) =>
    _watchListName.add(name);

  @override
  void dispose() {
    _enableAdult.close();
    _enableNotifications.close();
    _save.close();
    _watchListName.close();
  }
}