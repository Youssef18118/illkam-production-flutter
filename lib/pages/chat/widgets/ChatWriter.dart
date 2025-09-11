import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/providers/chats/ChatsRepository.dart';
import 'package:ilkkam/providers/posts/PostsController.dart';
import 'package:ilkkam/utils/imagePicker.dart';
import 'package:ilkkam/utils/styles.dart';
import 'package:ilkkam/widgets/IKTextField.dart';
import 'package:provider/provider.dart';

class ChatWriter extends StatefulWidget {
  final String roomId, senderId,receiverName;
  final int receiverId;
  final Function onSend;
  final Function sendMessage;


  const ChatWriter(
      {super.key,
      required this.roomId,
      required this.senderId,
        required this.onSend,
      required this.receiverId,
      required this.receiverName,
        required this.sendMessage
      });
  @override
  State<ChatWriter> createState() => _ReplyWriterState();
}

class _ReplyWriterState extends State<ChatWriter> {
  TextEditingController reply = TextEditingController();
  ChatsRepository chatsRepository = ChatsRepository();
  bool imageLoading = false;

  @override
  Widget build(BuildContext context) {
    print(widget.receiverId);
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
          imageLoading
              ? const RefreshProgressIndicator(elevation: 0,color: AppColors.accentBackground,backgroundColor: Colors.transparent,)
              : GestureDetector(
                  onTap: () async {
                    setState(() {
                      imageLoading=true;
                    });
                    String? imageURL = await pickImage(PickUsageType.CHAT);
                    if (imageURL != null) {
                      // chatsRepository.sendMessage(widget.roomId, "이미지 전송",
                      //     widget.senderId, widget.receiverId,widget.receiverName,
                      //     imageURL: imageURL);
                      widget.sendMessage("base64/image:$imageURL");
                    }
                    setState(() {
                      imageLoading=false;
                    });
                  },
                  child: SvgPicture.asset(
                    "assets/community/reply-camera.svg",
                    width: 24,
                  ),
                ),
          const SizedBox(width: 8),
          Expanded(
            child: IkTextField(
              placeholder: "대화내용을 입력해주세요.",
              controller: reply,
              onTap: widget.onSend,
            ),
          ),
          const SizedBox(width: 8),
          MaterialButton(
            minWidth: 0,
            visualDensity: VisualDensity.compact,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100)
            ),
            onPressed: () {
              String text = reply.text;
              reply.clear();
              if (text != "") {
                widget.sendMessage(text);
                reply.clear();
                widget.onSend();

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
