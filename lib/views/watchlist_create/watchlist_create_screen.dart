import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_watchlists/blocs/watchlist_create_bloc.dart';
import 'package:movie_watchlists/data/repos/watchlist_repository.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/widgets/settings/titled_setting_section.dart';
import 'package:movie_watchlists/widgets/settings/titled_setting_text_button.dart';
import 'package:movie_watchlists/widgets/settings/titled_setting_toggle.dart';
import 'package:movie_watchlists/widgets/widget_factory.dart';
import 'package:provider/provider.dart';

import 'watchlist_create_bar.dart';

class WatchlistCreateScreen extends StatefulWidget {

  static createRoute(final BuildContext ctx) {
    Navigator.push(ctx, MaterialPageRoute(
      builder: (context) => WatchlistCreateScreen())
    );
  }

  @override
  State<StatefulWidget> createState() => _WatchlistCreateState();
}

class _WatchlistCreateState extends State<WatchlistCreateScreen> {

  final _formKey = GlobalKey<FormState>();
  WatchListCreateBloc _bloc;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final repo = Provider.of<WatchlistRepository>(context);
    _bloc = WatchListCreateBloc(repo);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext ctx) {
    return  Provider<WatchListCreateBloc>(
      builder: (ctx) => _bloc,
      child: Scaffold(
        appBar: WatchlistCreateBar(),
        resizeToAvoidBottomPadding: true,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: StreamBuilder(
              stream: _bloc.view,
              builder: (ctx, AsyncSnapshot<CreateView> snapshot) {
                final view = snapshot.data;
                if (view == null) {
                  return WidgetFactory.createProgressWidget();
                }

                if (view.isLoading) {
                  return WidgetFactory.createProgressWidget();
                }

                // notify user and exit screen
                if (view.isSaved) {
                  // TODO: could show saved animation
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pop(context);
                  });
                }

                // display error message
                if (view.hasError) {
                  debugPrint("hasError");
                }

                // basically 'ready' state
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TitledSettingSectionTitle(
                      title: "General",
                    ),
                    Divider(
                      color: Palette.white60,
                      height: 1,
                    ),
                    SizedBox(height: 6),
                    TitledSettingTextButton(
                      title: "Watchlist name",
                      description: "Watchlist name is visible to you and to other users",
                      onTap: () => showNameDialog(ctx),
                    ),
                    TitledSettingToggle(
                      title: "Adult content",
                      description: "Allow adult content to be added",
                      toggled: view.settings.adultContent,
                      onToggle: (value) => _bloc.toggleAdult(value),
                    ),
                    TitledSettingToggle(
                      title: "Enable notifications",
                      description:
                      "Notify me when other users have modified the list",
                      toggled: view.settings.notifications,
                      onToggle: (value) => _bloc.enableNotifications(value),
                    ),
                    TitledSettingSectionTitle(
                      title: "Users",
                    ),
                    Divider(
                      color: Palette.white60,
                      height: 1,
                    ),
                    TitledSettingTextButton(
                      title: "Add users",
                      description: "Add users to share the watchlist",
                      onTap: () => _showSettings(ctx),
                    ),
                  ],
                );
              },
            )
          ),
        )
      ),
    );
  }

  void _showSettings(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return ListView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          children: <Widget>[
            Row(children: <Widget>[
              Icon(Icons.person_add,
                color: Palette.white82
              ),
              SizedBox(width: 16),
              Text("Add a user",
                style: TextStyle(
                  color: Palette.white82,
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold
                ),
              )
            ]),
            SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: TextField(
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "# 1234 1234 1234 1234",
                    ),
                  ),
                ),
                SizedBox(width: 16),
                IconButton(
                  onPressed: () => debugPrint("get clipboard content"),
                  icon: Icon(Icons.content_paste,
                    color: Palette.white82
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text("Ask your friend for the user id; it can be found from the settings",
                style: TextStyle(
                  color: Palette.white60,
                  fontSize: 14,
                ),
              ),
            )
          ],
        );
      });
  }

  void showNameDialog(final BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text("Watchlist name"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              autocorrect: false,
              decoration: InputDecoration(labelText: "Enter watchlist name"),
              maxLength: 20,
              inputFormatters: [
                LengthLimitingTextInputFormatter(20),
                WhitelistingTextInputFormatter(RegExp("[a-zA-Z]"))
              ],
              maxLines: 1,
              onSaved: (text) {
                if (text.isNotEmpty) {
                  _bloc.changeName(text);
                }
              },
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () => _changeName(ctx)
            )
          ],
        );
      });
  }

  void _changeName(final BuildContext ctx) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    Navigator.of(ctx).pop();
  }

}