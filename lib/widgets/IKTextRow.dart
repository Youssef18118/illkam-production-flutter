import 'package:flutter/material.dart';

class IKTextRow extends StatelessWidget {
  final String title;
  final String? detail;
  final bool isEssential;
  const IKTextRow({super.key, required this.title, required this.detail, this.isEssential = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Row(
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
                Row(
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Color(0xFF7D7D7D),
                        fontSize: 13,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.13,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          Text(
            detail ?? "",
            textAlign: TextAlign.right,
            style: TextStyle(
              color: Color(0xFF41474A),
              fontSize: 14,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w500,
              // height: 1.57,
            ),
          ),
        ],
      ),
    );
  }
}
