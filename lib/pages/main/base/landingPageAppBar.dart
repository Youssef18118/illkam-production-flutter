import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/apis/usersAPI.dart';
import 'package:ilkkam/models/req/UsersSaveReq.dart';
import 'package:ilkkam/pages/main/NotificationListPage.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/utils/styles.dart';

class LandingPageAppBar extends StatefulWidget {
  const LandingPageAppBar({super.key});

  @override
  State<LandingPageAppBar> createState() => _LandingPageAppBarState();
}

class _LandingPageAppBarState extends State<LandingPageAppBar> {
  UsersService usersService = UsersService();
  Users? user;

  @override
  void initState() {
    usersService.getUserData().then((value) {
      setState(() {
        user = value;
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: SafeArea(
          child: Padding(padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: ShapeDecoration(
                      color: Color(0xFFD3F5FF),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    child: Text('기업회원', textAlign: TextAlign.center, style: label),
                  ),
                  const SizedBox(width: 14),
                  Text(user?.name ?? '',
                      textAlign: TextAlign.center, style: IKTextStyle.landing_name),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(NotificationListPage.routeName);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(),
                  child: SvgPicture.asset(
                    "assets/main/alarm_ico.svg",
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),)),
    );
  }

  TextStyle label = TextStyle(
    color: Color(0xFF015B75),
    fontSize: 13,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w600,
    letterSpacing: -0.13,
  );
}
