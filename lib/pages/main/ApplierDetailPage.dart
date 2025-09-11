import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/apis/usersAPI.dart';
import 'package:ilkkam/pages/chat/ChatScreenPage.dart';
import 'package:ilkkam/pages/main/widgets/WorkReviews.dart';
import 'package:ilkkam/providers/applies/AppliesController.dart';
import 'package:ilkkam/providers/applies/AppliesRepository.dart';
import 'package:ilkkam/providers/chats/ChatsController.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/IKBlankDivider.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';
import 'package:ilkkam/widgets/IKCompactTextBtn.dart';
import 'package:ilkkam/widgets/IKImageList.dart';
import 'package:ilkkam/widgets/IKTextRow.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplierDetailPage extends StatefulWidget {
  const ApplierDetailPage({super.key});

  static const routeName = "/applier-work-page";

  @override
  State<ApplierDetailPage> createState() => _ApplierDetailPageState();
}

class _ApplierDetailPageState extends State<ApplierDetailPage> {
  UsersService usersService = UsersService();
  AppliesRepository appliesRepository = AppliesRepository();

  // Users? applier;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ap = Provider.of<AppliesController>(context);
    final workC = Provider.of<WorkController>(context);
    final userC = Provider.of<UserController>(context);
    bool canController = workC.selectedWork?.employer?.id == userC.id;
    if (userC.applier == null || ap.selectedApply == null) {
      return Container();
    }
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(width: 20,),
                  Text('일깜', style: IKTextStyle.appMainText),
                  const SizedBox(width: 5),
                  Text(
                    '신청자 정보',
                    style: TextStyle(
                      color: Color(0xFF121212),
                      fontSize: 19,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),

              _title(userC.applier!, userC.id),
              IKBlankDivider(),
              _body(userC.applier!),
              IKBlankDivider(),
              ReviewList(reviews: userC.applier?.reviews ?? [])
              // _reviews(applier!)
            ],
          )),
        ),
        if (canController &&
            (ap.selectedApply?.status == APPLY_STATUS.waiting.value ||
                ap.selectedApply?.status == null) &&
            workC.selectedWork!.appliesList!
                .where((elem) => elem.status == APPLY_STATUS.confirm.value)
                .isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: IKCommonBtn(
                              title: "수락하기",
                              onTap: () async {
                                await appliesRepository.updateStatus(
                                    ap.selectedApply?.id ?? -1,
                                    APPLY_STATUS.confirm);
                                // 디테일 화면 정보 수정
                                await workC.fetchWorkDetailInfoAndGetCanApply();
                                // 일깜 등록한 기록 수정
                                await workC.fetchMyEmployerWork();
                                // 일깜 메인화면 수정
                                workC.reload();
                                // 일깜 리스트화면수정
                                workC.reloadWorkListPage();
                                Navigator.pop(context);
                              })),
                    ],
                  ),
                ),
              ],
            ),
          ),
        // Text("${canController} ${ap.selectedApply?.status}"),
        if (canController &&
            ap.selectedApply?.status == APPLY_STATUS.confirm.value &&
            workC.selectedWork?.isReviewed == null ||
            workC.selectedWork?.isReviewed == false)
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                          child: IKCommonBtn(
                        title: "확정 취소",
                        onTap: () async {
                          await appliesRepository.updateStatus(
                              ap.selectedApply?.id ?? -1, APPLY_STATUS.cancel);
                          await workC.fetchWorkDetailInfoAndGetCanApply();
                          await workC.reload();
                          Navigator.pop(context);
                        },
                        type: BTN_TYPE.secondary,
                      )),
                    ],
                  ),
                ),
              ],
            ),
          )
      ],
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
          if (myUserId != user.id)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IKCompactTextBtn(
                    label: "전화하기",
                    onPressed: () {
                      launchUrl(Uri(
                        scheme: 'tel',
                        path: user.phoneNumber ?? '',
                      )); // 전화 걸기
                    }),
                SizedBox(width: 12,),
                IKCompactTextBtn(
                    label: "1:1 대화",
                    onPressed: () async {
                      print("대화 신청 눌림 ");
                      Work? work =
                          Provider.of<WorkController>(context, listen: false)
                              .selectedWork;
                      await Provider.of<ChatsController>(context,
                          listen: false)
                          .prepareOpenChatByRequester(
                          work?.id ?? -1, user.id ?? -1);
                      Navigator.of(context, rootNavigator: true)
                          .pushNamed(ChatScreen.routeName);
                    }),
                // const SizedBox(height: 8),

              ],
            )
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
