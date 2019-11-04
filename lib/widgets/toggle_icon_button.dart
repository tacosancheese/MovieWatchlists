import 'package:flutter/material.dart';
import 'package:movie_watchlists/shared/config/palette.dart';

class ToggleIconButton extends StatefulWidget {

  final bool state;
  final IconData toggledIcon;
  final IconData untoggledIcon;
  final ValueChanged<bool> callback;

  const ToggleIconButton({
    @required this.state,
    @required this.toggledIcon,
    @required this.untoggledIcon,
    @required this.callback
  });

  @override
  State<StatefulWidget> createState() {
    return _ToggleState(state, toggledIcon, untoggledIcon, callback);
  }
}

class _ToggleState extends State<ToggleIconButton> {

  bool state;
  final IconData toggledIcon;
  final IconData untoggledIcon;
  final ValueChanged<bool> callback;

  _ToggleState(this.state, this.toggledIcon, this.untoggledIcon, this.callback);

  // TODO: animate
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.all(0),
      onPressed: () {
        setState(() {
          state = !state;
          callback(state);
        });
      },
      iconSize: 32,
      icon: Icon(
        state ? toggledIcon : untoggledIcon,
        color: Palette.accent,
      ),
    );
  }
}