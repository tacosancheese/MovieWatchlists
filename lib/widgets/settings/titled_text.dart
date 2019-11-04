import 'package:flutter/cupertino.dart';
import 'package:movie_watchlists/shared/config/dimensions.dart';
import 'package:movie_watchlists/shared/config/palette.dart';

class TitledTextWidget extends StatelessWidget {
  final String title;
  final String text;

  const TitledTextWidget({
    @required this.title,
    @required this.text
  });

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(title,
              maxLines: 1,
              style: TextStyle(
                  color: Palette.white82,
                  fontSize: SettingsStyle.textSizeNormal,
                  fontWeight: FontWeight.bold)
          ),
          SizedBox(height: 8),
          Text(text,
              style: TextStyle(
                color: Palette.white82,
                fontSize: SettingsStyle.textSizeSmall,
              )
          ),
          SizedBox(height: 12),
        ]
    );
  }
}
