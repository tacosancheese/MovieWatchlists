import 'package:flutter/widgets.dart';

// If condition == true, return a widget
void addIf({@required final Function condition, @required final Widget child,
  @required final List<Widget> parent}) {
  if (condition()) {
    parent.add(child);
  }
}

// If object is null, return a widget
Widget addIfNull({
  @required final dynamic object,
  @required final Widget widget}) {
  if (object != null) {
    return widget;
  }
  return null;
}

// If condition == true, perform an action and return a widget
Widget addAndExecuteIf({
  @required final Function condition,
  @required final Function action,
  @required final Widget widget}) {
  if (condition()) {
    action();
    return widget;
  }
  return null;
}