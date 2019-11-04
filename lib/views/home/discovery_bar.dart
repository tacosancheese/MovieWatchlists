import 'package:flutter/material.dart';
import 'package:movie_watchlists/blocs/discovery_bloc.dart';
import 'package:movie_watchlists/models/movie_selection.dart';
import 'package:movie_watchlists/shared/config/dimensions.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:provider/provider.dart';

class DiscoveryBar extends StatefulWidget implements PreferredSizeWidget {

  const DiscoveryBar();

  @override
  State<StatefulWidget> createState() => _DiscoveryBarState();

  @override
  Size get preferredSize => Size.fromHeight(AppStyle.appBarHeight * 2);
}

class _DiscoveryBarState extends State<DiscoveryBar> {

  MovieSelection _state = MovieSelection.POPULAR;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(left: 18, right: 16, top: 12, bottom: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text("Discover",
                      style: TextStyle(
                        color: Palette.white82,
                        fontSize: AppStyle.appBarFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    color: Palette.white82,
                    icon: Icon(Icons.search),
                    onPressed: () => debugPrint("hello"),
                  )
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _createWidget("Popular", MovieSelection.POPULAR),
                    _createWidget("Upcoming", MovieSelection.UPCOMING)
                  ],
                ),
              )
            ]),
        )
      )
    );
  }

  Widget _createWidget(final String title, final MovieSelection selection) {
    var isSelected = false;
    if (_state == selection) {
      isSelected = true;
    }

    return InkWell(
      borderRadius: BorderRadius.all(Radius.circular(24)),
      onTap: ()  {
        if (_state == selection) {
          return;
        }

        setState(() {
          if (_state == MovieSelection.UPCOMING) {
            _state = MovieSelection.POPULAR;
          } else {
            _state = MovieSelection.UPCOMING;
          }

          final bloc = Provider.of<DiscoveryBloc>(context);
          bloc.changeSelection(_state);
        });
      },
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(24)),
          color: isSelected ? Palette.accent : null,
        ),
        duration: Duration(milliseconds: 250),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            title,
            style: TextStyle(
              color: isSelected ? Palette.black : Palette.white60,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ),
    );
  }
}