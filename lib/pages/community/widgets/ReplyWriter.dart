import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/providers/posts/PostsController.dart';
import 'package:ilkkam/widgets/IKTextField.dart';
import 'package:provider/provider.dart';

class ReplyWriter extends StatefulWidget {
  const ReplyWriter({super.key});

  @override
  State<ReplyWriter> createState() => _ReplyWriterState();
}

class _ReplyWriterState extends State<ReplyWriter> {
  TextEditingController reply = TextEditingController();

  bool isReplying = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 26,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 72,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/community/reply-camera.svg",
            width: 24,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: IkTextField(
              placeholder: "댓글을 입력해주세요.",
              controller: reply,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () {
              if(isReplying){
                return;
              }
              isReplying = true;
              String text = reply.text;
              reply.clear();
              if (text != "") {
                Provider.of<PostsController>(context, listen: false)
                    .reply(text).then((v)=>{
                isReplying = false
                });
                FocusScope.of(context).unfocus();
              }
            },
            // padding:EdgeInsets.zero,
            child: SvgPicture.asset(
              "assets/community/reply-send.svg",
              width: 24,
              color: Color(0xFF01A9DB),
            ),
          )
        ],
      ),
    );
  }
}
