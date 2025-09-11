import 'package:flutter/material.dart';

class IKCompactTextBtn extends StatelessWidget {
  final String label;
  final void Function()? onPressed;

  const IKCompactTextBtn(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: 30,
      minWidth: 0,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      shape: RoundedRectangleBorder(
        side: BorderSide(width: 1, color: Color(0xFF01A9DB)),
        borderRadius: BorderRadius.circular(48),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Color(0xFF01A9DB),
          fontSize: 13,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
