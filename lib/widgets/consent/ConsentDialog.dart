// lib/widgets/consent/ConsentDialog.dart (Final Version)

import 'package:flutter/material.dart';

class ConsentDialog extends StatelessWidget {
  final String title;
  final String content;

  const ConsentDialog({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    // Splits content into paragraphs based on empty lines
    final List<String> paragraphs = content
        .trim()
        .split(RegExp(r'\n\s*\n'))
        .where((s) => s.trim().isNotEmpty)
        .toList();

    return AlertDialog(
      // Matching the peachy background color from the image
      backgroundColor: const Color(0xFFFDF6F3), 
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      // Ensure the title is bold, as in the image
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      content: SingleChildScrollView(
        child: ListBody(
          children: paragraphs.map((paragraph) {
            
            // --- THIS IS THE FIX ---
            // This removes leading whitespace from EVERY line within a paragraph,
            // fixing the unwanted indentation.
            final cleanedParagraph = paragraph.replaceAll(RegExp(r'^\s+', multiLine: true), '');

            // Check if the paragraph is a title like "제 1 조 (총칙)"
            final bool isTitle = cleanedParagraph.startsWith('제') && cleanedParagraph.contains('조');

            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                cleanedParagraph,
                style: TextStyle(
                  fontSize: isTitle ? 16.0 : 14.5,
                  height: 1.6, // Line spacing for readability
                  color: const Color(0xFF3D3D3D),
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        // Styling the button to match the screenshot
        SizedBox(
          width: double.infinity,
          height: 50,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              '확인',
              style: TextStyle(
                color: Color(0xFF555555),
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}