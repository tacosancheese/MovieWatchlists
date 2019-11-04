import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_watchlists/blocs/detail/detail_cast_bloc.dart';
import 'package:movie_watchlists/data/repos/cast_repo.dart';
import 'package:movie_watchlists/data/repos/movie_repository.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/views/search/search_screen.dart';
import 'package:movie_watchlists/widgets/cast_list.dart';
import 'package:movie_watchlists/widgets/widget_factory.dart';
import 'package:provider/provider.dart';

import 'movie_section_title_widget.dart';

class MovieCastWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CastState();
}

class _CastState extends State<MovieCastWidget> {

  DetailCastBloc _bloc;

  @override
  void didChangeDependencies() {
    if (_bloc == null) {
      _bloc = DetailCastBloc(
        castRepository: Provider.of<CastRepository>(context),
        movieRepository: Provider.of<MovieRepository>(context),
        watchlistRepository: Provider.of<WatchlistRepository>(context),
        movieId: Provider.of<int>(context)
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          MovieSectionTitleWidget(title: "Director & Cast"),
          Container(
            height: 148,
            width: MediaQuery.of(ctx).size.width,
            child: Align(
              alignment: Alignment.center,
              child: StreamBuilder(
                stream: _bloc.castView,
                builder: (ctx, AsyncSnapshot<CastView> snapshot) {
                  final result = snapshot.data;
                  if (snapshot == null || snapshot.data == null) {
                    return WidgetFactory.createProgressWidget();
                  }

                  if (result.isLoading) {
                    return WidgetFactory.createProgressWidget();
                  }

                  if (result.hasError) {
                    return WidgetFactory.createRetryWidget(
                      callback: () => _bloc.refresh()
                    );
                  }

                  final cast = result.items;
                  return CastListWidget(
                    cast: cast,
                    onTap: (cast) => SearchScreen.createRoute(ctx, cast: cast),
                  );
                }
              )
            )
          ),
          SizedBox(height: 12),
        ],
      )
    );
  }

}