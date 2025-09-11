import 'dart:developer';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:flutter/material.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../providers/works/WorkController.dart';
import '../../../widgets/IKDropDownButton.dart';

class WorkFilterMonth extends StatelessWidget {
  const WorkFilterMonth({super.key});

  @override
  Widget build(BuildContext context) {
    final work = Provider.of<WorkController>(context);
    DateTime now = DateTime.now();

    List<DateTime> months = [
      now,
    DateTime(now.year, now.month + 1, 1),
      DateTime(now.year, now.month + 2, 1),
      DateTime(now.year, now.month + 3, 1),
      DateTime(now.year, now.month + 4,1),
      DateTime(now.year, now.month + 5,1),
    ];
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IKDropdownBtn(
          label: DateFormat("yy년 MM월").format(work.selectedMonth ?? DateTime.now()),
          onPressed: () {
            BottomPicker(
                dismissable: true,
                onSubmit: (dynamic result) {
                  log(result.toString());
                  print(months[result]);
                  work.changeMonth(months[result]);
                },
                items: months.map((elem) {
                  return Container(
                      padding: EdgeInsets.only(top: 4),
                      child:Text(DateFormat("yy년 MM월").format(elem), style: IKTextStyle.selectorText)
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
                pickerTitle: const Text("달을 선택해주세요.",
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
    );
  }
}
