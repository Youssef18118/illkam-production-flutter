import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/pages/main/WorkDetailpage.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatSummary extends StatelessWidget {
  final String? workType;
  final int? price;
  final String? workDate;
  final String? address;
  final int? workId;
  const ChatSummary({super.key,
  required this.workType,
    required this.price,
    required this.workDate,
    required this.address,
    required this.workId,
  });

  @override
  Widget build(BuildContext context) {
    final workProvider = Provider.of<WorkController>(context);
    String? image;
    switch (workType) {
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

    return GestureDetector(
      onTap: () {
        workProvider.routeToWorkDetailpage(context, workId ?? -1);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(width: 1, color: Color(0xFFeeeeee)), bottom: BorderSide(width: 1,color: Color(0xFFeeeeee))),
          // color: Color(0xFF01A9DB),
          color: Color(0xFFF2F2F2)
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
                width: 48,
                height: 48,
                // padding: const EdgeInsets.all(8),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Stack(
                      children: [
                        SvgPicture.asset(
                          "assets/category/${workType?.replaceAll("/", "")}.svg",
                          // "assets/common/type-${image}.svg",
                          fit: BoxFit.fill,
                        ),
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
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "${workType}",
                            style: TextStyle(
                              color: Color(0xFF848A8D),
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            width: 3,
                            height: 3,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8),
                            decoration: ShapeDecoration(
                              color: Color(0xFFC7C7C7),
                              shape: OvalBorder(),
                            ),
                          ),
                          Text(
                            "${workDate}" ?? '',
                            style: TextStyle(
                              color: Color(0xFF848A8D),
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            width: 3,
                            height: 3,
                            margin: EdgeInsets.symmetric(
                                horizontal: 8),
                            decoration: ShapeDecoration(
                              color: Color(0xFFC7C7C7),
                              shape: OvalBorder(),
                            ),
                          ),
                          Text(
                            "${address}" ?? '',
                            style: TextStyle(
                              color: Color(0xFF848A8D),
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w500,
                              overflow: TextOverflow.ellipsis
                            ),

                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text:
                                  NumberFormat("#,###원").format(price),
                                  style: TextStyle(
                                    color: Color(0xFF242B2E),
                                    fontSize: 14,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                    height: 1.43,
                                  ),
                                ),
                              ],
                            ),
                          ),
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

}
