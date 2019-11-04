import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlists/shared/config/palette.dart';

class WarningWidget extends StatelessWidget {
  final String title;

  const WarningWidget({
    Key key,
    @required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.error,
            color: Palette.white82,
            size: 48.0,
          ),
          SizedBox(height: 16),
          Text(title,
            maxLines: 1,
            style: TextStyle(
              fontSize: 18,
              color: Palette.white82
            ),
          )
        ],
      ),
    );
  }
}
