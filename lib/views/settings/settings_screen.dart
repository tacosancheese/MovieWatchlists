import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_watchlists/blocs/settings_bloc.dart';
import 'package:movie_watchlists/data/auth/auth_handler.dart';
import 'package:movie_watchlists/data/preferences/user_preferences.dart';
import 'package:movie_watchlists/data/repos/user_repository.dart';
import 'package:movie_watchlists/shared/package.dart';
import 'package:movie_watchlists/views/login/login_screen.dart';
import 'package:movie_watchlists/widgets/settings/titled_setting_image_description.dart';
import 'package:movie_watchlists/widgets/settings/titled_setting_section.dart';
import 'package:movie_watchlists/widgets/settings/titled_setting_text_button.dart';
import 'package:movie_watchlists/widgets/settings/titled_setting_toggle.dart';
import 'package:movie_watchlists/widgets/widget_factory.dart';
import 'package:provider/provider.dart';

import 'settings_bar.dart';

class SettingsScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => SettingsState();
}

class SettingsState extends State<SettingsScreen> {

  SettingsBloc _bloc;

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    final handler = Provider.of<AuthHandler>(context);
    final userRepo = Provider.of<UserRepository>(context);
    final userPrefs = Provider.of<UserPreferences>(context);
    final package = Provider.of<Package>(context);

    _bloc = SettingsBloc(
      handler: handler,
      userRepo: userRepo,
      userPrefs: userPrefs,
      package: package
    );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SettingsBar(),
      body: StreamBuilder(
        stream: _bloc.viewState,
        builder: (ctx, AsyncSnapshot<SettingsView> snapshot) {
          final view = snapshot.data;
          if (view == null) {
            return WidgetFactory.createProgressWidget();
          }

          if (view.isLoading) {
            return WidgetFactory.createProgressWidget();
          }

          if (view.isLoggedOut || view.isDeleted) {
            debugPrint("isLoggedOut or isDeleted");
            WidgetsBinding.instance.addPostFrameCallback((_) {
              LoginScreen.createRoute(ctx);
            });

            return WidgetFactory.createProgressWidget();
          }

          return ListView(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            shrinkWrap: true,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _GeneralSettings(
                    bloc: _bloc,
                    view: view,
                  ),
                  _UserSettings(
                    bloc: _bloc,
                    view: view
                  ),
                  _ContentSettings(
                    bloc: _bloc,
                    view: view,
                  ),
                  _LegalInformation(
                    bloc: _bloc,
                    view: view
                  ),
                  AccountWidget(
                    bloc: _bloc,
                    view: view
                  )
                ]
              ),
            ],
          );
        },
      )
    );
  }
}

class _GeneralSettings extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final SettingsBloc bloc;
  final SettingsView view;

   _GeneralSettings({
     Key key,
     @required this.bloc,
     @required this.view
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitledSettingSectionTitle(title: "General"),
        TitledSettingToggle(
          title: "Analytics",
          description: "Enable analytics for development purposes",
          toggled: view.settings.generalSettings.analytics,
          onToggle: (value) => bloc.toggleAnalytics(value)),
        TitledSettingTextButton(
          title: "Themes",
          description: "Coming soon",
          onTap: () => debugPrint("Themes, tap tap"))
      ],
    );
  }
}

class _UserSettings extends StatelessWidget {

  final _formKey = GlobalKey<FormState>();
  final SettingsBloc bloc;
  final SettingsView view;

