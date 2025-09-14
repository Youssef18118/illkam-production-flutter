import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/models/workTypes/WorkTypeTotalResDto.dart';
import 'package:ilkkam/pages/main/WorkDetailpage.dart';

import 'package:ilkkam/pages/register/LandingPage.dart';
import 'package:ilkkam/providers/TabController.dart';
import 'package:ilkkam/providers/applies/AppliesRepository.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class WorkItem extends StatelessWidget {
  final Work work;

  const WorkItem({super.key, required this.work});

  @override
  Widget build(BuildContext context) {
    final workProvider = Provider.of<WorkController>(context);
    final userC = Provider.of<UserController>(context, listen: false);

    String? image;
    switch (work.workTypes?.name) {
      case "일반청소":
        image = "general";
      case "A/S":
        image = "as";
        break;
      case "에어컨":
        image = "aircon";
        break;
      case "가전 청소":
        image = "elec";
        break;
      case "유리창 청소":
        image = "window";
        break;
      case "패블릭 청소":
        image = "fabric";
        break;
      case "인테리어 시공":
      case "인테리어 청소":
        image = "interior";
        break;
      default:
        image = "general";
        break;
    }
    //  평수 있는 지 조회
    List<WorkInfoDetail>? workSize =
        work.workInfoDetail?.where((elem) => elem.name == "평수").toList();

    return GestureDetector(
      onTap: () {
        if (!userC.isLogIn) {
          Navigator.of(context, rootNavigator: true)
              .pushNamed(LandingPage.routeName);
          return;
        }
        Provider.of<WorkController>(context, listen: false)
            .routeToWorkDetailpage(context, work.id ?? -1);
      },
      child: Container(
        color: Colors.transparent,
        height: 117,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 40,
                height: 40,
                // padding: const EdgeInsets.all(8),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          "assets/category/${work.workTypes?.name?.replaceAll("/", "")}.svg",
                          fit: BoxFit.fill,
                          width: 40,
                          height: 40,
                        ),
                        if (work.appliesList != null &&
                            work.appliesList!
                            .where((elem) =>
                                elem.status == APPLY_STATUS.confirm.value)
                            .isNotEmpty)
                          Container(
                            color: Colors.black.withOpacity(0.5),
                            width: 48,
                            height: 48,
                            alignment: Alignment.center,
                            child: Text(
                              "모집\n종료",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                  height: 1.2),
                            ),
                          )
                      ],
                    ))),
            SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${DateFormat("MM.dd (E)", "ko").format(DateTime.parse(work.workDate ?? '2024-10-05'))} ${work.workHour ?? "시간무관"}',
                            style: TextStyle(
                              color: Color(0xFF494949),
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          categoryBadge(work.workTypes?.name ?? '',
                              work.workTypeDetails?.name ?? '')
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${work.workLocationSi ?? ''} ${work.workLocationGu ?? ''}",
                            // '인천시 서구 가정동',,
                            style: const TextStyle(
                              color: Color(0xFF747474),
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (work.workTypes?.name=="일반청소" && workSize != null && workSize.isNotEmpty)
                            Text(
                              '${workSize?[0].value ?? ''}평형',
                              style: TextStyle(
                                color: Color(0xFF545454),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                          if (work.workTypes?.name=="에어컨")
                            Text(
                              '${work.workInfoDetail?[2].value ?? ''}대',
                              style: TextStyle(
                                color: Color(0xFF545454),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          if (work.workTypes?.name=="가전 청소")
                            Text(
                              '${work.workInfoDetail?[1].value ?? ''}대',
                              style: TextStyle(
                                color: Color(0xFF545454),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Text(
                            '등록자',
                            style: TextStyle(
                              color: Color(0xFF545454),
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              letterSpacing: -0.12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${work.employer?.name}',
                            style: TextStyle(
                              color: Color(0xFF191919),
                              fontSize: 15,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if(work.workTypes?.name == "견적방문 요청")
                            SizedBox(width: 12,),
                          if(work.workTypes?.name != "견적방문 요청")
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                      NumberFormat("#,###").format(work.price ?? 0),
                                  style: TextStyle(
                                    color: Color(0xFF191919),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(
                                  text: '원',
                                  style: TextStyle(
                                    color: Color(0xFF191919),
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          peopleCount(work.appliesList?.where((elem)=>elem.status != APPLY_STATUS.cancel.value).length ?? 0)
                        ],
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget categoryBadge(String title, String subtitle) => Container(
        padding: const EdgeInsets.all(4),

        decoration: ShapeDecoration(
          color: Color(0xFFE8F8FF),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
        ),
        child: Row(
          children: [
            Text(
              title.replaceFirst("시공",""),
              style: TextStyle(
                color: Color(0xFF545454),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.12,
              ),
            ),
            if(subtitle != '')
            const SizedBox(width: 4),
            if(subtitle != '')
            SvgPicture.asset("assets/main/arrow.svg",color: Color(0xFF545454),),
            if(subtitle != '')
            const SizedBox(width: 4),
            Text(
              subtitle.length > 4 ? "${subtitle.substring(0,4)}...":
              subtitle,
              style: TextStyle(
                color: Color(0xFF545454),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.12,
                overflow: TextOverflow.ellipsis
              ),
            ),
          ],
        ),
      );

  Widget peopleCount(int count) => Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 16,
              height: 16,
              clipBehavior: Clip.antiAlias,
              decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: SvgPicture.asset("assets/main/user_ico.svg"),
            ),
            const SizedBox(width: 4),
            Text(
              '$count명',
              style: TextStyle(
                color: Color(0xFF545454),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.12,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/',
              style: TextStyle(
                color: Color(0xFF7D7D7D),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.12,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '10명',
              style: TextStyle(
                color: Color(0xFF7D7D7D),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.12,
              ),
            ),
          ],
        ),
      );
}
