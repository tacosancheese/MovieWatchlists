import 'package:flutter/material.dart';
import 'package:movie_watchlists/shared/config/dimensions.dart';
import 'package:movie_watchlists/shared/config/palette.dart';

class TitledSettingTextButton extends StatelessWidget {

  final String title;
  final String description;
  final VoidCallback onTap;

  const TitledSettingTextButton({
    Key key,
    @required this.title,
    @required this.description,
    this.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(title,
                  style: TextStyle(
                    color: Palette.white82,
                    fontSize: SettingsStyle.textSizeNormal
                  ),
                ),
                SizedBox(height: 6),
                Visibility(
                  visible: description.isNotEmpty,
                  child: Text(description.isEmpty ? "" : description,
                   style: TextStyle(
                     color: Palette.white60,
                     fontSize: SettingsStyle.textSizeSmall
                   ),
                 ),
                )
              ],
          ),
        )
      ),
    );
  }
}