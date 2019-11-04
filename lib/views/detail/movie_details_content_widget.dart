import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_watchlists/models/movie.dart';
import 'package:movie_watchlists/models/movie_details.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/views/detail/movie_cast_widget.dart';
import 'package:movie_watchlists/widgets/toggle_icon_button.dart';
import 'package:provider/provider.dart';

import 'background_image_widget.dart';
import 'movie_information_widget.dart';
import 'movie_section_title_widget.dart';
import 'movie_watchlists_widget.dart';

class DiscoveryContentWidget extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {
    final details = Provider.of<MovieDetails>(ctx);

    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(ctx).size.height * 0.77,
            floating: true,
            pinned: true,
            backgroundColor: Palette.grey,
            title: Text(details.title,
              style: TextStyle(
                color: Palette.white
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: BackgroundImageWidget(
                url: details.originalPosterPathUrl
              )
            ),
          ),
        ];
      },
      body: SingleChildScrollView(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _MovieTitleWidget(),
            _DescriptionWidget(),
            MovieCastWidget(),
            InformationWidget()
          ],
        ),
      )
    );
  }
}

class _DescriptionWidget extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {
    final details = Provider.of<MovieDetails>(ctx);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          MovieSectionTitleWidget(title: "Description"),
          Text(details.overview,
            style: TextStyle(
              color: Palette.white82,
              fontSize: 15.0,
            )
          ),
        ],
      ),
    );
  }
}

class _MovieTitleWidget extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {
    final details = Provider.of<MovieDetails>(ctx);

    return Container(
      color: Palette.grey,
      height: MediaQuery.of(ctx).size.height * 0.20,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.only(top: 8, right: 8, bottom: 8, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(details.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                      color: Palette.white87,
                      fontSize: 20.0,
                      //fontWeight: FontWeight.w700
                    )
                  ),
                ),
                ToggleIconButton(
                  callback: (bool) => _showWatchlists(ctx, details, bool),
                  state: false,
                  toggledIcon: Icons.library_add,
                  untoggledIcon: Icons.library_add,
                ),
              ],
            ),
            Text(details.originalTitle,
              maxLines: 2,
              style: TextStyle(
                color: Palette.white82,
                fontSize: 16.0
              )
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: Text(details.genres.map((genre) => genre.name).join(", "),
                    maxLines: 1,
                    style: TextStyle(
                      color: Palette.white82,
                      fontSize: 14.0,
                    )
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Text(details.runTimeInHoursAndMinutes,
                    maxLines: 1,
                    style: TextStyle(
                      color: Palette.white82,
                      fontSize: 14.0,
                    )
                  ),
                )
              ],
            )
          ],
        )
      )
    );
  }

  void _showWatchlists(final BuildContext ctx,
    final MovieDetails details,
    final bool boolean) {
    showModalBottomSheet(context: ctx,
      builder: (BuildContext ctx) => Provider<MovieDetails>(
        builder: (ctx) => details,
        child: WatchlistsWidget()
      )
    );
  }
}