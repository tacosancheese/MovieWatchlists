import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:movie_watchlists/models/genre.dart';
import 'package:movie_watchlists/models/movie.dart';
import 'package:movie_watchlists/models/movie_.dart';
import 'package:movie_watchlists/models/movie_selection.dart';
import 'package:movie_watchlists/data/repos/genre_repository.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/shared/base_bloc.dart';
import 'package:movie_watchlists/shared/result.dart';
import 'package:rxdart/rxdart.dart';

class DiscoveryView extends Equatable {

  final DiscoveryViewState viewState;
  final List<Movie> items;
  final Exception error;

  DiscoveryView.error(final Exception e):
        viewState = DiscoveryViewState.ERROR,
        items = [],
        error = e;

  DiscoveryView.loaded(final List<Movie> movies):
        viewState = DiscoveryViewState.LOADED,
        items = movies,
        error = null;

  DiscoveryView.loading():
        viewState = DiscoveryViewState.LOADING,
        items = [],
        error = null;

  bool get hasLoaded => viewState == DiscoveryViewState.LOADED;
  bool get hasError => viewState == DiscoveryViewState.ERROR;
  bool get isLoading => viewState == DiscoveryViewState.LOADING;
}

enum DiscoveryViewState {
  LOADED,
  LOADING,
  ERROR
}

class DiscoveryBloc extends BaseBloc {

  final Sink<bool> _forceReload;
  final Sink<MovieSelection> _selection;
  final Stream<DiscoveryView> view;

  DiscoveryBloc._({
    @required Sink<bool> forceReload,
    @required Sink<MovieSelection> selection,
    @required this.view
  }): this._forceReload = forceReload, this._selection = selection;

  factory DiscoveryBloc(final MovieRepository movieRepo,
                        final GenreRepository genreRepo) {

    // ignore: close_sinks
    final selection = BehaviorSubject
      .seeded(MovieSelection.POPULAR);

    // selection type
    final Observable<MovieSelection> selectionStream = selection
      .startWith(MovieSelection.POPULAR)
      .debounceTime(Duration(milliseconds: 150))
      .distinct();

    // ignore: close_sinks
    final forceReload = BehaviorSubject<bool>();

    // retry
    final Observable<MovieSelection> retryStream = forceReload
      .where((bool) => bool)
      .flatMap((_) => selection)
      .share();

    // trigger(s) to load items
    final Observable<MovieSelection> trigger = Observable
      .merge([retryStream, selectionStream])
      .share();

    // load content and combine
    final Observable<DiscoveryView> combined = trigger
      .debounce((_) => TimerStream(true, Duration(milliseconds: 800)))
      .switchMap((selection) => Observable.combineLatest2(
        Observable.fromFuture(movieRepo.all(selection)),
        Observable.fromFuture(genreRepo.all()),
          (first, second) => _combineResults(first, second))
      );

    // loading
    final Observable<DiscoveryView> loading = trigger
      .map((_) => DiscoveryView.loading());

    final Observable<DiscoveryView> viewState = Observable.merge([combined, loading])
      .onErrorResume((exception) => Observable.just(DiscoveryView.error(exception)));

    return DiscoveryBloc._(
      forceReload: forceReload,
      selection: selection,
      view: viewState
    );
  }

  static DiscoveryView _combineResults(
    final Result<List<Movie_>, Exception> movieResult,
    final Result<List<Genre>, Exception> genreResult) {
    if (movieResult.hasError) {
      return DiscoveryView.error(movieResult.exception);
    }

    if (genreResult.hasError) {
      return DiscoveryView.error(genreResult.exception);
    }

    return DiscoveryView.loaded(
      Movie.toMovies(movieResult.result, genreResult.result)
    );
  }

  void changeSelection(final MovieSelection selection)
    => _selection.add(selection);

  void refresh() =>
    _forceReload.add(true);

  @override
  void dispose() {
    debugPrint("dispose");
    _forceReload.close();
    _selection.close();
  }
}