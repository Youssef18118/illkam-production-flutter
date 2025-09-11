import 'package:flutter/material.dart';
import 'package:ilkkam/utils/ImageDialog.dart';

class IKImageList extends StatelessWidget {
  final String label;
  final List<String> images;
  int? count;

  IKImageList({super.key, required this.label, required this.images,
    this.count
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // SizedBox(width: 72,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Color(0xFF7D7D7D),
                fontSize: 12,
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w600,
                letterSpacing: -0.12,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            SizedBox(
              height: 80,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  separatorBuilder: (ctx, idx) => SizedBox(
                    width: 12,
                  ),
                  itemCount: images.length,
                  itemBuilder: (ctx, idx) {
                    return GestureDetector(
                      onTap: (){
                        showImageDialog(Image.network(
                          images[idx],
                          fit: BoxFit.fill,
                        ),context);
                      },
                      child: Container(
                        width: 80,
                        height: 80,
                        clipBehavior: Clip.antiAlias,
                        decoration: ShapeDecoration(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            // side: BorderSide(width: 1, color: Color(0xFFE1E1E1)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Image.network(
                          images[idx],
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  }),
            )
          ],
        )
      ],
    );
  }
}
