import 'package:flutter/material.dart';
import 'package:movie_watchlists/blocs/watchlist_bloc.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/views/watchlist/watchlist_list_cell.dart';
import 'package:movie_watchlists/views/watchlist_create/watchlist_create_screen.dart';
import 'package:movie_watchlists/widgets/warning_widget.dart';
import 'package:movie_watchlists/widgets/widget_factory.dart';
import 'package:provider/provider.dart';

import 'watchlist_bar.dart';

class WatchlistScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _WatchlistState();
}

class _WatchlistState extends State<WatchlistScreen> {

  WatchlistBloc _bloc;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final watchlistRepo = Provider.of<WatchlistRepository>(context);
    _bloc = WatchlistBloc(
      watchlistRepository: watchlistRepo
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WatchlistBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => WatchlistCreateScreen.createRoute(context),
        child: Icon(Icons.add),
        backgroundColor: Palette.accent,
      ),
      body: StreamBuilder(
        stream: _bloc.view,
        builder: (ctx, AsyncSnapshot<WatchlistView> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return WidgetFactory.createProgressWidget();
          }

          final result = snapshot.data;
          if (result == null) {
            return WidgetFactory.createProgressWidget();
          }

          if (result.isLoading) {
            return WidgetFactory.createProgressWidget();
          }

          if (result.hasError) {
            return WidgetFactory.createRetryWidget(
              callback: () => _bloc.refresh());
          }

          final items = result.items;
          if (items.isEmpty) {
            return WarningWidget(
              title: "You don't have any watchlists"
            );
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (BuildContext ctx, index) =>
              WatchlistCell(
                watchlist: items[index]
              )
          );
        },
      )
    );
  }
}