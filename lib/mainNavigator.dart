import 'package:flutter/material.dart';
import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/navigations/registerNaviagor.dart';
import 'package:ilkkam/pages/tabContainer.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({super.key});
  BaseAPI baseAPI = BaseAPI();

  @override
  Widget build(BuildContext context) {
    return  Consumer<UserController>(
      builder: (context, provider, child) {
        bool isLogin = provider.isLogIn;

        return isLogin ? TabContainer() : RegisterNavigator();
      },
    );
  }
}
