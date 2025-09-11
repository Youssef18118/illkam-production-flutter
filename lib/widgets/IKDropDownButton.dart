import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IKDropdownBtn extends StatelessWidget {
  void Function()? onPressed;
  String label;

  IKDropdownBtn({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Container(
      constraints: BoxConstraints(
          maxWidth: 100
      ),
      child: MaterialButton(
        onPressed: onPressed,
        minWidth: 0,
        padding: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Color(0xFFF4F4F4)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Expanded(child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Color(0xFF7D7D7D),
                fontSize: 13,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
              ),
            ),),
            SizedBox(
              width: 8,
            ),
            Transform.rotate(
              angle: pi / 2,
              child: SvgPicture.asset("assets/main/arrow_black.svg"),
            )
          ],
        ),
      ),
    ));
  }
}
