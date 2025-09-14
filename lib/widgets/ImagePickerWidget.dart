import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ImagePickerWidget extends StatelessWidget {
  final int length;
  final int count;
  final void Function()? onTap;
  final void Function(int)? onDelete;
  final List<String> img;
  final String label;
  final bool isImageUploading;
  final bool required;
  final bool hasError;

  const ImagePickerWidget(
      {super.key,
      required this.label,
      required this.length,
      required this.count,
      required this.onTap,
        this.onDelete,
      required this.isImageUploading,
        this.required = false,
        this.hasError = false,
      required this.img});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              color: Color(0xFF949494),
              fontSize: 12,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              letterSpacing: -0.12,
            ),
            children: [
              if (required)
                TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.12,
                  ),
                ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 108,
          child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              separatorBuilder: (ctx, idx) => SizedBox(
                    width: 12,
                  ),
              itemCount: count + 1,
              itemBuilder: (ctx, idx) {
                if (idx == 0) {
                  return _basicCameraBtn(
                      length, count, onTap, isImageUploading, hasError);
                } else {
                  return Container(
                    width: 107,
                    height: 106,
                    clipBehavior: Clip.antiAlias,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: hasError ? Colors.red : Color(0xFFE1E1E1)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Image.network(img[idx-1], fit: BoxFit.fill,width: 107,),
                        IconButton(onPressed: (){
                          if(onDelete != null){
                            onDelete!(idx-1);
                          }
                        }, icon: Icon(Icons.close),)
                      ],
                    ),
                  );
                }
              }),
        )
      ],
    );
  }

  Widget _basicCameraBtn(int length, int count, void Function()? onTap,
          bool isImageUploading, bool hasError) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          width: 106,
          height: 106,
          clipBehavior: Clip.antiAlias,
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: hasError ? Colors.red : Color(0xFFE1E1E1)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isImageUploading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/common/camera-upload.svg"),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '$count/$length',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFACACAC),
                        fontSize: 13,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                        letterSpacing: -0.13,
                      ),
                    ),
                  ],
                ),
        ),
      );
}
