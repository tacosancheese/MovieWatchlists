import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/models/cast.dart';
import 'package:movie_watchlists/widgets/widget_factory.dart';

class CastListWidget extends StatelessWidget {

  final List<Cast> cast;
  final ValueChanged<Cast> onTap;

  const CastListWidget({
    Key key,
    @required this.cast,
    @required this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cast.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (ctx, index) {
        return InkWell(
          onTap: () => onTap(this.cast[index]),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Container(
              width: 60,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 90,
                    width: 60,
                    child: _loadImage(cast[index])
                  ),
                  SizedBox(height: 8),
                  Text(
                    cast[index].name,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Palette.white82,
                      fontSize: 12,
                      fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
            )
          ),
        );
      },
    );
  }

  Widget _loadImage(final Cast member) {
    if (member.hasProfilePath) {
      return CachedNetworkImage(
          color: Colors.red,
          imageUrl: member.smallProfilePath,
          imageBuilder: (ctx, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: imageProvider,
                  ),
                ),
              ),
          placeholder: (context, url) => WidgetFactory.createProgressWidget(),
          errorWidget: (context, url, error) =>
              WidgetFactory.createErrorWidget());
    } else {
      return WidgetFactory.createMissingImageWidget();
    }
  }
}
