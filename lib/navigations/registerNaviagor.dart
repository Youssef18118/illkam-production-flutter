import 'package:flutter/material.dart';
import 'package:ilkkam/pages/register/LandingPage.dart';
import 'package:ilkkam/pages/register/RegisterInfoInputPage.dart';

class RegisterNavigator extends StatefulWidget {
  @override
  _RegisterNavigatorState createState() => _RegisterNavigatorState();
}

class _RegisterNavigatorState extends State<RegisterNavigator> {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      initialRoute: '/',
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
            settings: settings,

            builder: (BuildContext context) {
              switch (settings.name) {
                default:
                  return LandingPage();
              }
            });
      },
    );
  }
}