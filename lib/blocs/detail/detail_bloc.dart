import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/repos/cast_repo.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/models/movie_details.dart';
import 'package:movie_watchlists/shared/base_bloc.dart';
import 'package:movie_watchlists/shared/result.dart';
import 'package:rxdart/rxdart.dart';

class DetailView extends Equatable {

  final ViewState viewState;
  final MovieDetails item;
  final Exception error;

  DetailView.error(final Exception e):
      viewState = ViewState.ERROR,
      item = null,
      error = e;

  DetailView.loaded(final MovieDetails movie):
      viewState = ViewState.LOADED,
      item = movie,
      error = null;

  DetailView.loading():
      viewState = ViewState.LOADING,
      item = null,
      error = null;

  bool get hasLoaded => viewState == ViewState.LOADED;
  bool get hasError => viewState == ViewState.ERROR;
  bool get isLoading => viewState == ViewState.LOADING;
}

enum ViewState {
  LOADED,
  LOADING,
  ERROR
}

// Detail bloc / view
class DetailBloc extends BaseBloc {

  final Stream<DetailView> detailView;

  final Sink<int> _movieId;
  final Sink<bool> _forceReload;

  DetailBloc._({
    @required Sink<int> movieId,
    @required Sink<bool> forceReload,
    @required this.detailView
  }): this._forceReload = forceReload, this._movieId = movieId;

  factory DetailBloc({
    final CastRepository castRepository,
    final MovieRepository movieRepository,
    final WatchlistRepository watchlistRepository
  }) {

    // ignore: close_sinks
    final reload = PublishSubject<bool>();

    // ignore: close_sinks
    final movieId = BehaviorSubject<int>();

    // Movies
    final Observable<bool> movieRefresh = reload
      .where((boolean) => boolean);

    final Observable<Result<MovieDetails, Exception>> movieStream =
      Observable.merge([Observable.just(true), movieRefresh])
      .flatMap((_) => movieId)
      .flatMap((movieId) => Observable.fromFuture(movieRepository.get(movieId)))
      .share();

    final Observable<DetailView> moviesLoading = Observable
      .merge([
        Observable.just(DetailView.loading()),
        movieRefresh.map((result) => DetailView.loading())
    ]);

    final Observable<DetailView> moviesLoaded = movieStream
      .where((response) => response.result != null)
      .map((response) => response.result)
      .map((result) => DetailView.loaded(result));

    final Observable<DetailView> moviesError = movieStream
      .where((response) => response.exception != null)
      .map((response) => response.exception)
      .map((exception) => DetailView.error((exception)));

    final Observable<DetailView> moviesCombined = Observable
      .merge([moviesLoading, moviesLoaded, moviesError])
      .onErrorResume((exception) => Observable.just(DetailView.error(exception)))
      .share();

    return DetailBloc._(
      forceReload: reload,
      movieId: movieId,
      detailView: moviesCombined,
    );
  }

  void refresh() => _forceReload.add(true);

  void movieId(final int movieId) =>
    _movieId.add(movieId);

  @override
  void dispose() {
    _forceReload.close();
    _movieId.close();
  }
}