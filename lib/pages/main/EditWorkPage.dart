import 'package:cupertino_calendar_picker/cupertino_calendar_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ilkkam/pages/main/widgets/WorkEditDialog.dart';
import 'package:ilkkam/pages/main/widgets/WorkUploadDialog.dart';
import 'package:ilkkam/providers/works/WorkController.dart';
import 'package:ilkkam/providers/works/WorkRepository.dart';
import 'package:ilkkam/providers/works/Works.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';
import 'package:ilkkam/widgets/IKDatePicker.dart';
import 'package:ilkkam/widgets/IKTextField.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/formatters.dart';

class EditWorkPage extends StatefulWidget {
  const EditWorkPage({super.key});

  static const routeName = "/edit-work-page";

  @override
  State<EditWorkPage> createState() => _EditWorkPageState();
}

class _EditWorkPageState extends State<EditWorkPage> {
  // 일깜 등록 관련
  final TextEditingController _priceC = TextEditingController();
  WorkRepository workRepository = WorkRepository();
  DateTime dateTime = DateTime.now();
  DateTime time =
      DateTime.now().subtract(Duration(minutes: DateTime.now().minute % 10));
  bool noMatterTime = false;

  @override
  void initState() {
    super.initState();
    // `WidgetsBinding.instance.addPostFrameCallback`을 사용하여 arguments를 안전하게 가져옴
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      if (args != null) {
        print(args['work']);
        Work work = args['work'];
        DateTime now = DateTime.now();
        dateTime = DateTime.parse(work.workDate ?? "2024-11-04");
        _priceC.text = work.price.toString();
        if (work.workHour == null) {
          setState(() {
            noMatterTime = true;
          });
        } else {
          List<String>? workSplited = work.workHour?.split(" ");
          if (workSplited != null && workSplited.length > 1) {
            bool isAM = workSplited[0] == '오전';
            List<String> workhour = workSplited[1].split(':');
            time = DateTime(
                now.year,
                now.month,
                now.day,
                isAM ? int.parse(workhour[0]) : 12 + int.parse(workhour[0]),
                int.parse(workhour[1]),
                now.second).subtract(Duration(minutes: int.parse(workhour[1]) % 10));
          } else if (workSplited != null) {
            List<String> workhour = workSplited[0].split(':');
            time = DateTime(now.year, now.month, now.day, int.parse(workhour[0]),
                int.parse(workhour[1]), now.second).subtract(Duration(minutes: int.parse(workhour[1]) % 10));
          }
        }
            }
      setState(() {

      });
    });
  }
  @override
  void didChangeDependencies() {


    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  changeNoMatterTime(bool? val) {
    setState(() {
      if (val == null) {
        return;
      }
      noMatterTime = val;
    });
  }

  Future<DateTime?> onCalendarWidgetTap(BuildContext context) async {
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    final nowDate = DateTime.now();

    return showCupertinoCalendarPicker(
      context,
      widgetRenderBox: renderBox,
      minimumDateTime: nowDate.subtract(const Duration(days: 15)),
      initialDateTime: nowDate,
      maximumDateTime: nowDate.add(const Duration(days: 360)),
      mode: CupertinoCalendarMode.dateTime,
      timeLabel: 'Ends',
      onDateTimeChanged: (dateTime) async {
        final DateTime? current = await showDatePicker(
            context: context,
            initialDate: dateTime,
            firstDate: DateTime(2000),
            lastDate: DateTime(3000));
        if (current != null) {
          setState(() {
            dateTime = current;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final work = Provider.of<WorkController>(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "일깜 수정은 날짜, 시간, 금액만 가능합니다.\n다른 사항을 수정하실 경우 삭제 후 재등록 부탁드립니다.",
              style: TextStyle(
                color: Color(0xFF7D7D7D),
                fontSize: 14,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            IkDatePicker(
              format: 'yyyy년 MM월 dd일',
              label: "날짜",
              onTap: () async {
                _showDialog(CupertinoDatePicker(
                  initialDateTime: time,
                  mode: CupertinoDatePickerMode.date,
                  use24hFormat: false,
                  minimumDate: dateTime.subtract(Duration(days: 90)),
                  maximumDate: dateTime.add(Duration(days: 90)),
                  // This is called when the user changes the time.
                  onDateTimeChanged: (DateTime newTime) async {
                    setState(() {
                      dateTime = newTime;
                    });
                  },
                ));
                // onCalendarWidgetTap(context);
              },
              dateTime: dateTime,
            ),
            SizedBox(
              height: 20,
            ),
            IkDatePicker(
              label: "시간",
              noMatter: noMatterTime,
              noMatterChange: changeNoMatterTime,
              format: 'a hh:mm',
              timeOfDay: time,
              onTap: () async {
                if (noMatterTime) {
                  return;
                }
                _showDialog(CupertinoDatePicker(
                  initialDateTime: time,
                  minuteInterval: 10,
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false,
                  // This is called when the user changes the time.
                  onDateTimeChanged: (DateTime newTime) {
                    setState(() => time = newTime);
                  },
                ));
              },
              // timeOfDay: time,
            ),
            if(work.selectedWork?.workTypes?.name != "견적방문 요청")
            SizedBox(
              height: 20,
            ),
            if(work.selectedWork?.workTypes?.name != "견적방문 요청")
            IkTextField(
              controller: _priceC,
              placeholder: "",
              formatters: [ThousandsFormatter()],
              label: "금액(선택)",
              keyboardType: TextInputType.number,
              action: Text(
                "원",
                style: TextStyle(
                  color: Color(0xFF545454),
                  fontSize: 15,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            IKCommonBtn(
                title: "수정하기",
                onTap: () async {
                  await workRepository.updateWork(
                      workDate: DateFormat("yyyy-MM-dd").format(dateTime),
                      workHour: noMatterTime
                          ? null
                          : DateFormat("a hh:mm", "ko").format(time),
                      price: _priceC.text,
                      workId: work.selectedWork?.id ?? -1);
                  await work.reload();
                  Provider.of<WorkController>(context, listen: false)
                      .fetchWorkDetailInfoAndGetCanApply(work.selectedWork?.id ?? -1);
                  showWorkEditFinishedDialog(context);
                })
          ],
        ),
      ),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}
