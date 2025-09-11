import 'dart:developer';
import 'dart:math';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/utils/ProvinceFormatter.dart';
import 'package:ilkkam/utils/mapLocationInfo.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/IKDropDownButton.dart';
import 'package:provider/provider.dart';

class WorkFilters extends StatefulWidget {
  final bool isLandingPage;

  const WorkFilters({super.key, this.isLandingPage = true});

  @override
  State<WorkFilters> createState() => _WorkFiltersState();
}

class _WorkFiltersState extends State<WorkFilters> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final work = Provider.of<WorkController>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              print(isExpanded);
              isExpanded = !isExpanded;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF4F4F4),
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF848A8D),
                    ),
                    SizedBox(width: 8,),
                    Text(
                      work.selectedProvince ?? '지역 검색',
                      style: locationT,
                    ),
                  ],
                ),
                Transform.rotate(
                  angle: pi / 2,
                  child: SvgPicture.asset("assets/main/arrow_black.svg"),
                )
              ],
            ),
          ),
        ),
        // 지역 리스트 (애니메이션 효과)
        AnimatedContainer(
          duration: const Duration(milliseconds: 200), // 애니메이션 시간 살짝 늘리기
          curve: Curves.easeInOut, // 부드럽게 시작하고 끝나는 곡선
          height: isExpanded ? (((MediaQuery.of(context).size.width - 40 - 24)/5*2 /4 + 8) * 6) : 0,
          child: GridView.builder(
            padding: const EdgeInsets.only(top: 10),
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.5,
            ),
            itemCount: placeSiMap.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  String? province = "";
                  if (index == 0) {
                    province = null;
                  } else {
                    province = placeSiMap.keys.toList()[index];
                  }
                  work.changeProvince(province,
                      isLandingPage: widget.isLandingPage);
                  setState(() {
                    isExpanded = false;
                  });
                },
                child: Container(
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: 1,
                        color: work.selectedProvince ==
                                placeSiMap.keys.toList()[index]
                            ? Color(0xFF081D23)
                            : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                      index == 0 ? "전체":
                      formatProvince(placeSiMap.keys.toList()[index]),
                    style: TextStyle(
                      color: work.selectedProvince ==
                              placeSiMap.keys.toList()[index]
                          ? Colors.black
                          : Color(0xFF545454),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(
          height: 12,

        ),
        if(widget.isLandingPage == false)
        Row(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IKDropdownBtn(
              label: work.selectedWorkType?.name ?? '1차 카테고리',
              onPressed: () {
                BottomPicker(
                        dismissable: true,
                        onSubmit: (dynamic result) {
                          if (result != 0) {
                            work.changeWorkMainType(
                                work.workTypes[result as int],
                                isLandingPage: widget.isLandingPage);
                          } else {
                            work.changeWorkMainType(null,
                                isLandingPage: widget.isLandingPage);
                          }
                        },
                        items: work.workTypes.map((elem) {
                          if (elem.id == 0) {
                            return Container(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  "전체 카테고리",
                                  style: IKTextStyle.selectorText,
                                ));
                          }
                          return Container(
                            child: Text(elem.name ?? '',
                                style: IKTextStyle.selectorText),
                            padding: EdgeInsets.only(top: 4),
                          );
                        }).toList(),
                        buttonWidth: MediaQuery.of(context).size.width - 40,
                        buttonPadding: 12,
                        buttonSingleColor: AppColors.accentBackground,
                        buttonContent: Text(
                          "선택하기",
                          style: IKTextStyle.selectorBtnText,
                          textAlign: TextAlign.center,
                        ),
                        pickerTitle: const Text("1차 카테고리를 선택해주세요.",
                            style: TextStyle(
                                color: Color(0xFF494949),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.14,
                                height: 2)))
                    .show(context);
              },
            ),
            const SizedBox(
              width: 8,
            ),
            IKDropdownBtn(
              label: work.selectedWorkDetailType?.name ?? '2차 카테고리',
              onPressed: () {
                BottomPicker(
                        dismissable: true,
                        onSubmit: (dynamic result) {
                          if (result != 0) {
                            work.changeWorkDetailType(
                                work.workTypeDetails[result as int],
                                isLandingPage: widget.isLandingPage);
                          } else {
                            work.changeWorkDetailType(null,
                                isLandingPage: widget.isLandingPage);
                          }
                        },
                        items: work.workTypeDetails.map((elem) {
                          if (elem.id == 0) {
                            return Container(
                              child: Text(
                                "전체 카테고리",
                                style: IKTextStyle.selectorText,
                              ),
                              padding: EdgeInsets.only(top: 4),
                            );
                          }
                          return Container(
                            padding: EdgeInsets.only(top: 4),
                            child: Text(elem.name ?? '',
                                style: IKTextStyle.selectorText),
                          );
                        }).toList(),
                        buttonWidth: MediaQuery.of(context).size.width - 40,
                        buttonPadding: 12,
                        buttonSingleColor: AppColors.accentBackground,
                        buttonContent: Text(
                          "선택하기",
                          style: IKTextStyle.selectorBtnText,
                          textAlign: TextAlign.center,
                        ),
                        pickerTitle: const Text("2차 카테고리를 선택해주세요.",
                            style: TextStyle(
                                color: Color(0xFF494949),
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                letterSpacing: -0.14,
                                height: 2)))
                    .show(context);
              },
            ),
          ],
        )
      ],
    );
  }

  final TextStyle locationT = TextStyle(
    color: Color(0xFF41474A),
    fontSize: 15,
    fontFamily: 'Pretendard',
    fontWeight: FontWeight.w700,
    height: 1.47,
  );
}
