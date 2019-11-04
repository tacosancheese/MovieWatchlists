import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/data/repos/user_repository.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/models/watchlist.dart';
import 'package:movie_watchlists/models/watchlist_movie.dart';
import 'package:movie_watchlists/models/watchlist_user.dart';
import 'package:movie_watchlists/shared/base_bloc.dart';
import 'package:rxdart/rxdart.dart';

class WatchlistDetailView extends Equatable {

  final ViewState viewState;
  final List<WatchlistMovie> items;
  final Exception error;

  WatchlistDetailView.error(final Exception e):
      viewState = ViewState.ERROR,
      items = null,
      error = e;

  WatchlistDetailView.loaded(final List<WatchlistMovie> movie):
      viewState = ViewState.LOADED,
      items = movie,
      error = null;

  WatchlistDetailView.loading():
      viewState = ViewState.LOADING,
      items = null,
      error = null;

  WatchlistDetailView.leave():
      viewState = ViewState.LEAVE_WATCHLIST,
      items = null,
      error = null;

  bool get hasError => viewState == ViewState.ERROR;
  bool get hasLeft => viewState == ViewState.LEAVE_WATCHLIST;
  bool get hasLoaded => viewState == ViewState.LOADED;
  bool get isLoading => viewState == ViewState.LOADING;
}

enum ViewState {
  LOADED,
  LOADING,
  ERROR,
  LEAVE_WATCHLIST
}

class WatchlistDetailBloc extends BaseBloc {

  final Sink<bool> _forceReload;
  final Sink<bool> _leaveWatchlist;
  final Sink<Watchlist> _watchlist;

  final Stream<WatchlistDetailView> view;

  WatchlistDetailBloc._({
    @required Sink<bool> forceReload,
    @required Sink<bool> leaveWatchlist,
    @required Sink<Watchlist> watchlist,
    @required this.view,
  }): this._forceReload = forceReload,
      this._leaveWatchlist = leaveWatchlist,
      this._watchlist = watchlist;

  factory WatchlistDetailBloc({
    @required final MovieRepository movieRepo,
    @required final UserRepository userRepo,
    @required final WatchlistRepository watchListRepo,
  }) {
    // ignore: close_sinks
    final forceReload = BehaviorSubject<bool>
      .seeded(false);

    // ignore: close_sinks
    final leaveWatchlist = BehaviorSubject<bool>
      .seeded(false);

    // ignore: close_sinks
    final watchlistSubj = BehaviorSubject<Watchlist>();

    // load movies
    final Observable<WatchlistDetailView> loadedState = watchlistSubj
      .flatMap((watchlist) => watchListRepo.findById(watchlist.id))
      .map((result) => result.result)
      .map((watchlist) => WatchlistDetailView.loaded(watchlist.movies.values.toList()))
      .startWith(WatchlistDetailView.loading());

    // leave watchlist
    final Observable<WatchlistDetailView> leaveState = leaveWatchlist
      .where((bool) => bool)
      .flatMap((_) => Observable.fromFuture(userRepo.getUser()))
      .map((result) => result.result) // TODO: error handling
      .flatMap((user) {
        final watchlists = user.watchlists;
        final watchlist = watchlistSubj.value;
        watchlists.removeWhere((element) => element.contains(watchlist.id));

        final future = userRepo.updateUser({
          FirebaseContract.FIELD_WATCHLISTS: user.watchlists
        });

        return Observable.fromFuture(future);
      })
      .doOnError((error) => debugPrint("error: $error"))
      .map((result) {
        if (result.hasError) {
          return WatchlistDetailView.error(result.exception);
        } else {
          return WatchlistDetailView.leave();
        }
      });

    // combined state
    final viewState = Observable.merge([loadedState, leaveState])
      .share();

    return WatchlistDetailBloc._(
      view: viewState,
      forceReload: forceReload,
      leaveWatchlist: leaveWatchlist,
      watchlist: watchlistSubj
    );
  }

  void reload() => _forceReload.add(true);
  void leave() => _leaveWatchlist.add(true);
  void setWatchlist(final Watchlist wl) => _watchlist.add(wl);

  @override
  void dispose() {
    _forceReload.close();
    _leaveWatchlist.close();
    _watchlist.close();
  }

}