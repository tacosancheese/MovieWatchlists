import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/firebase_contract.dart';
import 'package:movie_watchlists/data/repos/cast_repo.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/models/movie_details.dart';
import 'package:movie_watchlists/models/watchlist.dart';
import 'package:movie_watchlists/shared/base_bloc.dart';
import 'package:movie_watchlists/shared/result.dart';
import 'package:rxdart/rxdart.dart';

enum ViewState {
  LOADED,
  LOADING,
  ERROR
}

class WatchlistView extends Equatable {

  final ViewState viewState;
  final List<Watchlist> items;
  final Exception error;

  WatchlistView.error(final Exception e):
      viewState = ViewState.ERROR,
      items = [],
      error = e;

  WatchlistView.loaded(final List<Watchlist> watchlists):
      viewState = ViewState.LOADED,
      items = watchlists,
      error = null;

  WatchlistView.loading():
      viewState = ViewState.LOADING,
      items = [],
      error = null;

  bool get hasLoaded => viewState == ViewState.LOADED;
  bool get hasError => viewState == ViewState.ERROR;
  bool get isLoading => viewState == ViewState.LOADING;
}

class DetailWatchlistBloc extends BaseBloc {

  final Stream<WatchlistView> watchlistView;

  final Sink<bool> _forceReload;
  final Sink<WatchlistAction> _watchlistAction;

  DetailWatchlistBloc._({
    @required Sink<bool> forceReload,
    @required Sink<WatchlistAction> watchlistAction,
    @required this.watchlistView,
  }): this._forceReload = forceReload, this._watchlistAction = watchlistAction;

  factory DetailWatchlistBloc({
    final CastRepository castRepository,
    final MovieRepository movieRepository,
    final WatchlistRepository watchlistRepository,
    final int movieId
  }) {
    // ignore: close_sinks
    final reload = PublishSubject<bool>();

    // ignore: close_sinks
    final watchlistAction = PublishSubject<WatchlistAction>();

    // Watchlist
    final addAction = watchlistAction
      .where((action) => action is AddAction)
      .cast<AddAction>()
      .doOnEach((value) => debugPrint("val $value"))
      .flatMap((action) => Observable.fromFuture(watchlistRepository.update(
      action.watchlist.id,
      action.toMap()
    )).startWith(Result.success(false)));

    final removeAction = watchlistAction
      .where((action) => action is RemoveAction)
      .cast<RemoveAction>()
      .doOnEach((value) => debugPrint("val $value"))
      .flatMap((action) => Observable.fromFuture(watchlistRepository.update(
      action.watchlist.id,
      action.toMap())
    )).startWith(Result.success(false));

    final watchlistActions = Observable.merge([addAction, removeAction]);

    final Observable<WatchlistView> watchlistCombined = Observable
      .zip2(watchlistRepository.findAll(), watchlistActions, (result, actions) {
      return result;
    })
      .map((result) => WatchlistView.loaded(result.result))
      .startWith(WatchlistView.loading())
      .shareReplay(maxSize: 1);

    return DetailWatchlistBloc._(
      forceReload: reload,
      watchlistAction: watchlistAction,
      watchlistView: watchlistCombined
    );
  }

  @override
  void dispose() {
    _forceReload.close();
    _watchlistAction.close();
  }

  void refresh() => _forceReload.add(true);

  void add(final Watchlist watchlist, final MovieDetails movie) {
    debugPrint("about to add ${movie.id}");
    _watchlistAction.add(AddAction(
      movie: movie,
      watchlist: watchlist
    ));
  }

  void remove(final Watchlist watchlist, final MovieDetails movie) {
    debugPrint("about to remove ${movie.id}");
    _watchlistAction.add(RemoveAction(
      movie: movie,
      watchlist: watchlist
    ));
  }
}

// Watchlist actions
abstract class WatchlistAction {
  Map<String, dynamic> toMap();
}

class AddAction extends Equatable implements WatchlistAction{
  final MovieDetails movie;
  final Watchlist watchlist;

  AddAction({
    @required this.movie,
    @required this.watchlist
  });

  Map<String, dynamic> toMap() {
    final Map<String, Map<String, dynamic>> movies = watchlist.movies
      .map((key, value) => MapEntry(key, value.toSnapshot()));

    final newMovie = {
      FirebaseContract.FIELD_ID: movie.id,
      FirebaseContract.FIELD_ADDED_BY: "Yoo",
      FirebaseContract.FIELD_MOVIE_GENRES: movie.genres.map((genre) => genre.name).toList(),
      FirebaseContract.FIELD_MOVIE_OVERVIEW: movie.overview,
      FirebaseContract.FIELD_MOVIE_POSTER_URL: movie.posterPath,
      FirebaseContract.FIELD_MOVIE_TITLE: movie.title,
      FirebaseContract.FIELD_WATCHED_BY: ["Yoo"]
    };

    movies.putIfAbsent(movie.id.toString(), () => newMovie);
    return movies;
  }
}

class RemoveAction extends Equatable implements WatchlistAction{
  final MovieDetails movie;
  final Watchlist watchlist;

  RemoveAction({
    @required this.movie,
    @required this.watchlist
  });

  Map<String, dynamic> toMap() =>  watchlist.movies
    .map((key, value) => MapEntry(key, value.toSnapshot()))
    ..removeWhere((key, _) => key == movie.id.toString());
}