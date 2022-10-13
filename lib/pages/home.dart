import 'package:cmer_infoline/pages/bookmarks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:cmer_infoline/blocs/ads_bloc.dart';
import 'package:cmer_infoline/blocs/notification_bloc.dart';
import 'package:cmer_infoline/pages/categories.dart';
import 'package:cmer_infoline/pages/explore.dart';
import 'package:cmer_infoline/pages/profile.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;
  PageController _pageController = PageController();

  List<IconData> iconList = [
    const IconData(0xe900, fontFamily: 'home'),
    const IconData(0xe900, fontFamily: 'category'),
    Feather.bookmark,
    const IconData(0xe900, fontFamily: 'profile',),
  ];


  void onTabTapped(int index) {
    setState(() {
     _currentIndex = index;
     
    });
    _pageController.animateToPage(index,
      curve: Curves.easeIn,
      duration: Duration(milliseconds: 250));
   
  }



 @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
    .then((value) async{
      final adb = context.read<AdsBloc>();
      await context.read<NotificationBloc>().initFirebasePushNotification(context)
      .then((value) => context.read<NotificationBloc>().handleNotificationlength())
      .then((value) => adb.checkAdsEnable())
      .then((value)async{
        if(adb.interstitialAdEnabled == true || adb.bannerAdEnabled == true){
          adb.initiateAds();
        }
      });
    });
  }



  


  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future _onWillPop () async{
    if(_currentIndex != 0){
      setState (()=> _currentIndex = 0);
      _pageController.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    }else{
      await SystemChannels.platform.invokeMethod<void>('SystemNavigator.pop', true);
    }
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => await _onWillPop(),
      child: Scaffold(
        bottomNavigationBar: _bottomNavigationBar(),
        body: PageView(
          controller: _pageController,
          allowImplicitScrolling: false,
          physics: NeverScrollableScrollPhysics(),  
          children: <Widget>[
            Explore(),
            Categories(),
            BookmarkPage(),
            ProfilePage()
          ],
        ),
      ),
    );
  }



  BottomNavigationBar _bottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) => onTabTapped(index),
      currentIndex: _currentIndex,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      iconSize: 25,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w500),
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(iconList[0]),
          label: ""

        ),

        BottomNavigationBarItem(
          icon: Icon(iconList[1], size: 25,),
          label: ""

        ),

        BottomNavigationBarItem(
            icon: Icon(iconList[2]),
            label: ""

        ),

        BottomNavigationBarItem(
          icon: Icon(iconList[3]),
          label: ""

        )
      ],
    );
  }
}