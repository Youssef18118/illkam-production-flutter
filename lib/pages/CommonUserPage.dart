import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ilkkam/apis/usersAPI.dart';

import '../providers/works/Works.dart';
import '../widgets/IKBlankDivider.dart';
import '../widgets/IKImageList.dart';
import '../widgets/IKTextRow.dart';
import 'main/widgets/WorkReviews.dart';

class CommonUserPage extends StatefulWidget {
  static const routeName = "/common-user-page";
  const CommonUserPage({super.key});

  @override
  State<CommonUserPage> createState() => _CommonUserPageState();
}

class _CommonUserPageState extends State<CommonUserPage> {
  Users? user;
  UsersService usersService = UsersService();

  @override
  void didChangeDependencies() {
    int args = ModalRoute.of(context)?.settings.arguments as int;
    fetchUserInfo(args);
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }


  fetchUserInfo(int userid) async {
    user =  await usersService.getUserInfo(userid);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    user?.reviews?.forEach((item)=> {
      print(item.createdDateTime)
    });

    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
      ),
      body: user == null? Center(child: CircularProgressIndicator(color: Colors.brown,)) : SingleChildScrollView(child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _title(user!, user?.id ?? -1),
          IKBlankDivider(),
          _body(user!),
          IKBlankDivider(),
          ReviewList(reviews: user?.reviews ?? [])
          // _reviews(applier!)
        ],
      )),
    );
  }

  Widget _title(Users user, int myUserId)  {
    double rating = user.rating ?? 0.0;
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        children: [
          Column(
            children: [
              Text(
                  user.name ?? '',
                  style: TextStyle(
                    color: Color(0xFF191919),
                    fontSize: 21,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.21,
                  )
              ),

              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
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
                    user.rating != 0.0 && user.rating != null
                        ? (user.rating?.toStringAsFixed(1) ?? '') : "평점 없음",
                    style: TextStyle(
                      color: Color(0xFF191919),
                      fontSize: 17,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${user.reviews?.length.toString() ?? '0'}개의 리뷰",
                    style: TextStyle(
                      color: Color(0xFF7D7D7D),
                      fontSize: 14,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),

            ],
          ),
        ],
      ),
    );
  }

  Widget _body(Users user) => Container(
    padding: EdgeInsets.all(20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '상세내역',
          style: TextStyle(
            color: Color(0xFF191919),
            fontSize: 17,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: 20,),
        IKTextRow(title: "상호/이름", detail: user.name),
        Divider(color: Color(0xFFEAEAEA), height: 16,),
        IKTextRow(title: "사업자 번호", detail: user.businessNumber),
        Divider(color: Color(0xFFEAEAEA), height: 16,),
        IKTextRow(title: "전화번호", detail: user.phoneNumber),
        Divider(color: Color(0xFFEAEAEA), height: 16,),
        IKTextRow(title: "사업장 주소", detail: user.businessAddress),
        Divider(color: Color(0xFFEAEAEA), height: 16,),
      IKTextRow(title: "기타", detail: "사업자 등록증 또는 명함"),
        IKImageList(
            label: "",
            images: [user.businessCertification ?? '']),
      ],
    ),
  );

}