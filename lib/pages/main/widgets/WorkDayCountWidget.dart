import 'package:flutter/material.dart';
import 'package:ilkkam/app.dart';
import 'package:ilkkam/pages/main/WorkListPage.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/dto/WorksSummaryDto.dart';
import 'package:ilkkam/widgets/DayCountWidget.dart';
import 'package:provider/provider.dart';
import 'package:ilkkam/pages/register/LandingPage.dart' as RegisterLandingPage;

class WorkDayCountWidget extends StatelessWidget {
  final bool isLandingPage;

  const WorkDayCountWidget({super.key, this.isLandingPage = true});

  @override
  Widget build(BuildContext context) {
    final work = Provider.of<WorkController>(context);
    final user = Provider.of<UserController>(context, listen: false);
    List<WorksSummaryDto> summaries =
        isLandingPage ? work.workSummary : work.workListWorkSummary;

    return Container(
      height: 75,
      // margin: EdgeInsets.only(top: 16),
      child: DayCountWidget(
          selectedTime: isLandingPage ? DateTime.now() : work.selectedDate,
          isLandingPage: isLandingPage,
          scrollController: work.dayListWidgetScrollController,
          items: summaries.map((WorksSummaryDto dto) {
            DateTime date = DateTime.parse(dto.date ?? "2024-10-05");
            return DayCountModel(
                count: dto.workCount ?? 0,
                time: date,
                onTap: () async {
                  if (isLandingPage) {
                    if (user.isLogIn) {
                      work.changeMonth(
                          DateTime.parse(dto.date ?? '2024-10-22'),
                          fromDayCount: true);
                      Navigator.pushNamed(context, WorkListPage.routeName);
                    } else {
                      Navigator.pushNamed(
                          context, RegisterLandingPage.LandingPage.routeName);
                    }
                  } else {
                    work.selectWorkDate(
                        DateTime.parse(dto.date ?? '2024-10-22'));
                  }
                });
          }).toList()),
    );
  }
}
