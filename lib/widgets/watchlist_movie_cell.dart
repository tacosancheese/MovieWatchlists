import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlists/models/watchlist_movie.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/views/detail/movie_details_screen.dart';
import 'package:movie_watchlists/widgets/progress_widget.dart';

class WatchlistMovieTextCell extends StatelessWidget {

  final double cellHeight = 140;
  final double cellWidth = 100;

  final WatchlistMovie item;

  const WatchlistMovieTextCell(this.item);

  void _tap(final BuildContext ctx, final int itemId) {
    debugPrint("itemId $itemId");
    MovieDetailsScreen.createRoute(ctx, itemId);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _createImageWidget(item),
              SizedBox(width: 16),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        item.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          color: Palette.white82,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(height: 2),
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 0, vertical: 4),
                          child: Text(item.genres.join(", "),
                            maxLines: 1,
                            style: TextStyle(
                              color: Palette.white60,
                              fontSize: 13.0,
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        item.overview,
                        overflow: TextOverflow.fade,
                        maxLines: 5,
                        style: TextStyle(
                          color: Palette.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              )
            ],
          ),
        ),
        onTap: () => _tap(context, item.id),
      ),
    );
  }

  Widget _createImageWidget(final WatchlistMovie movie) {
    final String url = movie.tmdbImage.smallPosterPathUrl;
    debugPrint(url);
    if (url.isNotEmpty) {
      return CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: url,
        imageBuilder: (ctx, imageProvider) =>
          Container(
            height: cellHeight,
            width: cellWidth,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              image: DecorationImage(
                fit: BoxFit.contain,
                image: imageProvider,
              ),
            ),
          ),
        placeholder: (context, url) => _createProgressWidget(),
        errorWidget: (context, url, error) => _createErrorWidget(),
      );
    } else {
      return _createErrorWidget();
    }
  }

  Widget _createProgressWidget() {
    return Container (
      child: ProgressWidget(),
      color: Palette.grey,
      height: cellHeight,
      width: cellWidth
    );
  }

  Widget _createErrorWidget() {
    return Container (
      child: Icon(
        Icons.error,
        color: Palette.white,
        size: 40,
      ),
      color: Palette.grey,
      height: cellHeight,
      width: cellWidth
    );
  }
}
