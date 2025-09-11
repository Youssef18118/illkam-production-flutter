

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ilkkam/providers/posts/PostsController.dart';
import 'package:ilkkam/providers/posts/PostsRepository.dart';
import 'package:ilkkam/widgets/IKCommonBtn.dart';
import 'package:provider/provider.dart';

showCommuDeleteConfirmDialog(BuildContext context, int postId){
  showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) =>
          StatefulBuilder(builder:
              (BuildContext context,
              StateSetter setDialog) {
            return AlertDialog(
              title: Text(
                  "일깜 삭제"),
              content: Column(
                mainAxisSize:
                MainAxisSize.min,
                children: [
                  Text(
                      "일깜을 삭제하시겠습니까? 삭제된 일깜은 복구되지 않습니다.")
                ],
              ),
              actions: [
                Row(
                  children: [
                    Expanded(child: IKCommonBtn(title: "취소", onTap: (){
                      Navigator.of(context).pop();
                    }, type: BTN_TYPE.secondary,)),
                    SizedBox(width: 12,),
                    Expanded(child: IKCommonBtn(title: "확인", onTap: ()async {
                      PostsRepository postRepository = PostsRepository();

                      await postRepository.removePost(postId);
                      await Provider.of<PostsController>(context, listen: false).reload();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    }))
                  ],
                )

              ],

            );
          }));
}