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
import 'package:ilkkam/widgets/IKBtmBar.dart';
import 'package:provider/provider.dart';
import 'package:ilkkam/providers/users/UserController.dart'; 

import 'chat/ChatListPage.dart';
import 'community/base/page_base.dart';
import 'community/base/page_container.dart';
import 'main/base/page_base.dart';
import 'main/base/page_container.dart';
import 'myPage/MyPage.dart';

// class TabContainer extends StatefulWidget {
//   static const routeName = "/main";

//   @override
//   _TabContainerState createState() => _TabContainerState();
// }

// class _TabContainerState extends State<TabContainer> {
//   int _selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     return PopScope(
//         canPop: false,
//         onPopInvokedWithResult: (isPop, result) {
//           if (_selectedIndex != 0) {
//             setState(() {
//               _selectedIndex = 0;
//             });
//           } else {
//             exit(0);
//           }
//           print("is Pops is $isPop");
//         },
//         child: Scaffold(
//           extendBody: true,
//           floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//           floatingActionButton:  Consumer<TabUIController>(
//             builder: (context, provider, child) {
//               return provider.visible
//                   ? Container(
//                 // margin: EdgeInsets.symmetric(horizontal: 12),
//                 decoration: BoxDecoration(
//                   // color: Color(0xFFFAFAFA),
//                   color: Colors.white,
//                   border: Border(
//                     top: BorderSide(width: 1, color: Color(0xFFEAEAEA)),
//                   ),
//                 ),
//                 padding: EdgeInsets.only(left: 20, right: 20, top: 12),
//                 child: Ikbtmbar(
//                     items: <BottomNavigationBarItem>[
//                       BottomNavigationBarItem(
//                           icon: SvgPicture.asset(
//                             "assets/common/btb-illkam.svg",
//                           ),
//                           label: "일깜"),
//                       BottomNavigationBarItem(
//                           icon: SvgPicture.asset(
//                             "assets/common/btb-commu.svg",
//                           ),
//                           label: "커뮤니티"),
//                       BottomNavigationBarItem(
//                           icon: SvgPicture.asset(
//                             "assets/common/btb-chat.svg",
//                           ),
//                           label: "채팅"),
//                       BottomNavigationBarItem(
//                           icon: SvgPicture.asset(
//                             "assets/common/btb-my.svg",
//                           ),
//                           label: "마이")
//                     ],
//                     currentIndex: _selectedIndex,
//                     onTap: (int index) {
//                       setState(() {
//                         _selectedIndex = index;
//                         if (index == 2) {
//                           Provider.of<ChatsController>(context,
//                               listen: false)
//                               .initialize();
//                         }
//                       });
//                     }),
//               )
//                   : Container();
//             },
//           ),
//           body: SafeArea(
//             top: false,
//             child: IndexedStack(
//               index: _selectedIndex,
//               children: <Widget>[
//                 PageContainer(pageType: PageType.Landing),
//                 CommPageContainer(pageType: CommPageType.List),
//                 ChatListPage(),
//                 MyPage(),
//               ],
//             ),
//           ),
//         ));
//   }
// }





class TabContainer extends StatefulWidget {
  static const routeName = "/main";

  @override
  _TabContainerState createState() => _TabContainerState();
}

class _TabContainerState extends State<TabContainer> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Get the user controller to check the login status
    final userController = Provider.of<UserController>(context, listen: false);

    // Define which tabs are protected (2 for Chat, 3 for My Page)
    final bool isProtectedTab = (index == 2 || index == 3);

    // Check if the user is a guest AND is trying to access a protected tab
    if (isProtectedTab && !userController.isLogIn) {
      // If so, redirect them to the login page
      Navigator.pushNamed(context, LandingPage.routeName);
    } else {
      // Otherwise, allow navigation to the selected tab
      setState(() {
        _selectedIndex = index;
        // Keep existing logic for initializing chats when the tab is selected
        if (index == 2) {
          Provider.of<ChatsController>(context, listen: false).initialize(context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
        extendBody: true,
        // ... floatingActionButtonLocation and floatingActionButton remain the same
        floatingActionButton: Consumer<TabUIController>(
          builder: (context, provider, child) {
            return provider.visible
                ? Container(
                    // ... Container properties
                    padding: EdgeInsets.only(left: 20, right: 20, top: 12),
                    child: Ikbtmbar(
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                              icon: SvgPicture.asset("assets/common/btb-illkam.svg"),
                              label: "일깜"),
                          BottomNavigationBarItem(
                              icon: SvgPicture.asset("assets/common/btb-commu.svg"),
                              label: "커뮤니티"),
                          BottomNavigationBarItem(
                              icon: SvgPicture.asset("assets/common/btb-chat.svg"),
                              label: "채팅"),
                          BottomNavigationBarItem(
                              icon: SvgPicture.asset("assets/common/btb-my.svg"),
                              label: "마이")
                        ],
                        currentIndex: _selectedIndex,
                        // Use the new handler function
                        onTap: _onItemTapped), 
                  )
                : Container();
          },
        ),
        body: SafeArea(
          top: false,
          child: IndexedStack(
            index: _selectedIndex,
            children: <Widget>[
              PageContainer(pageType: PageType.Landing),
              CommPageContainer(pageType: CommPageType.List),
              ChatListPage(),
              MyPage(),
            ],
          ),
        ),
      ),
    );
  }
}
