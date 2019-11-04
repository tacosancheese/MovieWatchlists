import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:movie_watchlists/models/movie_details.dart';
import 'package:movie_watchlists/shared/config/palette.dart';
import 'package:movie_watchlists/widgets/settings/titled_text.dart';
import 'package:provider/provider.dart';

import 'movie_section_title_widget.dart';

class InformationWidget extends StatelessWidget {

  @override
  Widget build(BuildContext ctx) {
    final details = Provider.of<MovieDetails>(ctx);

    return Container(
      color: Palette.grey,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            MovieSectionTitleWidget(title: "Information"),
            _InformationFieldsWidget(
              leftSectionTitle: "Release status",
              leftSectionContent: details.status,
              rightSectionTitle: "Release date", // TODO: localization (intl)
              rightSectionContent: details.releaseDate
            ),
            _InformationFieldsWidget(
              leftSectionTitle: "Language",
              leftSectionContent: details.fullOriginalLanguage,
              rightSectionTitle: "Spoken languages",
              rightSectionContent: details.spokenLanguages
                .map((lang) => lang.name).join("\n"),
            ),
            _InformationFieldsWidget(
              leftSectionTitle: "Budget",
              leftSectionContent: details.budget.toString(),
              rightSectionTitle: "Revenue",
              rightSectionContent: details.revenue.toString(),
            )
          ],
        ),
      )
    );
  }
}

class _InformationFieldsWidget extends StatelessWidget {

  final String leftSectionTitle;
  final String leftSectionContent;

  final String rightSectionTitle;
  final String rightSectionContent;

  const _InformationFieldsWidget({
    Key key,
    @required this.leftSectionTitle,
    @required this.leftSectionContent,
    @required this.rightSectionTitle,
    @required this.rightSectionContent
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 1,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: TitledTextWidget(
              title: leftSectionTitle,
              text: leftSectionContent
            ),
          ),
          Expanded(
            flex: 1,
            child: TitledTextWidget(
              title: rightSectionTitle,
              text: rightSectionContent
            ),
          )
        ],
      ),
    );
  }
}