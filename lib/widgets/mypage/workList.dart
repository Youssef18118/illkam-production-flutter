import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:ilkkam/providers/applies/dto/Apply.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';
import 'package:ilkkam/widgets/IKTextField.dart';
import 'package:ilkkam/widgets/WorkItem.dart';
import 'package:provider/provider.dart';

class MyPageWorkList extends StatefulWidget {
  final List<Work> works;

  const MyPageWorkList({super.key, required this.works});

  @override
  State<MyPageWorkList> createState() => _MyPageWorkListState();
}

class _MyPageWorkListState extends State<MyPageWorkList> {
  double value = 3;
  final TextEditingController _contentsC = TextEditingController();

  clearInputs() {
    _contentsC.text = "";
    value = 3.0;
  }

  @override
  Widget build(BuildContext context) {
    List<Work> works = widget.works;
    final workC = Provider.of<WorkController>(context);
    final user = Provider.of<UserController>(context);

    return ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (BuildContext ctx, int index) {
          return const Divider(
            color: Color(0xFFE0E0E0),
            height: 40,
          );
        },
        itemCount: works.length,
        itemBuilder: (context, int index) {
          DateTime workDate =
              DateTime.parse(works[index].workDate ?? '2024-11-18');
          bool isApplier = works[index].employer?.id != user.id;
          Apply myApply = works[index].appliesList!.firstWhere(
              (elem) => elem.applier?.id == user.id,
              orElse: () => Apply(id: -1));
          bool isConfirmed = works[index].employee != null;
          bool isMyApplyConfirmed = myApply.status == 1;
          bool isAuthorizedReviewer =
              (isApplier && isMyApplyConfirmed) || (!isApplier && isConfirmed);
          WorkReviews myReview = works[index].workReviews!.firstWhere(
              (elem) => elem.writer!.id == user.id,
              orElse: () => WorkReviews(id: -1));
          bool isReviewed = myReview.id != -1;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WorkItem(
                work: works[index],
              ),
              SizedBox(
                height: 12,
              ),
              if (isAuthorizedReviewer )
                IKCommonBtn(
                    title: "리뷰 ${!isReviewed ? "남기기" : "수정하기"}",
                    onTap: () {
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) => StatefulBuilder(
                                  builder: (BuildContext context,
                                      StateSetter setDialog) {
                                return AlertDialog(
                                  title:
                                      Text("리뷰 ${!isReviewed ? "쓰기" : "수정하기"}"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RatingStars(
                                        value: value,
                                        onValueChanged: (v) {
                                          //
                                          setDialog(() {
                                            value = v.floorToDouble();
                                          });
                                        },
                                        starBuilder: (index, color) => Icon(
                                          Icons.star,
                                          color: color,
                                        ),
                                        starCount: 5,
                                        starSize: 20,
                                        valueLabelColor:
                                            const Color(0xff9b9b9b),
                                        valueLabelTextStyle: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                            fontStyle: FontStyle.normal,
                                            fontSize: 12.0),
                                        valueLabelRadius: 10,
                                        maxValue: 5,
                                        starSpacing: 2,
                                        maxValueVisibility: true,
                                        valueLabelVisibility: true,
                                        // animationDuration:
                                        //     Duration(milliseconds: 1000),
                                        valueLabelPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 1, horizontal: 8),
                                        valueLabelMargin:
                                            const EdgeInsets.only(right: 8),
                                        starOffColor: const Color(0xffe7e8ea),
                                        starColor: Colors.yellow,
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      IkTextField(
                                        placeholder: "내용 입력",
                                        label: "내용 입력 (필수)",
                                        maxline: 5,
                                        controller: _contentsC,
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
                                            child: IKCommonBtn(
                                          title: "취소",
                                          onTap: () {
                                            clearInputs();

                                            Navigator.of(context).pop();
                                          },
                                          type: BTN_TYPE.secondary,
                                        )),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        Expanded(
                                            child: IKCommonBtn(
                                                title: "등록",
                                                onTap: () async {
                                                  if (isApplier) {
                                                    await workC.reviewWork(
                                                        _contentsC.text,
                                                        value.toInt(), null,
                                                        works[index].id,
                                                        works[index].employer
                                                            ?.id);
                                                    workC.fetchMyEmployeeWork();
                                                  }else{
                                                    await workC.reviewWork(
                                                        _contentsC.text,
                                                        value.toInt(), null,
                                                        works[index].id,
                                                        works[index].employee
                                                            ?.id);
                                                    workC.fetchMyEmployerWork();
                                                  }
                                                  clearInputs();
                                                  Navigator.of(context).pop();
                                                }))
                                      ],
                                    )
                                  ],
                                );
                              }));
                    })
            ],
          );
        });
  }
}
