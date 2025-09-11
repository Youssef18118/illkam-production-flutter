import 'package:flutter/material.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';

showTwoButtonDialog(BuildContext context, String title, String contents, Function onClose, Function onConfirm) {
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
              builder: (BuildContext context, StateSetter setDialog) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: Text(title, style: TextStyle(
                color: Color(0xFF191919),
                fontSize: 19,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
              ),),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [Text(contents,style: TextStyle(
                  color: Color(0xFF63696C),
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),)],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(
                        child: IKCommonBtn(
                            title: "닫기",
                            type: BTN_TYPE.secondary,
                            onTap: () {
                              Navigator.pop(context);
                            })),
                    SizedBox(width: 8,),
                    Expanded(
                        child: IKCommonBtn(
                            title: "확인",
                            onTap: () {
                              onConfirm();
                              // Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            }))
                  ],
                )
              ],
            );
          }));
}