  _UserSettings({
    Key key,
    @required this.bloc,
    @required this.view
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitledSettingSectionTitle(title: "User"),
        TitledSettingTextButton(
          title: "Alias: ${view.settings.userSettings.alias}",
          description: "Alias is visible to others in shared watchlists",
          onTap: () => _showAliasDialog(ctx),
        ),
        TitledSettingToggle(
          title: "Notifications",
          description: "Enable to receive push notifications",
          toggled: view.settings.userSettings.notifications,
          onToggle: (value) => bloc.toggleNotifications(value)
        ),
      ],
    );
  }

  void _showAliasDialog(final BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text("Change your alias"),
          content: Form(
            key: _formKey,
            child: TextFormField(
              autocorrect: false,
              decoration: InputDecoration(labelText: 'Enter your alias'),
              maxLength: 16,
              inputFormatters: [
                LengthLimitingTextInputFormatter(16),
                WhitelistingTextInputFormatter(RegExp("[a-zA-Z]"))
              ],
              maxLines: 1,
              // TODO: add validator
              onSaved: (text) => bloc.changeAlias(text),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
            FlatButton(
              child: Text("OK"),
              onPressed: () => _changeAlias(ctx)
            )
          ],
        );
      });
  }

  void _changeAlias(final BuildContext ctx) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
    }
    Navigator.of(ctx).pop();
  }
}

class _ContentSettings extends StatelessWidget {

  final SettingsBloc bloc;
  final SettingsView view;

  const _ContentSettings({Key key,
    @required this.bloc,
    @required this.view
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitledSettingSectionTitle(title: "Content"),
        TitledSettingToggle(
          title: "Adult content",
          description: "Display adult rated content",
          toggled: view.settings.contentSettings.adultContent,
          onToggle: (value) => bloc.toggleAdultContent(value)),
        TitledSettingToggle(
          title: "High-quality images",
          description: "Display high-quality images at increased bandwidth usage",
          toggled: view.settings.contentSettings.highQualityImages,
          onToggle: (value) => bloc.toggleHighQualityContent(value)),
      ],
    );
  }
}

class _LegalInformation extends StatelessWidget {

  final SettingsBloc bloc;
  final SettingsView view;

  const _LegalInformation({Key key,
    @required this.bloc,
    @required this.view
  }) : super(key: key);

  @override
  Widget build(BuildContext ctx) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitledSettingSectionTitle(title: "Legal"),
        TitledSettingTextButton(
          title: "Application version",
          description: view.settings.appVersion,
          onTap: () => debugPrint("no-op"),
        ),
        TitledSettingTextButton(
          title: "Open source licenses",
          description: "View source licenses",
          onTap: () => showLicensePage(
            context: ctx,
            applicationName: "Name of the app", // TODO: app name
            applicationVersion: view.settings.appVersion,
            applicationLegalese: '© 2019 Daniel Sanchez',
          )),
        TitledSettingTextButton(
          title: "Terms of service",
          description: "View terms of service",
          onTap: () => debugPrint("TODO"),
        ),
        SizedBox(height: 10),
        TitledSettingImageDescription(
          assetPath: 'assets/tmdb.png',
          description:
          "This product uses the TMDb API but is not endorsed or certified by TMDb.",
        ),
        SizedBox(height: 8),
      ],
    );
  }

}

class AccountWidget extends StatelessWidget {

  final SettingsBloc bloc;
  final SettingsView view;

  const AccountWidget({Key key,
    @required this.bloc,
    @required this.view
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TitledSettingSectionTitle(title: "Account"),
        TitledSettingTextButton(
          title: "Logout",
          description: "Log out from the application",
          onTap: () => bloc.logout(),
        ),
        TitledSettingTextButton(
          title: "Delete your account",
          description: "Delete your account permanently",
          onTap: () => _showDeleteDialog(context)
        )
      ],
    );
  }

  void _showDeleteDialog(final BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: Text("Delete account"),
          content: Text(
            "This action is permanent; your account will be deleted and cannot be recovered at a later time"),
          actions: <Widget>[
            FlatButton(
              child: Text("DELETE MY ACCOUNT"),
              onPressed: () =>  bloc.deleteAccount(),
            ),
            FlatButton(
              child: Text("CANCEL"),
              onPressed: () => Navigator.of(ctx).pop(),
            )
          ],
        );
      });
  }
}