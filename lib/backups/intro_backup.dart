import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:cmer_infoline/blocs/sign_in_bloc.dart';
import 'package:cmer_infoline/config/config.dart';
import 'package:cmer_infoline/pages/home.dart';
import 'package:cmer_infoline/utils/next_screen.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class IntroPageBackup extends StatefulWidget {
  IntroPageBackup({Key? key}) : super(key: key);

  @override
  _IntroPageBackupState createState() => _IntroPageBackupState();
}

class _IntroPageBackupState extends State<IntroPageBackup> {

  
  void afterIntroComplete (){
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    sb.setSignIn();
    nextScreenReplace(context, HomePage());
  }


  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: [
        introPage(context, 'intro-title1', 'intro-description1', Config().introImage1),
        introPage(context, 'intro-title2', 'intro-description2', Config().introImage2),
        introPage(context, 'intro-title3', 'intro-description3', Config().introImage3)
      
      
      
      ],
      onDone: () {
        afterIntroComplete();
      },
      onSkip: () {
        afterIntroComplete();
      },
      globalBackgroundColor: Colors.white,
      showSkipButton: true,
      skip: const Text('skip', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)).tr(),
      next: const Icon(Icons.navigate_next, color: Colors.red,),
      done: const Text("done", style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red,)).tr(),

      dotsDecorator: DotsDecorator(
          size: const Size.square(7.0),
          activeSize: const Size(20.0, 5.0),
          activeColor: Theme.of(context).primaryColor,
          color: Colors.black26,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(5.0))),
    );
  }
}




PageViewModel introPage (context, String title, String subtitle, String image){
  return PageViewModel(

      titleWidget: Column(
        children: <Widget>[
          Text(title, 
          style:  TextStyle(
            fontSize: 22, 
            fontWeight: FontWeight.w800,
            letterSpacing: -0.7,
            wordSpacing: 1,
            color: Colors.black),
          ).tr(),
          SizedBox(height: 8,),
          Container(
            height: 3,
            width: 100,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10)
            ),
          )
        ],
      ),
      
      body: subtitle.tr(),
      image: Center(
        child: Image(
          image: AssetImage(image)
        )
      ),

      decoration: const PageDecoration(
        pageColor: Colors.white,
        bodyTextStyle: TextStyle(color: Colors.black54, fontSize: 17, fontWeight: FontWeight.w500),
        descriptionPadding: EdgeInsets.only(left: 30, right: 30),
        imagePadding: EdgeInsets.all(30),

      ),
    );

}


