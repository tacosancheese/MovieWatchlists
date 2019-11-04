import 'package:flutter/material.dart';
import 'package:movie_watchlists/blocs/watchlist_detail_bloc.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/data/repos/user_repository.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/models/watchlist.dart';
import 'package:movie_watchlists/views/watchlist_detail/watchlist_detail_app_bar.dart';
import 'package:movie_watchlists/widgets/warning_widget.dart';
import 'package:movie_watchlists/widgets/watchlist_movie_cell.dart';
import 'package:movie_watchlists/widgets/widget_factory.dart';
import 'package:provider/provider.dart';

class DetailWatchlistScreen extends StatefulWidget {

  static createRoute({
    @required final BuildContext ctx,
    @required final Watchlist watchlist
  }) {
    Navigator.push(ctx, MaterialPageRoute(
      builder: (context) {
        return DetailWatchlistScreen(
          watchlist: watchlist,
        );
      })
    );
  }

  final Watchlist watchlist;

  const DetailWatchlistScreen({
    Key key,
    @required this.watchlist
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() =>
    _DetailWatchlistViewState(watchlist: watchlist);
}

class _DetailWatchlistViewState extends State<DetailWatchlistScreen> {

  final Watchlist watchlist;
  WatchlistDetailBloc _bloc;

   _DetailWatchlistViewState({
    @required this.watchlist
  });

   @override
  void didChangeDependencies() {
     if (_bloc == null) {
       final movieRepo = Provider.of<MovieRepository>(context);
       final userRepo = Provider.of<UserRepository>(context);
       final watchlistRepo = Provider.of<WatchlistRepository>(context);

       _bloc = WatchlistDetailBloc(
         movieRepo: movieRepo,
         userRepo: userRepo,
         watchListRepo: watchlistRepo
       );
       _bloc.setWatchlist(watchlist);
     }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<WatchlistDetailBloc>(
      builder: (ctx) => _bloc,
      child: Scaffold(
        appBar: WatchlistDetailAppBar(
          title: watchlist.name
        ),
        body: StreamBuilder<WatchlistDetailView>(
          stream: _bloc.view,
          builder: (ctx, AsyncSnapshot<WatchlistDetailView> snapshot) {
            final view = snapshot.data;

            if (view == null) {
              debugPrint("view == null");
              return WidgetFactory.createProgressWidget();
            }

            if (view.isLoading) {
              debugPrint("isLoading");
              return WidgetFactory.createProgressWidget();
            }

            if (view.hasError) {
              debugPrint("hasError");
              return WidgetFactory.createRetryWidget(
                callback: () => _bloc.reload()
              );
            }

            if (view.hasLeft) {
              debugPrint("hasLeft => isFirst");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              });

              return WidgetFactory.createProgressWidget();
            }

            debugPrint("ready");
            final items = view.items;
            if (items.isEmpty) {
              return WarningWidget(
                title: "This watchlist is empty"
              );
            }

            return ListView.separated(
              itemBuilder: (ctx, int index) =>
                WatchlistMovieTextCell(items[index]),
              itemCount: items.length,
              separatorBuilder: (ctx, int) => Divider(color: Colors.black12),
            );
          }
        )
      )
    );
  }
}