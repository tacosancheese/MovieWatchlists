import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_watchlists/blocs/detail/detail_watchlist_bloc.dart';
import 'package:movie_watchlists/data/repos/cast_repo.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/models/movie_details.dart';
import 'package:movie_watchlists/models/watchlist.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/widgets/warning_widget.dart';
import 'package:movie_watchlists/widgets/widget_factory.dart';
import 'package:provider/provider.dart';

class WatchlistsWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _WatchlistState();
}

class _WatchlistState extends State<WatchlistsWidget> {

  DetailWatchlistBloc _bloc;

  @override
  void didChangeDependencies() {
    if (_bloc == null) {
      _bloc = DetailWatchlistBloc(
        castRepository: Provider.of<CastRepository>(context),
        movieRepository: Provider.of<MovieRepository>(context),
        watchlistRepository: Provider.of<WatchlistRepository>(context),
        movieId: Provider.of<MovieDetails>(context).id,
      );
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext ctx) {
    final movieDetails = Provider.of<MovieDetails>(ctx);

    return StreamBuilder(
      stream: _bloc.watchlistView,
      builder: (BuildContext ctx, AsyncSnapshot<WatchlistView> snapshot) {
        if (snapshot == null || snapshot.data == null) {
          debugPrint("null or data null");
          return Container(
            height: 240,
            child: WidgetFactory.createProgressWidget(),
          );
        }

        final view = snapshot.data;
        if (view.isLoading) {
          debugPrint("isLoading");
          return Container(
            height: 240,
            child: WidgetFactory.createProgressWidget(),
          );
        }

        if (view.hasError) {
          return WidgetFactory.createRetryWidget(
            callback: () => _bloc.refresh()
          );
        }

        final watchlists = view.items;
        if (watchlists.isEmpty) {
          return Container(
            height: 240,
            child: WarningWidget(
              title: "You don't have any watchlists"
            )
          );
        }
        return Container(
          height: 240,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                color: Palette.grey,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(
                    left: 16, right: 16, top: 16, bottom: 16),
                  child: Text("Add movie to a watchlist",
                    maxLines: 1,
                    style: TextStyle(
                      color: Palette.white82,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500
                    )
                  )
                ),
              ),
              Container(
                height: 185,
                child: ListView.separated(
                  separatorBuilder: (ctx, index) =>
                    Divider(
                      color: Color(0xFF1b1b24),
                      height: 0.1,
                    ),
                  itemCount: watchlists.length,
                  itemBuilder: (BuildContext ctx, index) {
                    return _WatchlistCell(
                      bloc: _bloc,
                      movieDetails: movieDetails,
                      watchlist: watchlists[index],
                    );
                  }),
              )
            ],
          ),
        );
      });
  }
}

class _WatchlistCell extends StatelessWidget {

  final DetailWatchlistBloc bloc;
  final MovieDetails movieDetails;
  final Watchlist watchlist;

  const _WatchlistCell({
    Key key,
    this.bloc,
    this.movieDetails,
    this.watchlist
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return InkWell(
      onTap: () => watchlist.containsMovie(movieDetails.id.toString())
        ? bloc.remove(watchlist, movieDetails)
        : bloc.add(watchlist, movieDetails),
      child: Container(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Text(watchlist.name,
                  maxLines: 1,
                  style: TextStyle(
                    color: Palette.white82,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                  )
                ),
              ),
              Flexible(
                child: Icon(
                  watchlist.containsMovie(movieDetails.id.toString()) ? Icons.check : null,
                  color: Palette.accent,
                  size: 24,
                ),
              )
            ]
          )
        ),
      )
    );
  }
}