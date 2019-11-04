import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:movie_watchlists/shared/config/palette.dart';

class RetryWidget extends StatelessWidget {
  final VoidCallback retryCallback;

  const RetryWidget({
    Key key,
    @required this.retryCallback
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          Icons.error,
          color: Palette.white82,
          size: 48.0,
        ),
        SizedBox(height: 16),
        Text("Whoops, something went wrong",
          style: TextStyle(
            color: Palette.white82,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 24),
        MaterialButton(
          color: Palette.blue,
          child: Text("Retry",
            style: TextStyle(
              fontSize: 18
            ),
          ),
          onPressed: () => retryCallback(),
        )
      ],
    );
  }
}
