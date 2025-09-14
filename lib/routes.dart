import 'package:flutter/material.dart';
import 'package:ilkkam/pages/CommonUserPage.dart';
import 'package:ilkkam/pages/chat/ChatScreenPage.dart';
import 'package:ilkkam/pages/community/CommuDetailPage.dart';
import 'package:ilkkam/pages/community/CommuWritePage.dart';
import 'package:ilkkam/pages/community/base/page_base.dart';
import 'package:ilkkam/pages/community/base/page_container.dart';
import 'package:ilkkam/pages/main/ApplierDetailPage.dart';
import 'package:ilkkam/pages/main/EditWorkPage.dart';
import 'package:ilkkam/pages/main/EmployerDetailPage.dart';
import 'package:ilkkam/pages/main/NotificationListPage.dart';
import 'package:ilkkam/pages/main/UploadWorkPage.dart';
import 'package:ilkkam/pages/main/WorkListPage.dart';
import 'package:ilkkam/pages/main/base/page_base.dart';
import 'package:ilkkam/pages/main/base/page_container.dart';
import 'package:ilkkam/pages/main/WorkDetailpage.dart';
import 'package:ilkkam/pages/myPage/CSPage.dart';
import 'package:ilkkam/pages/myPage/MyApplyWorkList.dart';
import 'package:ilkkam/pages/myPage/MyPage.dart';
import 'package:ilkkam/pages/myPage/MyWorkList.dart';
import 'package:ilkkam/pages/myPage/ProfileEditPage.dart';
import 'package:ilkkam/pages/register/LandingPage.dart';
import 'package:ilkkam/pages/register/RegisterInfoInputPage.dart';
import 'package:ilkkam/pages/tabContainer.dart';
import 'package:ilkkam/pages/consent/ConsentPage.dart';


import 'pages/community/CommuEditPage.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      // 회원가입
      LandingPage.routeName: (context) => LandingPage(),
      RegisterInfoInputPage.routeName: (context) => RegisterInfoInputPage(),
      ConsentPage.routeName: (context) => ConsentPage(),

      TabContainer.routeName: (context) => TabContainer(),
      // 유저 정보 페이지
      CommonUserPage.routeName : (context) => CommonUserPage(),
      // '/register': (context) => RegisterNavigator(),
      // 일깜 탭
      UploadWorkPage.routeName: (context) =>
          PageContainer(pageType: PageType.UploadWork),
      EditWorkPage.routeName:(context) =>
          PageContainer(pageType: PageType.EditWork),
      WorkListPage.routeName: (context) =>
          PageContainer(pageType: PageType.WorkList),
      NotificationListPage.routeName: (context) =>
          PageContainer(pageType: PageType.Notification),
      WorkDetailPage.routeName: (context) =>
          PageContainer(pageType: PageType.WorkDetail),
      EmployerDetailPage.routeName: (context) =>
          PageContainer(pageType: PageType.Employer),
      ApplierDetailPage.routeName: (context) =>
          PageContainer(pageType: PageType.Applier),

      // 채팅 페이지
      ChatScreen.routeName: (context) => ChatScreen(),

      // 커뮤니티
      CommuWritePage.routeName: (context) =>
          CommPageContainer(pageType: CommPageType.Write),
      CommuDetailPage.routeName: (context) =>
          CommPageContainer(pageType: CommPageType.Detail),
      CommuEditPage.routeName: (context) =>
          CommPageContainer(pageType: CommPageType.Edit),

      //   마이페이지
      MyPage.routeName : (context) => MyPage(),
      CsPage.routeName : (context) => CsPage(),
      MyWorkList.routeName: (context) => MyWorkList(),
      MyApplyWorkList.routeName: (context) => MyApplyWorkList(),
      ProfileEditPage.routeName: (context) => ProfileEditPage(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    // 추가적인 라우트 로직을 구현할 수 있습니다.
    return null;
  }

  static Route<dynamic> onUnknownRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('404 Not Found'),
        ),
      ),
    );
  }
}
