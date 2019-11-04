import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/models/cast.dart';

class SearchScreen extends StatelessWidget {

  final Cast cast;

  const SearchScreen({Key key, this.cast}) : super(key: key);

  static createRoute(final BuildContext ctx,
    {@required final Cast cast}) {
    Navigator.push(ctx, MaterialPageRoute(
      builder: (context) {
        return SearchScreen(cast: cast);
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SettingsBar(cast: cast,),
      body: Text("Hi"),
    );
  }
}

class _SettingsBar extends StatelessWidget implements PreferredSizeWidget {

  final Cast cast;

  const _SettingsBar({Key key, this.cast}) : super(key: key);

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
                    child: Text(cast.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Palette.white82,
                        fontSize: 20,
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
  Size get preferredSize => Size.fromHeight(64);
}