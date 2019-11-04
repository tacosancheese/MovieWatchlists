import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_watchlists/shared/config/palette.dart';

class MovieSectionTitleWidget extends StatelessWidget {

  final String title;

  const MovieSectionTitleWidget({
    Key key,
    @required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(height: 12),
        Text(title,
          style: TextStyle(
            color: Palette.white82,
            fontSize: 18.0,
            fontWeight: FontWeight.bold
          )
        ),
        SizedBox(height: 16),
      ],
    );
  }
}