import 'package:flutter/material.dart';
import 'package:movie_watchlists/blocs/discovery_bloc.dart';
import 'package:movie_watchlists/data/repos/genre_repository.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/widgets/movie_list_cell.dart';
import 'package:movie_watchlists/widgets/widget_factory.dart';
import 'package:provider/provider.dart';

import 'discovery_bar.dart';

class DiscoveryScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen> {
  DiscoveryBloc _bloc;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if (_bloc == null) {
      final movieRepo = Provider.of<MovieRepository>(context);
      final genreRepo = Provider.of<GenreRepository>(context);
      _bloc = DiscoveryBloc(movieRepo, genreRepo);
      debugPrint("didChangeDependencies");
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext ctx) {
    return Provider<DiscoveryBloc>(
      builder: (ctx) => _bloc,
      child: Scaffold(
          appBar: DiscoveryBar(),
          body: StreamBuilder<DiscoveryView>(
            stream: _bloc.view,
            builder: (ctx, AsyncSnapshot<DiscoveryView> snapshot) {
              if (snapshot == null || snapshot.data == null) {
                return WidgetFactory.createProgressWidget();
              }

              final view = snapshot.data;
              if (view.isLoading) {
                return WidgetFactory.createProgressWidget();
              }

              if (view.hasError) {
                return WidgetFactory.createRetryWidget(
                    callback: () => _bloc.refresh());
              }

              final items = view.items;
              return ListView.separated(
                itemBuilder: (ctx, int index) => MovieTextCell(items[index]),
                itemCount: items.length,
                separatorBuilder: (ctx, int) => Divider(color: Colors.black12),
              );
            },
          )
      ),
    );
  }
}
