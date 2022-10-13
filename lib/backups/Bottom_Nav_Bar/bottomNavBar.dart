import 'package:cmer_infoline/blocs/notification_bloc.dart';
import 'package:cmer_infoline/blocs/theme_bloc.dart';
import 'package:cmer_infoline/pages/bookmarks.dart';
import 'package:cmer_infoline/pages/categories.dart';
import 'package:cmer_infoline/pages/explore.dart';
import 'package:cmer_infoline/pages/home.dart';
import 'package:cmer_infoline/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'custom_nav_bar.dart';
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  final String? userID;
  BottomNavBar({this.userID});

  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int currentIndex = 0;
  Widget callPage(int current) {
    switch (current) {
      case 0:
        return new Explore();
        break;
      case 1:
        return new Categories();
        break;
      case 2:
        return new BookmarkPage();
        break;
      case 3:
        return new ProfilePage(
        );
        break;
      default:
        return new HomePage(
          //userID: widget.userID,
        );
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0))
        .then((value) async{
      await context.read<NotificationBloc>().initFirebasePushNotification(context)
          .then((value) => context.read<NotificationBloc>().handleNotificationlength())
          .then((value)async{

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.read<ThemeBloc>().darkTheme == true ? Colors.black:Colors.white,
      body: callPage(currentIndex),
      bottomNavigationBar: BottomNavigationDotBar(
          activeColor: Colors.green,
          key: _scaffoldkey,
          color: context.read<ThemeBloc>().darkTheme == true ? Colors.white:Colors.black54,
          items: <BottomNavigationDotBarItem>[
            BottomNavigationDotBarItem(
                icon: IconData(0xe900, fontFamily: 'home'),
                onTap: () {
                  setState(() {
                    currentIndex = 0;
                  });
                }),
            BottomNavigationDotBarItem(
                icon: IconData(0xe900, fontFamily: 'category'),
                onTap: () {
                  setState(() {
                    currentIndex = 1;
                  });
                }),
            BottomNavigationDotBarItem(
                icon: Feather.bookmark,
                onTap: () {
                  setState(() {
                    currentIndex = 2;
                  });
                }),
            BottomNavigationDotBarItem(
                icon: IconData(
                  0xe900,
                  fontFamily: 'profile',
                ),
                onTap: () {
                  setState(() {
                    currentIndex = 3;
                  });
                }),
          ]),
    );
  }
}
