import 'package:cmer_infoline/libraries/loader_animation/dot.dart';
import 'package:cmer_infoline/libraries/loader_animation/loader.dart';
import 'package:cmer_infoline/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:cmer_infoline/utils/next_screen.dart';

class DonePage extends StatefulWidget {
  const DonePage({Key? key}) : super(key: key);

  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {


  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 2000))
    .then((value) => nextScreenCloseOthers(context, HomePage()));
    super.initState();
  }


  
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
          child: ColorLoader5(
            dotOneColor: Colors.green,
            dotTwoColor: Colors.red,
            dotThreeColor: Colors.yellow,
            dotType: DotType.circle,
            dotIcon: Icon(Icons.adjust),
            duration: Duration(seconds: 1),
          )),
    );
  }
}