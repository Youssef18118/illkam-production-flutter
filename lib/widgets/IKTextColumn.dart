import 'package:flutter/material.dart';

class IKTextColumn extends StatelessWidget {
  final String title;
  final String? detail;

  const IKTextColumn({super.key, required this.title, required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 70,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 2,
              height: 2,
              decoration: ShapeDecoration(
                color: Color(0xFFA3A3A3),
                shape: OvalBorder(),
              ),
            ),
            SizedBox(width: 4,),
            Text(
              title,
              style: TextStyle(
                color: Color(0xFF7D7D7D),
                fontSize: 13,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                letterSpacing: -0.13,
              ),
            ),
          ],
        ),),
        Flexible(
          child: Wrap(
            children: [
              Text(
                detail ?? "",
                style: TextStyle(
                  color: Color(0xFF41474A),
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),



      ],
    );
  }
}
