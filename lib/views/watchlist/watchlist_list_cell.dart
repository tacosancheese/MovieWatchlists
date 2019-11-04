import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlists/models/watchlist.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/views/watchlist_detail/watchlist_detail_screen.dart';

class WatchlistCell extends StatelessWidget {

  final Watchlist watchlist;

  const WatchlistCell({
    Key key,
    this.watchlist
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return InkWell(
      onTap: () => DetailWatchlistScreen.createRoute(
          ctx: ctx,
          watchlist: watchlist
        ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(watchlist.name,
              maxLines: 1,
              style: TextStyle(
                color: Palette.white82,
                fontSize: 16.0,
                fontWeight: FontWeight.w500
              )
            ),
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(
                  Icons.movie,
                  color: Palette.white82,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text("0 / ${watchlist.movies.length}",
                  style: TextStyle(
                    color: Palette.white82,
                    fontSize: 15.0,
                  )
                ),
                SizedBox(width: 24),
                Icon(
                  Icons.people,
                  color: Palette.white82,
                  size: 20,
                ),
                SizedBox(width: 8),
                Text("${watchlist.totalUsers} people",
                  style: TextStyle(
                    color: Palette.white82,
                    fontSize: 15.0,
                  )
                ),
              ],
            )
          ]
        ),
      ),
    );
  }

}