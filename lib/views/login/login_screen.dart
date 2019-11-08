import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:movie_watchlists/blocs/login_bloc.dart';
import 'package:movie_watchlists/data/auth/auth_handler.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/views/home/home_screen.dart';
import 'package:movie_watchlists/widgets/widget_factory.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {

  static createRoute(final BuildContext ctx) {
    Navigator.pushAndRemoveUntil(ctx,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false
    );
  }

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginScreen> {

  LoginBloc _bloc;

  @override
  void didChangeDependencies() {
    final handler = Provider.of<AuthHandler>(context);
    _bloc= LoginBloc(handler: handler);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _bloc.view,
        builder: (ctx, AsyncSnapshot<LoginView> snapshot) {
          final view = snapshot.data;
          if (view == null) {
            return WidgetFactory.createProgressWidget();
          }

          if (view.isLoading) {
            return WidgetFactory.createProgressWidget();
          }

          if (view.hasLoggedIn) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              HomeScreen.createRoute(ctx);
            });

            return WidgetFactory.createProgressWidget();
          }

          if (view.hasError) {
            Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Whoopsie, something went wrong')));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              _HeaderWidget(),
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 24),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: view.hasAcceptedTerms ?
                      _LoginWidgets(
                        key: Key("login"),
                        bloc: _bloc,
                        viewState: view.state,
                      ) :
                      _IntroWidget(
                        key: Key("intro"),
                        bloc: _bloc,
                        viewState: view.state,
                      )
                    )
                  ),
                ),
              ),
              _TermsAndConditionsWidget(
                bloc: _bloc,
                view: view
              ),
            ],
          );
        },
      )
    );
  }
}

class _HeaderWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: Container(
        color: Palette.blue82,
      ),
    );
  }
}

class _IntroWidget extends StatelessWidget {

  final LoginBloc bloc;
  final LoginState viewState;

  const _IntroWidget({
    Key key,
    @required this.bloc,
    @required this.viewState
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          "Welcome to <app name>",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Palette.white82
          ),
        ),
        SizedBox(height: 12),
        Text(
          "With <app name>, you can create movie watchlists for yourself and share them with your friends",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Palette.white82
          ),
        ),
      ]
    );
  }
}

class _LoginWidgets extends StatelessWidget {

  final LoginBloc bloc;
  final LoginState viewState;

  const _LoginWidgets({
    Key key,
    @required this.bloc,
    @required this.viewState
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text("Login by using one of the providers",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Palette.white82
          ),
        ),
        SizedBox(height: 24),
        TwitterSignInButton(
          onPressed: () {
            final snackBar = SnackBar(
              content: Text('Sorry, Twitter login is not supported yet :('));
            Scaffold.of(context).showSnackBar(snackBar);
          }
        ),
        SizedBox(height: 16),
        GoogleSignInButton(
          darkMode: true,
          onPressed: () => bloc.onAuthTypeSelect(AuthType.GOOGLE_FIREBASE)
        ),
        SizedBox(height: 16),
        FacebookSignInButton(
          onPressed: () {
            final snackBar = SnackBar(
              content: Text('Sorry, Facebook login is not supported yet :('));
            Scaffold.of(context).showSnackBar(snackBar);
          }
        ),
      ],
    );
  }
}

class _TermsAndConditionsWidget extends StatelessWidget {

  final LoginBloc bloc;
  final LoginView view;

  const _TermsAndConditionsWidget({
    Key key,
    @required this.bloc,
    @required this.view
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Checkbox(
                value: view.hasAcceptedTerms,
                onChanged: (value) => bloc.onTermsChange(value),
              ),
              SizedBox(width: 6),
              Expanded(
                child: RichText(
                  maxLines: 2,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'I have read and I accept the ',
                        style: TextStyle(
                          color: Palette.white82,
                          fontSize: 18
                        ),
                      ),
                      TextSpan(
                        text: 'terms and conditions',
                        style: TextStyle(
                          color: Palette.accent,
                          decorationStyle: TextDecorationStyle.dashed,
                          fontSize: 18
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            launch(
                              'https://docs.flutter.io/flutter/services/UrlLauncher-class.html');
                          }
                      ),
                    ],
                  ),
                ),
              )
            ]
          ),
        )
    );
  }
}