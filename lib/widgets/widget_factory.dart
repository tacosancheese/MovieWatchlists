import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/widgets/progress_widget.dart';
import 'package:movie_watchlists/widgets/retry_error_widget.dart';

abstract class WidgetFactory {

  static Widget createErrorWidget() {
    return Center(
      child: Icon(
        Icons.error,
        color: Palette.blue82,
        size: 40,
      ),
    );
  }

  static Widget createMissingImageWidget() {
    return Container(
      color: Palette.black,
      child: Center(
        child: Icon(
          Icons.not_interested,
          color: Palette.blue,
          size: 40,
        ),
      ),
    );
  }

  static Widget createRetryWidget({@required final VoidCallback callback}) {
    return Center(
      child: RetryWidget(
        retryCallback: callback,
      )
    );
  }

  static Widget createProgressWidget() {
    return Center(
      child: ProgressWidget(),
    );
  }
}