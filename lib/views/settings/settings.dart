import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class GeneralSettings extends Equatable {

  final bool analytics;
  final String appTheme;

  GeneralSettings({
    @required this.analytics,
    @required this.appTheme
  });
}

class UserSettings extends Equatable {

  final String alias;
  final bool notifications;

  UserSettings({
    @required this.alias,
    @required this.notifications
  });
}

class ContentSettings extends Equatable {

  final bool adultContent;
  final bool highQualityImages;

  ContentSettings({
    @required this.adultContent,
    @required this.highQualityImages
  });
}