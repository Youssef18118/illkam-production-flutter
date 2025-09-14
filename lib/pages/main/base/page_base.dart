import 'package:flutter/material.dart';

enum PageType { Landing, UploadWork, WorkDetail, WorkList, Employer, Applier, Notification,EditWork }

abstract class PageContainerBase extends StatelessWidget {
  Widget get body;

  Widget get background;

  Color get backgroundColor;

  Widget get title;

  PreferredSizeWidget get appbar;

  bool get useAppbar;

  List<Widget> get actions;

  PageContainerBase({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      // PopScope(
      //
      //   onPopInvoked: (bool as) {
      //     // return false;
      //     // rc.onPopOcurred();
      //   },
      //   child:
        GestureDetector(
          onTap: (){FocusScope.of(context).unfocus();},
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              background,
              Scaffold(
                resizeToAvoidBottomInset: false,
                appBar: useAppbar ? appbar : null,
                backgroundColor: backgroundColor,
                body: SafeArea(child: body),
              ),
            ],
          ),
        )
    // )
    ;
  }
}
