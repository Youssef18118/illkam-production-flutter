import 'package:flutter/cupertino.dart';
import 'package:ilkkam/pages/chat/ChatListPage.dart';
import 'package:ilkkam/pages/community/CommuListPage.dart';
import 'package:ilkkam/providers/TabController.dart';
import 'package:provider/provider.dart';

class MyNavigatorObserver extends NavigatorObserver {
  final Function onRouteChanged;
  final TabUIController tabUIController;

  MyNavigatorObserver({required this.onRouteChanged, required this.tabUIController});

  

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    onRouteChanged(route);
    Future.delayed(Duration(microseconds: 500)).then((v){

      if([
        "/","CommuListpage","/main"
      ].contains(route.settings.name)){
        tabUIController.setVisibility(true);
      }else{
        tabUIController.setVisibility(false);
      }
    });

  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);

    onRouteChanged(previousRoute);
    print(previousRoute?.settings.name == CommuListpage.routeName);
    Future.delayed(Duration(microseconds: 500)).then((v){
      if([
        "/",CommuListpage.routeName,"/main"
      ].contains(previousRoute?.settings.name)){
        tabUIController.setVisibility(true);
      }else{
        tabUIController.setVisibility(false);
      }
    });

  }
}