import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/models/watchlist.dart';
import 'package:movie_watchlists/shared/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class WatchlistView extends Equatable {

  final WatchlistViewState viewState;
  final List<Watchlist> items;
  final Exception error;

  WatchlistView.error(final Exception e):
      viewState = WatchlistViewState.ERROR,
      items = [],
      error = e;

  WatchlistView.loaded(final List<Watchlist> items):
      viewState = WatchlistViewState.LOADED,
      items = items,
      error = null;

  WatchlistView.loading():
      viewState = WatchlistViewState.LOADING,
      items = [],
      error = null;

  bool get hasLoaded => viewState == WatchlistViewState.LOADED;
  bool get hasError => viewState == WatchlistViewState.ERROR;
  bool get isLoading => viewState == WatchlistViewState.LOADING;
}

enum WatchlistViewState {
  LOADED,
  LOADING,
  ERROR
}

class WatchlistBloc extends BaseBloc {

  final Sink<bool> _forceReload;
  final Stream<WatchlistView> view;

  WatchlistBloc._({
    @required Sink<bool> forceReload,
    @required this.view,
  }):
    this._forceReload = forceReload;

  factory WatchlistBloc({
    @required final WatchlistRepository watchlistRepository}) {

    // ignore: close_sinks
    final reload = PublishSubject<bool>();

    final Observable<WatchlistView> observable = reload
      .startWith(true)
      .flatMap((_) => watchlistRepository.findAll())
      .map((result) {
        if (!result.hasError) {
          return WatchlistView.loaded(result.result);
        } else {
          return WatchlistView.error(result.exception);
        }
      })
      .startWith(WatchlistView.loading());

    return WatchlistBloc._(
      view: observable,
      forceReload: reload
    );
  }

  void refresh() =>
    _forceReload.add(true);

  @override
  void dispose() {
    _forceReload.close();
  }

}