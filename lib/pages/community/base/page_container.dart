import 'package:flutter/material.dart';
import 'package:ilkkam/pages/community/CommuDetailPage.dart';
import 'package:ilkkam/pages/community/CommuEditPage.dart';
import 'package:ilkkam/pages/community/CommuListPage.dart';
import 'package:ilkkam/pages/community/CommuWritePage.dart';
import 'package:ilkkam/pages/community/base/page_base.dart';
import 'package:ilkkam/utils/styles.dart';

class CommPageContainer extends PageContainerBase {
  final CommPageType pageType;

  CommPageContainer({Key? key, required this.pageType}) : super(key: key);

  @override
  bool get useAppbar{
    switch(pageType){
      case CommPageType.List : return false;
      default:return true;
    }
  }

  @override
  // TODO: implement appbar
  PreferredSizeWidget get appbar {
    switch (pageType) {
      case CommPageType.List:
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
        );
      case CommPageType.Write:
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("게시글 작성하기"),
          scrolledUnderElevation: 0,
        );
      case CommPageType.Detail:

        return AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("게시글 상세보기"),
          scrolledUnderElevation: 0,
        );
      case CommPageType.Edit:
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("게시글 수정하기"),
          scrolledUnderElevation: 0,
        );
      default:
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text("게시글 작성하기"),
          scrolledUnderElevation: 0,
        );
    }
  }

  @override
  Widget get body {
    switch (pageType) {
      case CommPageType.List:
        return CommuListpage();
      case CommPageType.Write:
        return CommuWritePage();
      case CommPageType.Detail:
        return CommuDetailPage();
      case CommPageType.Edit:
        return CommuEditPage();
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
}
