import 'package:flutter/material.dart';

showImageDialog(Widget image, BuildContext context){
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: InteractiveViewer(
          child: image
        ),
      ),
    ),
  );
}