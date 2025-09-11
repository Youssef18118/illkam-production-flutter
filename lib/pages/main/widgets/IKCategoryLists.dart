import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:provider/provider.dart';

class IkCategoryLists extends StatelessWidget {
  const IkCategoryLists({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkController workController = Provider.of<WorkController>(context);
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 5,
      // 한 줄에 5개
      mainAxisSpacing: 16.0,
      crossAxisSpacing: 8.0,
      childAspectRatio: 62 / 70,
      physics: const NeverScrollableScrollPhysics(),
      // 내부 스크롤 방지
      children: workController.workTypes
          .where((id) => id.id != null && id.id != 0)
          .map((item) {
        // TODO : 카테고리별 스크롤 페이지로 이동
        return GestureDetector(
          onTap: () {
            // if (result != 0) {
            workController.changeWorkMainType(
                workController.workTypes
                    .firstWhere((elem) => elem.id == item.id),
                isLandingPage: true);
            // } else {
            //   workController.changeWorkMainType(null,
            //       isLandingPage:false);
            // }
          },
          child:Stack(
            alignment: Alignment.center,
            children: [
              if(workController.selectedWorkType?.id == item.id)
              Container(
                decoration: ShapeDecoration(
                    color: Color(0xFFE8F8FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)

                )),

              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "assets/category/${item.name?.replaceAll("/", "")}.svg",
                    width: 40,
                    height: 40,
                  ),
                  // const SizedBox(height: 8),
                  Text(
                    item.name?.replaceAll(" ", "") ?? '',
                    textAlign: TextAlign.center,
                    style: workController.selectedWorkType?.id == item.id
                        ? IKTextStyle.categoryTitle.apply(
                        fontWeightDelta:
                        workController.selectedWorkType?.id == item.id
                            ? 700
                            : 400)
                        : IKTextStyle.categoryTitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
