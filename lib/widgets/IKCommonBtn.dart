import 'package:flutter/material.dart';

enum BTN_TYPE { primary, secondary }

class IKCommonBtn extends StatelessWidget {
  const IKCommonBtn({super.key, required this.title, required this.onTap, this.type = BTN_TYPE.primary});

  final String title;
  final void Function()? onTap;
final BTN_TYPE type;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onTap,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0xFF01A9DB)),
        borderRadius: BorderRadius.circular(10),
      ),
      color: type == BTN_TYPE.primary?  Color(0xFF01A9DB): Colors.white,
      minWidth: 0,
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Text(
        title,
        style: TextStyle(
          color: type == BTN_TYPE.primary?   Color(0xFFFAFAFA) : Color(0xFF01A9DB),
          fontSize: 17,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
          // height: 0.08,
        ),
      ),
    );
  }
}
