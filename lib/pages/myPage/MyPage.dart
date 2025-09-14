import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/apis/usersAPI.dart';
import 'package:ilkkam/pages/CommonUserPage.dart';
import 'package:ilkkam/pages/myPage/CSPage.dart';
import 'package:ilkkam/pages/myPage/MyApplyWorkList.dart';
import 'package:ilkkam/pages/myPage/MyWorkList.dart';
import 'package:ilkkam/pages/myPage/ProfileEditPage.dart';
import 'package:ilkkam/pages/register/LandingPage.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/utils/CommonDialog.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});
  static const routeName = "/common-cs-page";

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  Users? user;
  UsersService usersService = UsersService();


  @override
  void initState() {
    print('asdf');
    usersService.getUserData().then((v) =>
        setState(() {
          print(v?.toJson());
          user = v;
        }));
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<MenuItemModel> _menus = [
      MenuItemModel(label: '일깜 등록한 기록', onTap: () async {
        await Provider.of<WorkController>(context, listen: false)
            .fetchMyEmployerWork();
        Navigator.of(context).pushNamed(MyWorkList.routeName);
      }),
      MenuItemModel(label: '일깜 신청한 기록', onTap: () async {
        await Provider.of<WorkController>(context, listen: false)
            .fetchMyEmployeeWork();
        Navigator.of(context).pushNamed(MyApplyWorkList.routeName);
      }),
    ];

    double rating = user?.rating ?? 0.0;
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          title: Text(
            '마이 페이지',
            style: TextStyle(
              color: Color(0xFF121212),
              fontSize: 19,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
            ),
          )),
      body: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(color: Colors.white),
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                              CommonUserPage.routeName,
                              arguments: user?.id ?? -1);
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          child: user?.businessCertification != null
                              ? ClipOval(
                            child: Image.network(
                              user!.businessCertification!,
                              fit: BoxFit.fill,
                              width: 60,
                              height: 60,
                            ),
                          )
                              : SvgPicture.asset("assets/main/user_ico.svg",
                              fit: BoxFit.fill, width: 60, height: 60),
                        ),
                      )
                      ,
                      SizedBox(
                        width: 16,
                      ),

                    ],
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pushNamed(
                          ProfileEditPage.routeName);
                    },
                    minWidth: 54,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(width: 1, color: Color(0xFF01A9DB)),
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Text(
                      '정보수정',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF01A9DB),
                        fontSize: 13,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    child: Text(
                      user?.name ?? '',
                      style: TextStyle(
                        color: Color(0xFF242B2E),
                        fontSize: 21,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.21,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Column(
                    children: [
                      Row(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // 꽉 찬 별
                              for (int i = 0; i < fullStars; i++)
                                SvgPicture.asset(
                                  "assets/main/star.svg",
                                ),
                              // 반쪽 별
                              if (hasHalfStar)
                                SvgPicture.asset(
                                  "assets/main/star_half.svg",
                                ),
                            ],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user?.rating == null
                                ? '평점 없음'
                                : "${user?.rating?.toStringAsFixed(1)}",
                            style: TextStyle(
                              color: Color(0xFF191919),
                              fontSize: 17,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 8),
                            width: 1,
                            height: 12,
                            decoration: BoxDecoration(color: Color(0xFFD9D9D9)),
                          ),
                          SvgPicture.asset("assets/main/comment.svg"),
                          const SizedBox(width: 4),
                          Text(
                            user?.reviewCount == null
                                ? '0'
                                : "${user?.reviewCount}",
                            style: TextStyle(
                              color: Color(0xFF191919),
                              fontSize: 17,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    child: Text(
                      DateFormat("yy년 MM월 dd일 가입").format(DateTime.parse(
                          user?.createdDateTime ?? "2024-10-05")),
                      style: TextStyle(
                        color: Color(0xFFA6AEB1),
                        fontSize: 13,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 34,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: ShapeDecoration(
                  color: Color(0xFFF4F4F4),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(left: 4, right: 13),
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/main/history.svg"),
                          const SizedBox(width: 8),
                          Text(
                            '일깜내역 기록',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFF7D7D7D),
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      user?.reviews?.length.toString() ?? "0",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Color(0xFF191919),
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              menu()
            ],
          ),
        ),
      ),
    );
  }

  Widget menu() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '이용내역 기록',
          style: TextStyle(
            color: Color(0xFF191919),
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        _menuItem(MenuItemModel(label: '일깜 등록한 기록', onTap: () async {
          await Provider.of<WorkController>(context, listen: false)
              .fetchMyEmployerWork();
          Navigator.of(context).pushNamed(MyWorkList.routeName);
        })),
        _menuItem(MenuItemModel(label: '일깜 신청한 기록', onTap: () async {
          await Provider.of<WorkController>(context, listen: false)
              .fetchMyEmployeeWork();
          Navigator.of(context).pushNamed(MyApplyWorkList.routeName);
        }),),
        Divider(color: Color(0xFFEAEAEA), height: 16,),
        Text(
          '고객지원',
          style: TextStyle(
            color: Color(0xFF191919),
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        _menuItem(MenuItemModel(label: '고객센터', onTap: () async {
          Navigator.of(context).pushNamed(CsPage.routeName);
        })),
        Divider(color: Color(0xFFEAEAEA), height: 16,),
        _menuTitle((){showTwoButtonDialog(context, "로그아웃", "정말 로그아웃할까요?", (){}, ()async {
            await Provider.of<UserController>(context, listen: false).signOut();
            Navigator.of(context).pushNamedAndRemoveUntil("/main", (route)=> false);
        });}, "로그아웃"),
        _menuTitle(() {
          showTwoButtonDialog(context, "회원탈퇴", "정말 회원탈퇴하시겠습니까? 모든 정보가 삭제되며 복구되지 않습니다.", (){}, ()async {
            try{
              await usersService.withdraw();
            }catch(error){

            }

            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.clear();

            Navigator.of(context).pushNamedAndRemoveUntil( LandingPage.routeName, (route)=> false);
          });

        }, "회원탈퇴"),
      ],
    );
  }
  Widget _menuTitle(GestureTapCallback onTap, String label){
    return GestureDetector(
      onTap: onTap,
      child: Padding(padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          label,
          style: TextStyle(
            color: Color(0xFF191919),
            fontSize: 16,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _menuItem(MenuItemModel model) =>
      GestureDetector(
        onTap: model.onTap,
        child: Padding(padding: EdgeInsets.symmetric(vertical: 8),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [SizedBox(width: 20,),
                Text(
                  model.label,
                  style: TextStyle(
                    color: Color(0xFF545454),
                    fontSize: 16,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),],
            ),
            GestureDetector(
              child: Icon(Icons.chevron_right, color: Color(0xFF6D7D7D),),
            )
          ],
        ),)
      );
}

class MenuItemModel {
  String label;
  void Function()? onTap;

  MenuItemModel({
    required this.label,
    required this.onTap,
  });
}
