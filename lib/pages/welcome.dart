import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cmer_infoline/blocs/sign_in_bloc.dart';
import 'package:cmer_infoline/config/config.dart';
import 'package:cmer_infoline/pages/done.dart';
import 'package:cmer_infoline/pages/sign_up.dart';
import 'package:cmer_infoline/services/app_service.dart';
import 'package:cmer_infoline/utils/app_name.dart';
import 'package:cmer_infoline/utils/next_screen.dart';
import 'package:cmer_infoline/utils/snacbar.dart';
import 'package:provider/provider.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import '../widgets/language.dart';
import 'done.dart';
import 'package:easy_localization/easy_localization.dart';



class WelcomePage extends StatefulWidget {
  final String? tag;
  const WelcomePage({Key? key, this.tag}) : super(key: key);

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {


  var scaffoldKey = GlobalKey<ScaffoldState>();
  final RoundedLoadingButtonController _googleController = new RoundedLoadingButtonController();
  final RoundedLoadingButtonController _appleController = new RoundedLoadingButtonController();
  final Future<bool> _isAvailableFuture = TheAppleSignIn.isAvailable();
 

  handleSkip (){
    final sb = context.read<SignInBloc>();
    sb.setGuestUser();
    sb.setSignIn();
    nextScreen(context, DonePage());
    
  }


  



  handleGoogleSignIn() async{
    final SignInBloc sb = Provider.of<SignInBloc>(context, listen: false);
    await AppService().checkInternet().then((hasInternet)async{
      if(hasInternet == false){
        openSnacbar(scaffoldKey, 'check your internet connection!'.tr());
      }
      else{
        await sb.signInWithGoogle().then((_){
        if(sb.hasError == true){
          openSnacbar(scaffoldKey, 'something is wrong. please try again.'.tr());
          _googleController.reset();

        }else {
          sb.checkUserExists().then((value){
          if(value == true){
            sb.getUserDatafromFirebase(sb.uid)
            .then((value) => sb.guestSignout())
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.setSignIn()
            .then((value){
              _googleController.success();
              handleAfterSignIn();
            })));
          } else{
            sb.getTimestamp()
            .then((value) => sb.saveToFirebase()
            .then((value) => sb.increaseUserCount())
            .then((value) => sb.guestSignout())
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.setSignIn()
            .then((value){
              _googleController.success();
              handleAfterSignIn();
            }))));
          }
            });
          
        }
      });   
      }
    });
  }






  handleAppleSignIn() async{
    final sb = context.read<SignInBloc>();
    await AppService().checkInternet().then((hasInternet)async{
      if(hasInternet == false){
        openSnacbar(scaffoldKey, 'check your internet connection!'.tr());
      }
      else{
        await sb.signInWithApple().then((_){
        if(sb.hasError == true){
          openSnacbar(scaffoldKey, 'something is wrong. please try again.'.tr());
          _appleController.reset();

        }else {
          sb.checkUserExists().then((value){
          if(value == true){
            sb.getUserDatafromFirebase(sb.uid)
            .then((value) => sb.guestSignout())
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.setSignIn()
            .then((value){
              _appleController.success();
              handleAfterSignIn();
            })));
          } else{
            sb.getTimestamp()
            .then((value) => sb.saveToFirebase()
            .then((value) => sb.increaseUserCount())
            .then((value) => sb.saveDataToSP()
            .then((value) => sb.guestSignout()
            .then((value) => sb.setSignIn()
            .then((value){
              _appleController.success();
              handleAfterSignIn();
            })))));
          }
            });
          
        }
      });   
      }
    });
  }



  handleAfterSignIn (){
    setState(() {
      Future.delayed(Duration(milliseconds: 1000)).then((f){
        final sb = context.read<SignInBloc>();
        sb.setSignIn();
      gotoNextScreen();
      });
    });
  }



  gotoNextScreen (){
    if(widget.tag == null){
      nextScreen(context, DonePage());
    }else{
      Navigator.pop(context);
    }
  }




  
  
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        actions: [
          widget.tag != null
              ? Container()
              : TextButton(
                  onPressed: () => handleSkip(),
                  child: Text('skip',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      )).tr(),),

          IconButton(
            alignment: Alignment.center,
            padding: EdgeInsets.all(0),
            iconSize: 22,
            icon: Icon(Icons.language,),
            onPressed: (){
              nextScreenPopup(context, LanguagePopup());
            },
          ),
          
        ],
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Flexible(
                flex: 3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage(Config().splashIcon),
                        height: 130,
                      ),
                    SizedBox(height: 50,),
                    Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('welcome to', style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w300, color: Theme.of(context).secondaryHeaderColor
                          ),).tr(),
                          SizedBox(width: 10,),
                          AppName(fontSize: 25),
                        ],
                      ),

                      SizedBox(height: 5,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text('cameroons official news app the number one stop for accurate information'.tr(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15, color: Config().appColorGreen,
                        ),),
                      )
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 30, right: 30, top: 15),
                    child: Text(
                      'sign in to continue',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Config().appColorRed),
                    ).tr(),
                  )
                ],
              ),
                  ],
                )),

            Flexible(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RoundedLoadingButton(

              child: Wrap(
                children: [
                  Icon(FontAwesome.google, size: 25, color: Colors.white,),
                  SizedBox(width: 15,),
                  Text('Sign In with Google', style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white
                  ),)
                ],
              ),
              controller: _googleController,
              onPressed: ()=> handleGoogleSignIn(),
              width: MediaQuery.of(context).size.width * 0.80,
              color: Config().appColorGreen,
              elevation: 0,
              //borderRadius: 3,

            ),


            SizedBox(height: 10,),

            Platform.isAndroid
              ? Container()
              : _appleSignInButton()
              
              
                ],
              ),
            ),
            
            Text("don't have social accounts?").tr(),
            TextButton(
                child: Text('continue with email >>', style: TextStyle(color: Theme.of(context).primaryColor),).tr(),
                onPressed: (){
                  if(widget.tag == null){
                    nextScreen(context, SignUpPage());

                  }else{
                    nextScreen(context, SignUpPage(tag: 'Popup',));
                  }
                
              },
             
            ),
            SizedBox(height: 15,),
            
          ],
        ),
      ),
    );
  }

  FutureBuilder<bool> _appleSignInButton() {
    return FutureBuilder<bool>(
              future: _isAvailableFuture,
              builder: (context, AsyncSnapshot isAvailableSnapshot){
                if (!isAvailableSnapshot.hasData) {
                  return Container();
                }

                return !isAvailableSnapshot.data
                ? Container() 
                : RoundedLoadingButton(
            child: Wrap(
              children: [
                Icon(FontAwesome.apple, size: 25, color: Colors.white,),
                SizedBox(width: 15,),
                Text(' Sign In with Apple', style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white
                ),)
              ],
            ),
            controller: _appleController,
            onPressed: ()=> handleAppleSignIn(),
            width: MediaQuery.of(context).size.width * 0.80,
            color: Colors.grey[800],
            elevation: 0,
            //borderRadius: 10,
          );
              },
            );
  }
  
}