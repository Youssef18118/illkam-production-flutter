import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/pages/chat/widgets/ChatWriter.dart';
import 'package:ilkkam/providers/chats/ChatsController.dart';
import 'package:ilkkam/providers/chats/ChatsRepository.dart';
import 'package:ilkkam/providers/chats/dto/ChatMessage.dart';
import 'package:ilkkam/providers/chats/dto/Chats.dart';
import 'package:ilkkam/providers/chats/dto/ReadMessage.dart';
import 'package:ilkkam/providers/users/UserController.dart';
import 'package:ilkkam/widgets/ChatSummary.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:ilkkam/apis/usersAPI.dart';

import '../../utils/ImageDialog.dart';
import '../CommonUserPage.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "/chat/screen";

  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // 채팅 목록을 저장할 리스트
  List<ChatMessage> messages = [];
  List<String> items = [];
  int page = 0;
  bool isMore = false;
  bool isLoading = false; // 로딩 상태 체크

  final ScrollController _scrollController = ScrollController();
  late StompClient stompClient;
  final ChatsRepository chatsRepository = ChatsRepository();

  final BaseAPI baseAPI = BaseAPI();

  void listner(ScrollUpdateNotification notification) async {
    if (isLoading) return;

    setState(() {
      isLoading = true; // 로딩 상태 표시
    });
    // if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent * 0.85) {
    if (notification.metrics.maxScrollExtent * 0.85 <
        notification.metrics.pixels) {
      page++;
      await Provider.of<ChatsController>(context, listen: false)
          .getChatRoomDetails(page: page);
    }
    setState(() {
      isLoading = false; // 로딩 상태 표시
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    int myId = Provider
        .of<UserController>(context, listen: false)
        .me
        ?.id ?? -1;

    Provider.of<ChatsController>(context, listen: false)
        .getChatRoomDetails()
        .then((v) =>
    {
      Provider.of<ChatsController>(context, listen: false)
          .updateMessageAsRead(myId)
    });
    final chat =
        Provider
            .of<ChatsController>(context, listen: false)
            .selectedChats;
    Provider.of<ChatsController>(context, listen: false)
        .readByEnteringChat(chat?.id ?? '');

    stompClient = StompClient(
        config: StompConfig(
          url: BASE_WS,
          onConnect: (StompFrame frame) {
            // 채팅방 입장 시 읽음 안내
            stompClient.send(
                destination: '/pub/message/read', // 전송할 destination
                body: jsonEncode(
                    ReadMessage(roomId: chat?.id, userId: myId)
                        .toJson())
            );
            stompClient.subscribe(
              destination: '/sub/channel/${chat?.id}',
              callback: (frame) {
                if (mounted) {
                  print("sub arrived");
                  Map<String, dynamic> obj = json.decode(frame.body!);
                  ChatMessage message = ChatMessage(
                      createdAt: obj['createdAt'],
                      roomId: obj['roomId'],
                      authorId: obj['authorId'],
                      readCount: int.parse(obj['authorId']) != myId ? 2 : 1,
                      message: obj['message']);
                  Provider.of<ChatsController>(context, listen: false)
                      .receiveMessage(message, myId);

                  Provider.of<ChatsController>(context, listen: false)
                      .readAllChatsLocal(message.roomId ?? '');
                  // 채팅 도중 상대방 채팅 도착 시
                  if (obj["authorId"] != myId.toString()) {
                    stompClient.send(
                        destination: '/pub/message/read', // 전송할 destination
                        body: jsonEncode(
                            ReadMessage(roomId: message.roomId, userId: myId)
                                .toJson())
                        // 메시지의 내용
                        //   읽음 처리
                        );
                  } else {
                    Provider.of<ChatsController>(context, listen: false)
                        .readByEnteringChat(obj['roomId']);
                  }
                  // _scrollToBottom();
                  // 메시지 수신 시 수행할 작업
                }
              },
            );
            // 읽음 상태에 대한 알림 구독
            stompClient.subscribe(
              destination: '/sub/channel/${chat?.id}/read',
              callback: (frame) {
                if (mounted) {
                  final data = jsonDecode(frame.body!);
                  final messageId = data['messageId'];
                  final userId = data['userId'];
                  // UI에서 읽음 상태를 업데이트
                  Provider.of<ChatsController>(context, listen: false)
                      .updateMessageAsRead(userId);
                }
              },
            );
          },
          onWebSocketError: (dynamic error) => print(error),
        ));
    stompClient.activate();
  }

  @override
  void dispose() {
    super.dispose();
    // 웹소켓에서 연결 해제
    stompClient.deactivate();
    // Provider.of<ChatsController>(context, listen: false).selectedChats = null;
    // 텍스트 입력 컨트롤러 해제
  }

  @override
  Widget build(BuildContext context) {
    final chatP = Provider.of<ChatsController>(context);
    Chats? chat = chatP.selectedChats;

    int userid = Provider
        .of<UserController>(context)
        .id;
    String? nickname =
        Provider
            .of<UserController>(context, listen: false)
            .me
            ?.name;
    if (chat == null) {
      return SizedBox.shrink();
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          scrolledUnderElevation: 0,
          title: Text(
            chatP.selectedChatsOpName ?? '',
            style: TextStyle(
              color: Color(0xFF121212),
              fontSize: 19,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
            ),
          )),
      backgroundColor: Colors.white,
      body: SafeArea(child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            ChatSummary(
                workType: chat.workType,
                price: chat.price,
                workDate: chat.workDate,
                address: chat.address,
                workId: chat.workId),
            // 정보 배너 추가
            _infoBanner(),
            Expanded(
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(20),
                child: NotificationListener<ScrollUpdateNotification>(
                    onNotification: (ScrollUpdateNotification notification) {
                      listner(notification);
                      return false;
                    },
                    child: ListView.separated(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: chatP.roomMessages.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final messages = chatP.roomMessages;
                        final message = messages[index];
                        final text = message.message ?? '';
                        final sender = message.authorId ?? '-1';
                        final timestamp = message.createdAt != null
                            ? DateTime.parse(message.createdAt!)
                            : DateTime.now();
                        final int readCount = message.readCount ?? 1;
                        String? image;
                        if (message.message!.startsWith("base64/image:")) {
                          image = message.message?.split("base64/image:")[1];
                        }
                        if (int.parse(sender) == userid) {
                          return myChat(text, timestamp,
                              image: image,
                              context: context,
                              readCount: readCount);
                        } else {

                          // 채팅 0번째 메세지이거나,
                          // 이전 메세지의 발송자가 내가 아니어야 함
                          bool isFirst = index == messages.length -1 ||
                              messages[index+1].authorId ==
                                  userid.toString();

                          // bool isContinued = index != 0 &&
                          //     int.parse(messages[index - 1].authorId ?? '1') !=
                          //         userid;
                          return OpChat(chatP.selectedChatsOpName ?? '',
                              chatP.selectedChatsOpPhoto, text, timestamp,
                              isFirst: isFirst,
                              image: image,
                              readCount: readCount,
                              context: context,
                              senderId: int.parse(sender));
                        }
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(
                            height: 4,
                          ),
                    )),
              ),
            ),
            ChatWriter(
                roomId: chat.id.toString(),
                senderId: userid.toString(),
                receiverId: chatP.selectedChatsOpId ?? -1,
                // onSend: _scrollToBottom,
                sendMessage: (String? val) async {
                  int? receiverId = chat.employerId == userid
                      ? chat.employeeId
                      : chat.employerId;
                  String? receiverName = chat.employerId == userid
                      ? chat.employeeName
                      : chat.employerName;
                  
                  String? senderName = nickname;
                  if (senderName == null || senderName.isEmpty) {
                    final user = await UsersService().getUserInfo(userid);
                    senderName = user?.name;
                  }

                  stompClient.send(
                      destination: '/pub/message', // 전송할 destination
                      body: jsonEncode(ChatMessage(
                          roomId: chat.id,
                          receiverId: receiverId,
                          authorId: userid.toString(),
                          message: val,
                          readCount: 1)
                          .toJson())
                    // 메시지의 내
                  );

                  chatsRepository.sendMessage(
                      chat.id ?? '', val?? '', userid.toString(), receiverId ?? -1, senderName ?? '');
                  Provider.of<ChatsController>(context, listen: false)
                      .setLastChat(chat.id ?? '', val ?? '');
                  chatP
                      .sortChats();
                },
                onSend: () => {},
                receiverName: nickname ?? '')
            // chatP.selectedChatsOpName ?? ''),
          ],
        ),
      )),
    );
  }

  Widget OpChat(String opName, String? OpPhoto, String message,
      DateTime timestamp,
      {bool isFirst = false,
        int readCount = 1,
        String? image,
        required BuildContext context,
        required int senderId}) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed(CommonUserPage.routeName, arguments: senderId);
          },
          child: Container(
            width: 32,
            height: 32,
            child: !isFirst
                ? Container()
                : OpPhoto != null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
              Image.network(
                OpPhoto,
                fit: BoxFit.fill,
                width: 32,
                height: 32,
              ),
              // )
            )
                : SvgPicture.asset("assets/main/user_ico.svg",
                fit: BoxFit.fill, width: 32, height: 32),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isFirst)
                  Text(
                    opName,
                    style: TextStyle(
                      color: Color(0xFF7D7D7D),
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: ShapeDecoration(
                          color: Color(0xFFF2F2F2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: image != null
                            ? GestureDetector(
                          onTap: () {
                            showImageDialog(
                                Image.network(
                                  image,
                                  fit: BoxFit.fill,
                                ),
                                context);
                          },
                          child: Image.network(image,
                              width: 100, height: 100, fit: BoxFit.fill),
                        )
                            : Text(
                          message,
                          style: TextStyle(
                            color: Color(0xFF545454),
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      DateFormat("a hh:mm", "ko").format(timestamp),
                      style: TextStyle(
                        color: Color(0xFFADADAD),
                        fontSize: 10,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    if (readCount == 1)
                      Text(
                        "안읽음",
                        style: TextStyle(
                          color: Color(0xFFADADAD),
                          fontSize: 10,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                  ],
                )
              ],
            ))
      ],
    );
  }

  Widget myChat(String message,
      DateTime? timestamp, {
        int readCount = 1,
        String? image,
        required BuildContext context,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (readCount == 1)
          Text(
            "안읽음",
            style: TextStyle(
              color: Color(0xFFADADAD),
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
            ),
          ),
        SizedBox(
          width: 6,
        ),
        if (timestamp != null)
          Text(
            DateFormat("a hh:mm", "ko").format(timestamp),
            style: TextStyle(
              color: Color(0xFFADADAD),
              fontSize: 10,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w400,
            ),
          ),
        SizedBox(
          width: 8,
        ),
        Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: ShapeDecoration(
                color: Color(0xFF01A9DB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: image != null
                  ? GestureDetector(
                  onTap: () {
                    showImageDialog(
                        Image.network(
                          image,
                          fit: BoxFit.fill,
                        ),
                        context);
                  },
                  child: Image.network(
                    image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ))
                  : Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ))
      ],
    );
  }
}

  // 채팅 상단에 노출되는 안내 배너 위젯
  Widget _infoBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4EF), // 부드러운 베이지 톤 배경색
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 아이콘 영역
          Container(
            width: 30,
            height: 30,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Colors.green, // 기존 앱에서 사용하던 포인트 컬러
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 5),
          // 안내 문구
          const Expanded(
            child: Center(
              child: Text(
                "고객정보는 소중합니다.\n서비스 관련 대화 시,\n반드시 고객의 동의를 먼저 확인해주세요",
                style: TextStyle(
                  color: Color(0xFF545454),
                  fontSize: 16,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
