import 'package:flutter/material.dart';
import 'package:ilkkam/navigations/NavigatorObserver.dart';
import 'package:ilkkam/pages/main/ApplierDetailPage.dart';
import 'package:ilkkam/pages/main/EmployerDetailPage.dart';
import 'package:ilkkam/pages/main/LandingPage.dart';
import 'package:ilkkam/pages/main/NotificationListPage.dart';
import 'package:ilkkam/pages/main/UploadWorkPage.dart';
import 'package:ilkkam/pages/main/WorkDetailpage.dart';
import 'package:ilkkam/pages/main/WorkListPage.dart';
import 'package:ilkkam/pages/main/base/page_base.dart';
import 'package:ilkkam/pages/main/base/page_container.dart';
import 'package:ilkkam/providers/TabController.dart';
import 'package:provider/provider.dart';

class MainNavigator extends StatefulWidget {
  @override
  _MainNavigatorState createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabUIController>(context, listen: false);

    return Navigator(
      initialRoute: '/',
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
                // case '/':
                //   return ;

                default:
                  return PageContainer(pageType: PageType.Landing);
              }
            });
      },
    );
  }
}