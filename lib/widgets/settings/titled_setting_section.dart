import 'package:flutter/material.dart';
import 'package:movie_watchlists/shared/config/dimensions.dart';
import 'package:movie_watchlists/shared/config/palette.dart';

class TitledSettingSectionTitle extends StatelessWidget {

  final String title;

  const TitledSettingSectionTitle({
    Key key,
    @required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 6),
        Text(title,
          maxLines: 1,
          style: TextStyle(
            color: Palette.white87,
            fontSize: SettingsStyle.textSizeMedium,
            fontWeight: FontWeight.bold
          )
        ),
        SizedBox(height: 6),
      ],
    );
  }
}