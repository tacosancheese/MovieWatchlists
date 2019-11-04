import 'package:flutter/material.dart';
import 'package:movie_watchlists/blocs/watchlist_create_bloc.dart';
import 'package:movie_watchlists/shared/config/dimensions.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:provider/provider.dart';

class WatchlistCreateBar extends StatelessWidget
  implements PreferredSizeWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<WatchListCreateBloc>(context);

    return SafeArea(
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.only(left: 18, right: 16, top: 12, bottom: 0),
          child: StreamBuilder(
            stream: bloc.view,
            builder: (ctx, AsyncSnapshot<CreateView> snapshot) {
              final view = snapshot.data;
              final isEnabled = (view == null)
                ? false : view.isReady || view.isValid;

              if (view == null) {
                return SizedBox();
              }

              if (view.isLoading || view.isSaved) {
                return SizedBox();
              }

              final String name = view.settings.name;
              final bool isValid = view.isValid;

              return _AppRow(
                bloc: bloc,
                isEnabled: isEnabled,
                isValid: isValid,
                name: name,
              );
            })
        )
      )
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(AppStyle.appBarHeight);
}

class _AppRow extends StatelessWidget {

  final WatchListCreateBloc bloc;
  final String name;
  final bool isEnabled;
  final bool isValid;

  const _AppRow({
    this.bloc,
    this.isEnabled,
    this.name,
    this.isValid
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Visibility(
          visible: isEnabled,
          child: Expanded(
            child: Text(name.isNotEmpty ? name : "Watchlist name",
              maxLines: 1,
              style: TextStyle(
                color: name.isNotEmpty ? Palette.white82 : Palette.white60,
                fontSize: AppStyle.appBarFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        IconButton(
          color: Palette.white82,
          disabledColor: Palette.white60,
          icon: Icon(Icons.save),
          onPressed: isValid ? () => bloc.save() : null,
        )
      ],
    );
  }
}
