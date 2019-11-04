import 'package:flutter/material.dart';
import 'package:movie_watchlists/blocs/watchlist_detail_bloc.dart';
import 'package:movie_watchlists/shared/config/dimensions.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/widgets/settings/titled_setting_text_button.dart';
import 'package:movie_watchlists/widgets/settings/titled_setting_toggle.dart';
import 'package:provider/provider.dart';

class WatchlistDetailAppBar extends StatelessWidget implements PreferredSizeWidget {

  final String title;

  const WatchlistDetailAppBar({
    Key key,
    @required this.title
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
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
                    child:Align(
                      alignment: Alignment.centerLeft,
                      child:  Text(title,
                        style: TextStyle(
                          color: Palette.white82,
                          fontSize: AppStyle.appBarFontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ),
                  IconButton(
                    color: Palette.white82,
                    icon: Icon(Icons.search),
                    onPressed: () => debugPrint("hello"),
                  ),
                  IconButton(
                    color: Palette.white82,
                    icon: Icon(Icons.settings),
                    onPressed: () => _showSettings(ctx),
                  ),
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

  void _showSettings(BuildContext ctx) {
    final bloc = Provider.of<WatchlistDetailBloc>(ctx);

    showModalBottomSheet(
      context: ctx,
      builder: (BuildContext ctx) {
        return DefaultTabController(
          length: 2,
          child: Scaffold(
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  TabBar(
                    tabs: [
                      Tab(text: "General"),
                      Tab(text: "Users"),
                    ],
                  ),
                  Expanded(
                    flex: 1,
                    child: TabBarView(
                      children: [
                        _WatchlistView(bloc: bloc),
                        _UserView()
                      ],
                    ),
                  )
                ],
              ),
            )
          )
        );
      });
  }
}


class _WatchlistView extends StatelessWidget {

  final WatchlistDetailBloc bloc;

  const _WatchlistView({
    Key key,
    @required this.bloc
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Padding(
      padding: EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TitledSettingTextButton(
            title: "Watchlist name",
            description: "Change watchlist name",
            onTap: () => debugPrint("hi"),
          ),
          TitledSettingToggle(
            title: "Adult content",
            description: "Allow adult content to be added",
            toggled: false,
            onToggle: (value) => debugPrint("hi"),
          ),
          TitledSettingToggle(
            title: "Enable notifications",
            description: "Notify me when other users have modified the list",
            toggled: false,
            onToggle: (value) => debugPrint("hi"),
          ),
          TitledSettingTextButton(
            title: "Leave the watchlist",
            description: "The watchlist will be deleted if you're the only user",
            onTap: () => _showDialog(ctx)
          ),
        ],
      ),
    );
  }

  void _showDialog(final BuildContext context) {
    showDialog(context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text("Leave the watchlist"),
          content: Text(
            "Are you sure you want to leave this watchlist? If you are the last user, it will be deleted permanently."),
          actions: <Widget>[
            FlatButton(
              child: Text("LEAVE",),
              onPressed: () => bloc.leave()
            ),
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () => Navigator.of(context).pop(),
            )
          ],
        );
      });
  }
}

class _UserView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ListTile(
            onTap: () => debugPrint("add a user"),
            contentPadding: EdgeInsets.all(0),
            leading: Icon(Icons.person_add),
            title: Text("Add a user",
              style: TextStyle(
                fontSize: 15,
                color: Palette.white82
              ),
            ),
          ),
          SizedBox(height: 12),
          Text("Users",
            style: TextStyle(
              color: Palette.white82,
              fontSize: 15,
              fontWeight: FontWeight.bold
            )
          ),
          SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Icon(Icons.supervisor_account),
            onTap: () => debugPrint("add a user"),
            title: Text("John Doe",
              style: TextStyle(
                fontSize: 15,
                color: Palette.white82
              ),
            ),
          )
        ],
      ));
  }
}