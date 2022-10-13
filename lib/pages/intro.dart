import 'package:cmer_infoline/blocs/sign_in_bloc.dart';
import 'package:cmer_infoline/config/config.dart';
import 'package:cmer_infoline/libraries/intro_views_flutter-2.4.0/lib/Models/page_view_model.dart';
import 'package:cmer_infoline/libraries/intro_views_flutter-2.4.0/lib/intro_views_flutter.dart';
import 'package:cmer_infoline/pages/home.dart';
import 'package:cmer_infoline/pages/welcome.dart';
import 'package:cmer_infoline/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

var _fontHeaderStyle = TextStyle(
    fontFamily: "Gotik",
    fontSize: 22.0,
    fontWeight: FontWeight.w800,
    color: Colors.black87,
    letterSpacing: 1.5);

var _fontDescriptionStyle = TextStyle(
    fontFamily: "Sans",
    fontSize: 18.0,
    color: Colors.black38,
    fontWeight: FontWeight.w400);


class _IntroPageState extends State<IntroPage> {


  void afterIntroComplete (){
    nextScreenReplace(context, WelcomePage());
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      new PageViewModel(
          pageColor: Colors.white,
          iconColor: Colors.black,
          bubbleBackgroundColor: Colors.black,
          title: Text(
            'intro-title1',
            textAlign: TextAlign.center,
            style: _fontHeaderStyle,
          ).tr(),
          body: Text('intro-description1'.tr(),
              textAlign: TextAlign.center, style: _fontDescriptionStyle),
          mainImage: Image.asset(
            Config().introImage1,
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          )),
      new PageViewModel(
          pageColor: Colors.white,
          iconColor: Colors.black,
          bubbleBackgroundColor: Colors.black,
          title: Text(
            "intro-title2".tr(),
            textAlign: TextAlign.center,
            style: _fontHeaderStyle,
          ),
          body: Text('intro-description2'.tr(),
              textAlign: TextAlign.center, style: _fontDescriptionStyle),
          mainImage: Image.asset(
            Config().introImage2,
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          )),
      new PageViewModel(
          pageColor: Colors.white,
          iconColor: Colors.black,
          bubbleBackgroundColor: Colors.black,
          title: Text(
            "intro-title3".tr(),
            textAlign: TextAlign.center,
            style: _fontHeaderStyle,
          ),
          body: Text('intro-description3'.tr(),
              textAlign: TextAlign.center, style: _fontDescriptionStyle),
          mainImage: Image.asset(
            Config().introImage3,
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          )),
    ];

    return IntroViewsFlutter(
        pages,
        pageButtonsColor: Colors.black45,
        skipText: Text(
         "skip",
          style: TextStyle(
              color: Colors.grey,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0),
        ).tr(),
        onTapSkipButton: (){
          afterIntroComplete();
        },
        doneText: Text(
            'done',
          style: TextStyle(
              color: Colors.red,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.0),
        ).tr(),
        onTapDoneButton: () {
          afterIntroComplete();
        },

    );
  }


}
