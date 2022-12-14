import 'package:cmer_infoline/config/config.dart';
import 'package:flutter/material.dart';

class AppName extends StatelessWidget {
  final double fontSize;
  const AppName({Key? key, required this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Camer',   //first part
        style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            color: Config().appColorGreen),
        children: <TextSpan>[
          TextSpan(
              text: 'Infoline',  //second part
              style:
                  TextStyle(fontFamily: 'Poppins', color: Colors.red)),
        ],
      ),
    );
  }
}
