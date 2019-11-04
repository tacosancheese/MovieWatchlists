import 'package:flutter/cupertino.dart';
import 'package:movie_watchlists/shared/config/dimensions.dart';
import 'package:movie_watchlists/shared/config/palette.dart';

class TitledSettingImageDescription extends StatelessWidget {

  final String assetPath;
  final String description;

  const TitledSettingImageDescription({
    Key key,
    @required this.assetPath,
    @required this.description
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Image.asset('assets/tmdb.png',
          height: 32,
          width: 32,
        ),
        SizedBox(width: 24),
        Flexible(
          child: Text("This product uses the TMDb API but is not endorsed or certified by TMDb.",
            style: TextStyle(
              color: Palette.white82,
              fontSize: SettingsStyle.textSizeNormal
            ),
          ),
        )
      ],
    );
  }
}