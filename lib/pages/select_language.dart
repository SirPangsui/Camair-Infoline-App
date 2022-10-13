import 'package:cmer_infoline/config/config.dart';
import 'package:cmer_infoline/pages/intro.dart';
import 'package:cmer_infoline/utils/next_screen.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:line_icons/line_icons.dart';

class SelectLanguageHome extends StatefulWidget {
  const SelectLanguageHome({Key? key}) : super(key: key);

  @override
  _SelectLanguageHomeState createState() => _SelectLanguageHomeState();
}

class _SelectLanguageHomeState extends State<SelectLanguageHome> with TickerProviderStateMixin{
  @override

  /// Declare Animation
  AnimationController? animationController;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  var tapLanguage = 0;

  List _languages=["English", "Français"];

  @override
  /// Declare animation in initState
  void initState() {
    // TODO: implement initState
    /// Animation proses duration
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300))
      ..addStatusListener((statuss) {
        if (statuss == AnimationStatus.dismissed) {
          setState(() {
            tapLanguage = 0;
          });
        }
      });
    super.initState();
  }

  /// To dispose animation controller
  @override
  void dispose() {
    super.dispose();
    animationController!.dispose();
  }

  /// Play animation set forward reverse
  Future<Null> _Playanimation() async {
    try {
      await animationController!.forward();
      await animationController!.reverse();
    } on TickerCanceled {}
  }


  Widget build(BuildContext context) {
    double height = MediaQuery. of(context). size. height ;
    return Scaffold(
      body : tapLanguage==0? Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Spacer(),
          Image(
            image: AssetImage(Config().splashIcon),
            height: 120,
            width: 120,
            fit: BoxFit.contain,
          ),

          SizedBox(
            height: 20,
          ),

          Text('select language',style: TextStyle(fontSize: 20),).tr(),

          SizedBox(
            height: 20,
          ),

          //English Language Section
          Divider(height: 4, color: Config().appColorRed,),

          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LineIcons.globe, color: Config().appColorGreen, ),
                  SizedBox(width: 10,),
                  Text("English", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                ],
              ),
            ),
            onTap: () async{
                context.setLocale(Locale('en'));
                setState(() {
                  tapLanguage = 1;
                });
                _Playanimation();
              //nextScreenReplace(context, IntroPage());
            },
          ),

          Divider(height: 4, color: Config().appColorRed,),

          ///French Language Section
          Divider(height: 4, color: Config().appColorRed,),

          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(LineIcons.globe, color: Config().appColorGreen, ),
                  SizedBox(width: 10,),
                  Text("Français", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),),
                ],
              ),
            ),
            onTap: () async{
              context.setLocale(Locale('fr'));
              setState(() {
                tapLanguage = 1;
              });
              _Playanimation();
              //nextScreenReplace(context, IntroPage());
            },
          ),

          Divider(height: 4, color: Config().appColorRed,),

          //Company Name
          Spacer(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Nchimsy',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: 5,),
              Text(
                'Teq',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          )


        ],
      ):SingleChildScrollView(child: AnimationSplashSignup(scaffoldKey, animationController)),
    );
  }

}


/// Set Animation signup if user click button signup
class AnimationSplashSignup extends StatefulWidget {

  final AnimationController? animationController;
  final Animation? animation;

  AnimationSplashSignup(Key key, this.animationController) : animation = new Tween(
    end:900.0,
    begin: 50.0,
  ).animate(CurvedAnimation(
      parent: animationController!, curve: Curves.easeInOut)), super(key: key);



  Widget _buildAnimation(BuildContext? context, Widget? child) {
    return Padding(
      padding: EdgeInsets.only(bottom: 60.0),
      child: Container(
        height: animation!.value,
        width: animation!.value,
        decoration: BoxDecoration(
          color: Colors.green,
          shape: animation!.value < 600 ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }

  @override
  _AnimationSplashSignupState createState() => _AnimationSplashSignupState();
}

/// Set Animation signup if user click button signup
class _AnimationSplashSignupState extends State<AnimationSplashSignup> {
  @override
  Widget build(BuildContext context) {
    widget.animationController!.addListener(() {
      if (widget.animation!.isCompleted) {
      nextScreenReplace(context, IntroPage());
      }
    });
    return AnimatedBuilder(
      animation: widget.animationController!,
      builder: (widget._buildAnimation),
    );
  }
}