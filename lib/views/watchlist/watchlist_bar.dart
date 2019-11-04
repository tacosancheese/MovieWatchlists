import 'package:flutter/material.dart';
import 'package:movie_watchlists/shared/config/dimensions.dart';
import 'package:movie_watchlists/shared/config/palette.dart';

class WatchlistBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(left: 18, right: 16, top: 22, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Watchlists",
                      style: TextStyle(
                        color: Palette.white82,
                        fontSize: AppStyle.appBarFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ]
          )
        )
      )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppStyle.appBarHeight);
}