import 'package:flutter/material.dart';
import 'package:ilkkam/pages/main/ApplierDetailPage.dart';
import 'package:ilkkam/pages/main/EditWorkPage.dart';
import 'package:ilkkam/pages/main/EmployerDetailPage.dart';
import 'package:ilkkam/pages/main/NotificationListPage.dart';
import 'package:ilkkam/pages/main/base/landingPageAppBar.dart';
import 'package:ilkkam/pages/main/base/page_base.dart';
import 'package:ilkkam/pages/main/LandingPage.dart';
import 'package:ilkkam/pages/main/UploadWorkPage.dart';
import 'package:ilkkam/pages/main/WorkDetailpage.dart';
import 'package:ilkkam/pages/main/WorkListPage.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/TextTitleBar.dart';

class PageContainer extends PageContainerBase {
  final PageType pageType;

  PageContainer({Key? key, required this.pageType}) : super(key: key);

  @override
  bool get useAppbar {
    switch (pageType) {
      case PageType.WorkList:
        return true;
      case PageType.WorkDetail:
        return true;
      default:
        return true;
    }
  }

  @override
  // TODO: implement appbar
  PreferredSizeWidget get appbar {
    switch (pageType) {
      case PageType.Landing:
        return PreferredSize(
            preferredSize: Size.fromHeight(80), child: LandingPageAppBar());
      case PageType.WorkList:
        return AppBar(
          elevation: 0,
          title: Text(""),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        );
      case PageType.UploadWork:
        return AppBar(
          elevation: 0,
          title: Row(
            children: [
              Text(
                "일깜",
                style: IKTextStyle.appMainText,
              ),
              Text(" 등록하기",style: TextStyle(
                color: Color(0xFF121212),
                fontSize: 19,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),)
            ],
          ),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        );
      case PageType.EditWork:
        return AppBar(
          elevation: 0,
          title: Row(
            children: [
              Text(
                "일깜",
                style: IKTextStyle.appMainText,
              ),
              Text(" 수정하기",style: TextStyle(
                color: Color(0xFF121212),
                fontSize: 19,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),)
            ],
          ),
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        );

      case PageType.WorkDetail:
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,

        );

      case PageType.Employer:
        return  TextTitleBar(title: "");
      case PageType.Applier:
        return TextTitleBar(title: "");
      case PageType.Notification:
        return TextTitleBar(title: "알림 내역");
      default:
        return PreferredSize(
            preferredSize: Size.fromHeight(134), child: LandingPageAppBar());
    }
  }

  @override
  Widget get body {
    switch (pageType) {
      case PageType.Landing:
        return MainHomePage();
      case PageType.UploadWork:
        return UploadWorkPage();
      case PageType.EditWork:
        return EditWorkPage();
      case PageType.WorkDetail:
        return WorkDetailPage();
      case PageType.WorkList:
        return WorkListPage();
      case PageType.Employer:
        return EmployerDetailPage();
      case PageType.Applier:
        return ApplierDetailPage();
      case PageType.Notification:
        return NotificationListPage();
      default:
        return Placeholder();
    }
  }

  @override
  List<Widget> get actions {
    switch (pageType) {
      default:
        return [];
    }
  }

  @override
  Widget get background => Container();

  @override
  Color get backgroundColor {
    switch (pageType) {
      default:
        return Colors.white;
    }
  }

  @override
  Widget get title {
    switch (pageType) {
      default:
        return Text(
          "일깜",
          style: IKTextStyle.appBarTitle,
        );

      // T;
    }
  }

  Widget leadingBackBtn(BuildContext context) => MaterialButton(onPressed: () {
        Navigator.of(context).pop();
      });


}
