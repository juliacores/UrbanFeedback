import 'package:flutter/material.dart';


class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  BottomNavBar({
    @required this.currentIndex,
  });

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  // Copyright 2021 Roman Kores. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
  int lenght = 100;
  int curPos = 0;
  double screenWidth;
  String title = '';
  bool playing = false;
  bool unchecked = true;

  @override
  initState(){
    unchecked = true;
    super.initState();
  }

  onTabTapped(int index) {
    var routeName = '/';
    Widget screen;
    switch (index) {
      case 0:
        screen = AllCoursesScreen();
        routeName = AllCoursesScreen.routeName;
        break;
      case 1:
        screen = MyCoursesScreen();
        routeName = MyCoursesScreen.routeName;
        break;
      case 2:
        screen = ProfileScreen();
        routeName = ProfileScreen.routeName;
        break;
      default:
        break;
    }
    //Navigator.pushNamed(context, routeName);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => screen,
        transitionDuration: Duration(seconds: 0),
      ),
    );
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {

    screenWidth = MediaQuery.of(context).size.width;

    return Container(
        color: Colors.white30,
        child:
        SafeArea(
            maintainBottomViewPadding: true,
            child: SizedBox(
              height: 56,
              width: double.infinity,
              //height: 100,
              child:
                  BottomNavigationBar(
                    onTap: onTabTapped,
                    currentIndex: widget.currentIndex,
                    elevation: 0,
                    backgroundColor: Colors.white30,
                    selectedLabelStyle: Constants().textStyleBottomNavBarSelected,
                    unselectedLabelStyle: Constants().textStyleBottomNavBarUnselected,
                    iconSize: Constants().bottomNavBarIconSize,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(false
                            ? CustomIcons.discover
                            : Icons.home_outlined),
                        label: false ? 'Discover' : 'Home',
                        backgroundColor: ColorConstants.white,
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CustomIcons.play),
                        label: 'My courses',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(CustomIcons.person),
                        label: 'Profile',
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}