import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class Config {
  final String appName = 'Camer Infoline';
  final String splashIcon = 'assets/images/splash.png';
  final String supportEmail = 'cmerinfoline@gmail.com';
  final String privacyPolicyUrl = 'https://www.mrb-lab.com/privacy-policy';
  final String ourWebsiteUrl = 'https://tourcmr.com/';
  final String iOSAppId = '000000';

  //social links
  static const String facebookPageUrl = 'https://web.facebook.com/TourCmrApp/';
  static const String youtubeChannelUrl =
      'https://www.youtube.com/channel/UC6HqXn67viHcKVSwKM5GOzg';
  static const String twitterUrl = 'https://twitter.com/TourCmrApp';

  //app theme color
  final Color appColorGreen = Color(0xff006400);
  final Color appColorRed = Colors.red;
  final Color appColorYellow = Colors.yellow;

  //Intro images
  final String introImage1 = 'assets/images/news1.png';
  final String introImage2 = 'assets/images/news6.png';
  final String introImage3 = 'assets/images/news7.png';

  //animation files
  final String doneAsset = 'assets/animation_files/done.json';

  //Language Setup
  final List<String> languages = [
    'English',
    'French',
  ];

  //Saves Data For Translation English=Cancel, French=Annuler
  String lang = 'cancel'.tr();

  //initial categories Names - 4 only (which can be translated : which are added already on your admin panel)
  final List initialCategoriesLabel = [
    'presidential'.tr(),
    'press release'.tr(),
    'administration'.tr(),
    'employment'.tr()
  ];

  //initial categories - 4 only (Hard Coded : which are added already on your admin panel)
  final List initialCategoriesData = [
    'Presidential',
    'Press Release',
    'Administration',
    'Employment'
  ];
}
