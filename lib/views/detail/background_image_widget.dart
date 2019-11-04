import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_watchlists/widgets/widget_factory.dart';

class BackgroundImageWidget extends StatelessWidget {

  final String url;

  const BackgroundImageWidget({
    Key key,
    @required this.url
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (url != null) {
      return Container(
        width: double.infinity,
        child: CachedNetworkImage(
          imageUrl: url,
          imageBuilder: (ctx, imageProvider) =>
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: imageProvider,
                ),
              ),
            ),
          placeholder: (ctx, url) => WidgetFactory.createProgressWidget(),
          errorWidget: (ctx, url, err) => WidgetFactory.createErrorWidget()
        )
      );
    } else {
      return WidgetFactory.createMissingImageWidget();
    }
  }
}