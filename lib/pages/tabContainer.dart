import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/navigations/ChatNavigator.dart';
import 'package:ilkkam/navigations/commNavigator.dart';
import 'package:ilkkam/navigations/mainNavigator.dart';
import 'package:ilkkam/navigations/myPageNavigator.dart';

import 'package:ilkkam/pages/register/LandingPage.dart';
import 'package:ilkkam/providers/TabController.dart';
import 'package:ilkkam/providers/chats/ChatsController.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/utils/version_checker.dart';
import 'package:ilkkam/widgets/IKBtmBar.dart';
import 'package:provider/provider.dart';

import 'chat/ChatListPage.dart';
import 'community/base/page_base.dart';
import 'community/base/page_container.dart';
import 'main/base/page_base.dart';
import 'main/base/page_container.dart';
import 'myPage/MyPage.dart';

class TabContainer extends StatefulWidget {
  static const routeName = "/main";

  const TabContainer({Key? key}) : super(key: key);

  @override
  _TabContainerState createState() => _TabContainerState();
}

class _TabContainerState extends State<TabContainer> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    VersionChecker.checkVersion(context);
  }

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);
    final isGuest = !userController.isLogIn;
    return PopScope(
        canPop: false,
        onPopInvokedWithResult: (isPop, result) {
          if (_selectedIndex != 0) {
            setState(() {
              _selectedIndex = 0;
            });
          } else {
            exit(0);
          }
          print("is Pops is $isPop");
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          extendBody: true,
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton:  Consumer<TabUIController>(
            builder: (context, provider, child) {
              return provider.visible
                  ? Container(
                // margin: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  // color: Color(0xFFFAFAFA),
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(width: 1, color: Color(0xFFEAEAEA)),
                  ),
                ),
                padding: EdgeInsets.only(left: 20, right: 20, top: 12),
                child: Ikbtmbar(
                    items: <BottomNavigationBarItem>[
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            "assets/common/btb-illkam.svg",
                          ),
                          label: "일깜"),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            "assets/common/btb-commu.svg",
                          ),
                          label: "커뮤니티"),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            "assets/common/btb-chat.svg",
                          ),
                          label: "채팅"),
                      BottomNavigationBarItem(
                          icon: SvgPicture.asset(
                            "assets/common/btb-my.svg",
                          ),
                          label: "마이")
                    ],
                    currentIndex: _selectedIndex,
                    onTap: (int index) {
                      // If user is guest and tries to access chat (index 2) or my page (index 3)
                      if (isGuest && (index == 2 || index == 3)) {
                        Navigator.of(context).pushNamed(LandingPage.routeName);
                        return;
                      }

                      setState(() {
                        _selectedIndex = index;
                        if (index == 2) {
                          Provider.of<ChatsController>(context,
                              listen: false)
                              .initialize();
                        }
                      });
                    }),
              )
                  : Container();
            },
          ),
          body: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              PageContainer(pageType: PageType.Landing),
              CommPageContainer(pageType: CommPageType.List),
              isGuest ? Container() : ChatListPage(),
              isGuest ? Container() : MyPage(),
            ],
          ),
        ));
  }
}
