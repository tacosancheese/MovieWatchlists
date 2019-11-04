import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_watchlists/blocs/detail/detail_bloc.dart';
import 'package:movie_watchlists/data/repos/cast_repo.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/models/movie_details.dart';
import 'package:movie_watchlists/widgets/widget_factory.dart';
import 'package:provider/provider.dart';

import 'movie_details_content_widget.dart';

class MovieDetailsScreen extends StatefulWidget {

  static createRoute(final BuildContext ctx, final int movieId) {
    Navigator.push(ctx, MaterialPageRoute(
      builder: (context) => MovieDetailsScreen(movieId: movieId))
    );
  }

  final int _movieId;

  MovieDetailsScreen({Key key, final int movieId}):
      this._movieId = movieId, super(key: key);

  @override
  State<StatefulWidget> createState() =>  _DetailState(movieId: _movieId);
}

class _DetailState extends State<MovieDetailsScreen> {

  final int _movieId;
  DetailBloc _bloc;

  _DetailState({
    Key key,
    int movieId
  }) : this._movieId = movieId;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_bloc == null) {
      _bloc = DetailBloc(
        castRepository: Provider.of<CastRepository>(context),
        movieRepository: Provider.of<MovieRepository>(context),
        watchlistRepository: Provider.of<WatchlistRepository>(context)
      );
      _bloc.movieId(_movieId);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<DetailBloc>(
          builder: (ctx) => _bloc,
        ),
        Provider<int>(
          builder: (ctx) => _movieId,
        )
      ],
      child: Scaffold(
        body: StreamBuilder(
          stream: _bloc.detailView,
          builder: (ctx, AsyncSnapshot<DetailView> snapshot) {
            if (snapshot == null || snapshot.data == null) {
              return WidgetFactory.createProgressWidget();
            }

            final view = snapshot.data;
            if (view.isLoading) {
              return WidgetFactory.createProgressWidget();
            }

            if (view.hasError) {
              return WidgetFactory.createRetryWidget(
                callback: () => _bloc.refresh()
              );
            }

            return Provider<MovieDetails>(
              builder: (ctx) => view.item,
              child: DiscoveryContentWidget(),
            );
          }
        )
      ),
    );
  }
}