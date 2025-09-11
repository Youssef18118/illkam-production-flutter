import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:ilkkam/navigations/NavigatorObserver.dart';
import 'package:ilkkam/pages/chat/ChatListPage.dart';
import 'package:ilkkam/pages/chat/ChatScreenPage.dart';
import 'package:ilkkam/providers/TabController.dart';
import 'package:provider/provider.dart';

class ChatNavigator extends StatefulWidget {
  @override
  _ChatNavigatorState createState() => _ChatNavigatorState();
}

class _ChatNavigatorState extends State<ChatNavigator> {

  @override
  Widget build(BuildContext context) {
    final tab = Provider.of<TabUIController>(context, listen: false);
    return Navigator(
      observers: [
        MyNavigatorObserver(
            onRouteChanged: (route) {
              // 경로가 변경될 때 실행할 함수
              log('Route changed to: ${route?.settings.name}');
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
                //   return
                default:
                  return ChatListPage();
              }
            });
      },
    );
  }
}