import 'package:flutter/material.dart';
import 'package:ilkkam/providers/posts/Posts.dart';

class ArticleLabel extends StatelessWidget {
  final Category dto;
  const ArticleLabel({super.key, required this.dto});

  @override
  Widget build(BuildContext context) {
    return  Container(
      // height: 22,
      padding: const EdgeInsets.all(4),
      decoration: ShapeDecoration(
        color: Color(0xFFE8F8FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
      ),
      child: Text(
        dto.name ?? '',
        style: TextStyle(
          color: Color(0xFF01A9DB),
          fontSize: 12,
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w500,
          letterSpacing: -0.12,
        ),
      ),
    );
  }
}