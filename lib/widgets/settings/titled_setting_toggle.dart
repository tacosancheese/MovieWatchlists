import 'package:flutter/material.dart';
import 'package:movie_watchlists/shared/config/dimensions.dart';
import 'package:movie_watchlists/shared/config/palette.dart';

class TitledSettingToggle extends StatelessWidget {

  final String title;
  final String description;
  final bool toggled;
  final ValueChanged<bool> onToggle;

  const TitledSettingToggle({
    @required this.title,
    @required this.description,
    @required this.toggled,
    @required this.onToggle
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(title,
                    style: TextStyle(
                      color: Palette.white82,
                      fontSize: SettingsStyle.textSizeNormal
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(description.isEmpty ? "" : description,
                    style: TextStyle(
                      color: Palette.white60,
                      fontSize: SettingsStyle.textSizeSmall
                    ),
                  ),
                ],
              )
            ),
            Switch(
              value: toggled,
              onChanged: (_) =>  onToggle(!toggled)
            ),
          ],
        ),
        SizedBox(height: 4)
      ],
    );
  }
}
