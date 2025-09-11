import 'package:flutter/material.dart';

class IKBlankDivider extends StatelessWidget {
  double margin = 0;
  IKBlankDivider({super.key, this.margin = 0});

  @override
  Widget build(BuildContext context) {
    return Container(
          margin: EdgeInsets.symmetric(vertical: margin),
        height: 6,color: const Color(0xFFFAFAFA));
  }
}
