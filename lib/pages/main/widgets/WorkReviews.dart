import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/utils/imagePicker.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';
import 'package:ilkkam/widgets/IKTextField.dart';
import 'package:ilkkam/widgets/ImagePickerWidget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReviewList extends StatefulWidget {
  final List<WorkReviews> reviews;

  const ReviewList({super.key, required this.reviews});

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  double value = 3.0;
  TextEditingController _contentsC = TextEditingController();
  List<String> images = [];
  bool isImageUploading = false;

  clearInputs() {
    setState(() {
      value = 3.0;
      _contentsC.clear();
      _contentsC.text = "";
      images = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserController>(context);
    final work = Provider.of<WorkController>(context);
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '리뷰 정보 ',
                style: TextStyle(
                  color: Color(0xFF191919),
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${widget.reviews.length}",
                textAlign: TextAlign.right,
                style: TextStyle(
                  color: Color(0xFF0098C5),
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                bool isMyReview = user.id == widget.reviews[index].writer?.id;
                WorkReviews review = widget.reviews[index];
                return Container(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(99),
                        child: Image.network(
                          review.writer?.businessCertification ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  review.writer?.name ?? '',
                                  style: TextStyle(
                                    color: Color(0xFF191919),
                                    fontSize: 15,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (isMyReview)
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) =>
                                                  StatefulBuilder(builder:
                                                      (BuildContext context,
                                                          StateSetter
                                                              setDialog) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Colors.white,
                                                      title: Text("리뷰 수정하기"),
                                                      content: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          RatingStars(
                                                            value: value,
                                                            onValueChanged:
                                                                (v) {
                                                              //
                                                              setDialog(() {
                                                                value = v
                                                                    .floorToDouble();
                                                              });
                                                            },
                                                            starBuilder: (index,
                                                                    color) =>
                                                                Icon(
                                                              Icons.star,
                                                              color: color,
                                                            ),
                                                            starCount: 5,
                                                            starSize: 20,
                                                            valueLabelColor:
                                                                const Color(
                                                                    0xff9b9b9b),
                                                            valueLabelTextStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400,
                                                                    fontStyle:
                                                                        FontStyle
                                                                            .normal,
                                                                    fontSize:
                                                                        12.0),
                                                            valueLabelRadius:
                                                                10,
                                                            maxValue: 5,
                                                            starSpacing: 2,
                                                            maxValueVisibility:
                                                                true,
                                                            valueLabelVisibility:
                                                                true,
                                                            // animationDuration:
                                                            //     Duration(milliseconds: 1000),
                                                            valueLabelPadding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    vertical: 1,
                                                                    horizontal:
                                                                        8),
                                                            valueLabelMargin:
                                                                const EdgeInsets
                                                                    .only(
                                                                    right: 8),
                                                            starOffColor:
                                                                const Color(
                                                                    0xffe7e8ea),
                                                            starColor:
                                                                Colors.yellow,
                                                          ),
                                                          SizedBox(
                                                            height: 12,
                                                          ),
                                                          IkTextField(
                                                            placeholder:
                                                                "내용 입력",
                                                            label: "내용 입력 (필수)",
                                                            maxline: 5,
                                                            controller:
                                                                _contentsC,
                                                          ),
                                                          SizedBox(
                                                            height: 20,
                                                          ),
                                                        ],
                                                      ),
                                                      actions: [
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                                child:
                                                                    IKCommonBtn(
                                                              title: "취소",
                                                              onTap: () {
                                                                clearInputs();
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              type: BTN_TYPE
                                                                  .secondary,
                                                            )),
                                                            SizedBox(
                                                              width: 12,
                                                            ),
                                                            Expanded(
                                                                child:
                                                                    IKCommonBtn(
                                                                        title:
                                                                            "수정",
                                                                        onTap:
                                                                            () async {
                                                                          // 내가 고용자일 경우에만 리뷰 남김
                                                                          await work
                                                                              .editReview(
                                                                            _contentsC
                                                                                .text,
                                                                            value
                                                                                .toInt(),
                                                                             null,
                                                                            review.id,
                                                                          );
                                                                          clearInputs();

                                                                          Provider.of<UserController>(context, listen: false)
                                                                              .fetchEmployer(work.selectedWork?.employer?.id ?? -1);

                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        }))
                                                          ],
                                                        )
                                                      ],
                                                    );
                                                  }));
                                        },
                                        child: Text(
                                          "수정",
                                          style: TextStyle(
                                            color: AppColors.accentBackground,
                                            fontSize: 13,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder:
                                                  (BuildContext context) =>
                                                      StatefulBuilder(builder:
                                                          (BuildContext context,
                                                              StateSetter
                                                                  setDialog) {
                                                        return AlertDialog(
                                                          title: Text("리뷰 삭제"),
                                                          content: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                  "리뷰를 삭제하시겠습니까?")
                                                            ],
                                                          ),
                                                          actions: [
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                    child:
                                                                        IKCommonBtn(
                                                                  title: "취소",
                                                                  onTap: () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                  type: BTN_TYPE
                                                                      .secondary,
                                                                )),
                                                                SizedBox(
                                                                  width: 12,
                                                                ),
                                                                Expanded(
                                                                    child: IKCommonBtn(
                                                                        title: "삭제",
                                                                        onTap: () async {
                                                                          await work.removeReview(review.id ??
                                                                              -1);
                                                                          Provider.of<UserController>(context, listen: false)
                                                                              .fetchEmployer(work.selectedWork?.employer?.id ?? -1);
                                                                          // Provider.of<UserController>(context, listen: false).fetchApplier(review.employee?.id ??
                                                                          //     -1);

                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        }))
                                                              ],
                                                            )
                                                          ],
                                                        );
                                                      }));
                                        },
                                        child: Text(
                                          // "삭제",
                                          "",
                                          style: TextStyle(
                                            color: AppColors.accentBackground,
                                            fontSize: 13,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/main/star.svg",
                                        width: 20,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        review.starCount == null
                                            ? "평점 없음"
                                            : "${review.starCount?.toStringAsFixed(1)}",
                                        style: TextStyle(
                                          color: Color(0xFF545454),
                                          fontSize: 14,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                    DateFormat("yyyy.MM.dd").format(DateTime.parse(review.createdDateTime ?? "2025-01-01")) ?? '',
                                  style: TextStyle(
                                    color: Color(0xFFA6AEB1),
                                    fontSize: 13,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                )

                              ],

                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              child: Text(
                                '${review.contents == null || review.contents == "" ? "코멘트 없음" : review.contents}',
                                style: TextStyle(
                                  color: Color(0xFF494949),
                                  fontSize: 15,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
                // reviewUser(reviews[index], isMyReview);
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                height: 40,
                    color: Color(0xFFE0E0E0),
                  ),
              itemCount: widget.reviews.length)
        ],
      ),
    );
  }
// Widget reviewUser(WorkReviews review, bool isMyReview, BuildContext context) {
//   return ;
// }
}
