import 'package:flutter/material.dart';
import 'package:ilkkam/navigations/NavigatorObserver.dart';
import 'package:ilkkam/pages/main/LandingPage.dart';
import 'package:ilkkam/pages/main/UploadWorkPage.dart';
import 'package:ilkkam/pages/main/WorkDetailpage.dart';
import 'package:ilkkam/pages/main/WorkListPage.dart';
import 'package:ilkkam/pages/myPage/MyPage.dart';
import 'package:ilkkam/pages/myPage/MyWorkList.dart';
import 'package:ilkkam/providers/TabController.dart';
import 'package:provider/provider.dart';

class MyPageNavigator extends StatefulWidget {
  @override
  _MyPageNavigatorState createState() => _MyPageNavigatorState();
}

class _MyPageNavigatorState extends State<MyPageNavigator> {
  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabUIController>(context, listen: false);
    return Navigator(
      observers: [
        MyNavigatorObserver(
            onRouteChanged: (route) {
              // 경로가 변경될 때 실행할 함수
              print('Route changed to: ${route?.settings.name}');
            },
            tabUIController: tab
        ),
      ],
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,
            builder: (BuildContext context) {
              switch (settings.name) {
                case '/':
                  return MyPage();
                default:
                  return MyPage();
              }
            });
      },
    );
  }
}