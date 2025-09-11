import 'package:flutter/material.dart';
import 'package:ilkkam/pages/myPage/MyWorkList.dart';
import 'package:ilkkam/providers/chats/ChatsController.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/mypage/workList.dart';
import 'package:provider/provider.dart';

class MyApplyWorkList extends StatefulWidget {
  const MyApplyWorkList({super.key});
  static const routeName = "/my/work/apply";

  @override
  State<MyApplyWorkList> createState() => _MyApplyWorkListState();
}

class _MyApplyWorkListState extends State<MyApplyWorkList> with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    Provider.of<ChatsController>(context, listen: false).initialize(context);
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() {
      setState(() {});
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    WorkController workController = Provider.of<WorkController>(context);
    UserController userController = Provider.of<UserController>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            // padding: EdgeInsets.symmetric(horizontal: 20),
            child: TabBar(
                controller: tabController,
                indicatorColor: AppColors.primary,
                indicatorSize: TabBarIndicatorSize.tab,
                labelStyle: TextStyle(
                  color: Color(0xFFFF7247),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
                unselectedLabelStyle: TextStyle(
                  color: Color(0xFFADADAD),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
                dividerColor: Color(0xFFE0E0E0),
                tabs: [
                  Tab(
                    text: "신청기록",
                  ),
                  Tab(
                    text: "확정기록",
                  )
                ]),
          ),
          Expanded(
            child: TabBarView(controller: tabController, children: [
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: MyPageWorkList(works: workController.myEmployeeWork.where((elem) => elem.employee?.id !=  userController.id).toList()),
                ),
              )
              ,
              SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: MyPageWorkList(works: workController.myEmployeeWork.where((elem) => elem.employee?.id ==  userController.id).toList()),
                ),
              )
            ]),
          )
        ],
      ),
    );
  }
}
