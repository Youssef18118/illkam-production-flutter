import 'package:flutter/material.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/widgets/mypage/workList.dart';
import 'package:provider/provider.dart';

class MyWorkList extends StatefulWidget {
  static const routeName = "/my/work";

  const MyWorkList({super.key});

  @override
  State<MyWorkList> createState() => _MyWorkListState();
}

class _MyWorkListState extends State<MyWorkList> {
  @override
  Widget build(BuildContext context) {
    List<Work> works =Provider.of<WorkController>(context).myWorks;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: Container(
              padding: EdgeInsets.all(20),
              child: MyPageWorkList(works: works))),
    );
  }
}
