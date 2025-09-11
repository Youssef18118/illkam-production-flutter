import 'package:flutter/material.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';

showWorkEditFinishedDialog(BuildContext context){
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder:
              (BuildContext context,
              StateSetter setDialog) {
            return AlertDialog(
              title: Text(
                  "일깜 수정 완료"),
              content: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  Text(
                      "일깜 수정이 완료되었습니다. 일깜 신청이 올 경우 알람을 보내드릴게요.")
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(child: IKCommonBtn(title: "확인", onTap: (){
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }))

                  ],
                )

              ],

            );
          }));
}