import 'package:flutter/material.dart';
import 'package:ilkkam/pages/main/WorkListPage.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DayCountModel {
  int count;
  DateTime time;
  Function onTap;

  DayCountModel({required this.count, required this.time, required this.onTap});
}

class DayCountWidget extends StatelessWidget {
  List<DayCountModel> items = [];
  DateTime selectedTime;
  final bool isLandingPage;
  ScrollController? scrollController;

  DayCountWidget(
      {super.key,
      required this.items,
      required this.selectedTime,
      required this.isLandingPage,
      this.scrollController});

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return ListView.builder(
      controller: scrollController,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext ctx, int index) {
        if (index == items.length) {
          return MaterialButton(
            minWidth: 48,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            onPressed: () {
              Provider.of<WorkController>(context, listen: false)
                  .changeMonth(DateTime.now(), fromDayCount: true);
              Navigator.of(context).pushNamed(WorkListPage.routeName);
            },
            child: Text("더보기"),
          );
        }
        DayCountModel day = items[index];
        bool isToday = day.time.day == selectedTime.day &&
            day.time.month == selectedTime.month;
        bool isSelected =
            day.time.day == now.day && day.time.month == now.month;

        return GestureDetector(
          onTap: () {
            day.onTap();
          },
          child: Container(
            decoration: ShapeDecoration(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5))),
            width: 48,
            alignment: Alignment.center,
            // padding: EdgeInsets.symmetric(vertical: 10),
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat("E", 'ko_KR').format(day.time),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isToday || isSelected
                        ? Color(0xFF01A9DB)
                        : Color(0xFF7D7D7D),
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(3),
                  decoration: ShapeDecoration(
                    shape: CircleBorder(),
                    color: isToday
                        ? Color(0xFF01A9DB)
                        : isSelected
                        ? Color(0xFFE7F8FF)
                        : Colors.transparent,
                  ),
                  child: Text(
                    DateFormat('dd').format(day.time),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isToday
                          ? Colors.white
                          : Color(0xFF545454),
                      fontSize: 19,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  '${day.count}건',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isToday || isSelected
                        ? Color(0xFF01A9DB)
                        : Color(0xFF898A8D),
                    fontSize: 13,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      itemCount: isLandingPage ? items.length + 1 : items.length,
    );
  }
}
