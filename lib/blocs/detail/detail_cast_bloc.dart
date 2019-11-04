import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/data/repos/cast_repo.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/models/cast.dart';
import 'package:movie_watchlists/shared/base_bloc.dart';
import 'package:movie_watchlists/shared/result.dart';
import 'package:rxdart/rxdart.dart';

enum ViewState {
  LOADED,
  LOADING,
  ERROR
}

class CastView extends Equatable {

  final ViewState viewState;
  final List<Cast> items;
  final Exception error;

  CastView.error(final Exception e):
      viewState = ViewState.ERROR,
      items = [],
      error = e;

  CastView.loaded(final List<Cast> casts):
      viewState = ViewState.LOADED,
      items = casts,
      error = null;

  CastView.loading():
      viewState = ViewState.LOADING,
      items = [],
      error = null;

  bool get hasLoaded => viewState == ViewState.LOADED;
  bool get hasError => viewState == ViewState.ERROR;
  bool get isLoading => viewState == ViewState.LOADING;
}

class DetailCastBloc extends BaseBloc {

  final Stream<CastView> castView;

  final Sink<bool> _forceReload;

  DetailCastBloc._({
    @required Sink<bool> forceReload,
    @required this.castView,
  }): this._forceReload = forceReload;

  factory DetailCastBloc({
    final CastRepository castRepository,
    final MovieRepository movieRepository,
    final WatchlistRepository watchlistRepository,
    final int movieId
  }) {
    // ignore: close_sinks
    final reload = PublishSubject<bool>();

    final Observable<Result<List<Cast>, Exception>> castStream = Observable
      .merge([Observable.just(true), reload])
      .map((_) => movieId)
      .flatMap((movieId) => Observable.fromFuture(castRepository.getCast(movieId)))
      .share();

    final Observable<CastView> castLoaded = castStream
      .where((response) => response.result != null)
      .map((response) => response.result)
      .map((result) => CastView.loaded(result));

    final Observable<CastView> castError = castStream
      .where((response) => response.exception != null)
      .map((response) => response.exception)
      .map((exception) => CastView.error((exception)));

    final Observable<CastView> castLoading = Observable
      .just(CastView.loading());

    final Observable<CastView> castView = Observable
      .merge([castLoading, castLoaded, castError])
      .onErrorResume((exception) => Observable.just(CastView.error(exception)))
      .share();

    return DetailCastBloc._(
      castView: castView,
      forceReload: reload
    );
  }

  @override
  void dispose() {
    _forceReload.close();
  }

  void refresh() => _forceReload.add(true);
}