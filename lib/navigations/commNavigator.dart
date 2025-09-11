import 'package:flutter/material.dart';
import 'package:ilkkam/navigations/NavigatorObserver.dart';
import 'package:ilkkam/pages/community/CommuDetailPage.dart';
import 'package:ilkkam/pages/community/CommuListPage.dart';
import 'package:ilkkam/pages/community/CommuWritePage.dart';
import 'package:ilkkam/pages/community/base/page_base.dart';
import 'package:ilkkam/pages/community/base/page_container.dart';
import 'package:ilkkam/providers/TabController.dart';
import 'package:provider/provider.dart';

class CommuNavigator extends StatefulWidget {
  @override
  _CommuNavigatorState createState() => _CommuNavigatorState();
}

class _CommuNavigatorState extends State<CommuNavigator> {
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
      initialRoute: CommuListpage.routeName,
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,

            builder: (BuildContext context) {
              switch (settings.name) {
                case CommuListpage.routeName:


                default:
                  return CommPageContainer(pageType: CommPageType.List);
              }
            });
      },
    );
  }
}