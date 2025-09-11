import 'package:flutter/material.dart';

class TextTitleBar extends StatelessWidget  implements PreferredSizeWidget{
  const TextTitleBar({super.key, required this.title});

  final String title;


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF494949),
          fontSize: 15,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          letterSpacing: -0.15,
        ),
      ),
    );
  }
}
