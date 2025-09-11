import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/pages/main/ApplierDetailPage.dart';
import 'package:ilkkam/providers/applies/AppliesController.dart';
import 'package:ilkkam/providers/applies/dto/Apply.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/widgets/IKCompactTextBtn.dart';
import 'package:provider/provider.dart';

class IKUserItem extends StatelessWidget {
  final Users user;
  final Apply apply;
  final bool? showReviewBtn;
  final bool? isReviewPosted;
  final void Function()? writeReview;

  const IKUserItem(
      {super.key,
      required this.user,
      required this.apply,
      this.showReviewBtn,
      this.isReviewPosted,
      this.writeReview});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Provider.of<AppliesController>(context, listen: false)
            .selectApply(apply);
        Provider.of<UserController>(context, listen: false)
            .fetchApplier(user.id ?? -1);
        Navigator.of(context, rootNavigator: true)
            .pushNamed(ApplierDetailPage.routeName);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: user.businessCertification != null
                      ? Image.network(
                          user.businessCertification!,
                          fit: BoxFit.fill,
                          width: 60,
                          height: 60,
                        )
                      : SvgPicture.asset("assets/main/user_ico.svg",
                          fit: BoxFit.fill, width: 60, height: 60),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    user.name ?? '',
                    style: TextStyle(
                      color: Color(0xFF63696C),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SvgPicture.asset("assets/main/star.svg"),
                          const SizedBox(width: 4),
                          Text(
                            user.rating == null ? '평점 없음' : "${user.rating?.toStringAsFixed(1)}",
                            style: TextStyle(
                              color: Color(0xFF191919),
                              fontSize: 12,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          SvgPicture.asset("assets/main/comment.svg"),
                          const SizedBox(width: 4),
                          Text(
                              user.reviewCount == null
                                  ? '0'
                                  : "${user.reviewCount}",
                              style: TextStyle(
                                color: Color(0xFF191919),
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                              ),),
                        ],
                      ),
                      // const SizedBox(width: 8),
                      // Container(
                      //   width: 3,
                      //   height: 3,
                      //   decoration: ShapeDecoration(
                      //     color: Color(0xFFC7C7C7),
                      //     shape: OvalBorder(),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          if (showReviewBtn == true)
            IKCompactTextBtn(
                label:
                    "리뷰 ${isReviewPosted != null && isReviewPosted! ? "수정하기" : "남기기"}",
                onPressed: writeReview)
        ],
      ),
    );
  }
}
