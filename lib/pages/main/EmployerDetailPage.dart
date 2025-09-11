import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/apis/usersAPI.dart';
import 'package:ilkkam/pages/chat/ChatScreenPage.dart';
import 'package:ilkkam/pages/main/widgets/WorkReviews.dart';
import 'package:ilkkam/providers/chats/ChatsController.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/WorkRepository.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';
import 'package:ilkkam/widgets/IKCompactTextBtn.dart';
import 'package:ilkkam/widgets/IKDivider.dart';
import 'package:ilkkam/widgets/IKImageList.dart';
import 'package:ilkkam/widgets/IKTextRow.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class EmployerDetailPage extends StatefulWidget {
  const EmployerDetailPage({super.key});

  static const routeName = "/employer-work-page";

  @override
  State<EmployerDetailPage> createState() => _EmployerDetailPageState();
}

class _EmployerDetailPageState extends State<EmployerDetailPage> {

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userC = Provider.of<UserController>(context);
    Users? employer = userC.employer;
    if (employer == null) {
      return Container();
    } else {
      Users empl = employer!;
      final user = Provider.of<UserController>(context);


      return Stack(
        children: [


          SingleChildScrollView(
              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20,),
                      Text('일깜', style: IKTextStyle.appMainText),
                      const SizedBox(width: 5),
                      Text(
                        '등록자 정보',
                        style: TextStyle(
                          color: Color(0xFF121212),
                          fontSize: 19,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),

                  summary(empl),
                  IKDiver(),
                  employerDetail(empl),
                  IKDiver(),
                  ReviewList(reviews: empl.reviews ?? []),
                  // ReviewList(reviews:[]),
                  SizedBox(height: 110,)
                ],
              )
          ),
          if(empl.id != user.id)
            Positioned(
                bottom: 0,
                child: Container(
                  // height: 110,
                    width: MediaQuery
                        .of(context)
                        .size
                        .width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x26000000),
                          blurRadius: 6,
                          offset: Offset(0, -1),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(20),
                    child: IKCommonBtn(title: "1:1 대화", onTap: () async {
                      print("대화 신청 눌림 ");
                      Work? work = Provider
                          .of<WorkController>(context, listen: false)
                          .selectedWork;
                      await Provider.of<ChatsController>(context, listen: false)
                          .prepareOpenChatByApplier(work?.id ?? -1);
                      Navigator.of(context, rootNavigator: true).pushNamed(
                          ChatScreen.routeName);
                    })
                ))

        ],
      );
    }
  }

  Widget summary(Users user) {
    double rating = user.rating ?? 0.0;
    int fullStars = rating.floor();
    bool hasHalfStar = (rating - fullStars) >= 0.5;

    return Container(

        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                user.name ?? '',
                style: TextStyle(
                  color: Color(0xFF191919),
                  fontSize: 21,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.21,
                ),
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

                      // 빈 별
                      // for (int i = 0; i < emptyStars; i++)
                      //   SvgPicture.asset("assets/main/star.svg",),
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
              IKCompactTextBtn(label: "전화하기", onPressed: () {
                launchUrl(Uri(
                  scheme: 'tel', path: user?.phoneNumber ?? '',)); // 전화 걸기
              }),
            ],
          ),
        ));
  }

  Widget employerDetail(Users user) =>
      Container(
        child: Container(
          // color: const Color(0xFFF4F4F4),
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
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
                  label: "", images: [user.businessCertification ?? '']),
            ],
          ),
        ),
      );


}
