// import 'dart:convert';
//
// import 'package:flutter/cupertino.dart';
// import 'package:ilkkam/providers/chats/ChatsRepository.dart';
// import 'package:ilkkam/providers/chats/dto/ChatMessage.dart';
// import 'package:ilkkam/providers/chats/dto/UnreadRoomInfo.dart';
// import 'package:stomp_dart_client/stomp_dart_client.dart';
//
// import '../../apis/base.dart';
//
// class ChatsController with ChangeNotifier {
//   late StompClient stompClient;
//   List<UnreadRoomInfo> unreadRoomInfo = [];
//   ChatsRepository chatsRepository = ChatsRepository();
//   int unreadCount = 0;
//
//   ChatsController(List<UnreadRoomInfo> initRoomINfo) {
//     unreadRoomInfo = initRoomINfo;
//     int count = 0;
//     unreadRoomInfo.forEach((elem){
//       count = count + elem.unreadCount!;
//     });
//     unreadCount = count;
//   }
//
//   void readByEnteringChat(String roomId){
//     unreadRoomInfo.forEach((elem) {
//       if (elem.roomId == roomId) {
//         elem.unreadCount = 0;
//       }
//     });
//     int count = 0;
//     unreadRoomInfo.forEach((elem){
//       count = count + elem.unreadCount!;
//     });
//     unreadCount = count;
//     // notifyListeners();
//   }
//
//   void setLastChat(String roomId, String message){
//     unreadRoomInfo.forEach((elem) {
//       if (elem.roomId == roomId) {
//         elem.unreadCount = elem.unreadCount! + 1;
//         elem.lastChat = message ?? '';
//       }
//     });
//   }
//
//   void subscribeUnreadMessages(int userId) {
//     stompClient = StompClient(
//         config: StompConfig(
//       url: BASE_WS,
//       onConnect: (StompFrame frame) {
//         print("unread Controller socket connected");
//         stompClient.subscribe(
//           destination: "/sub/unread/$userId",
//           callback: (frame) {
//             // frame.body에는 unread message 정보가 포함되어 있음
//             final unreadChat = jsonDecode(frame.body ?? '');
//             ChatMessage info = ChatMessage.fromJson(unreadChat);
//             updateUnreadMessage(info);
//           },
//         );
//       },
//       onWebSocketError: (dynamic error) => print(error),
//     ));
//     stompClient.activate();
//   }
//
//   initializeChat()async{
//     final res = await ChatsRepository().getUnreadRoomInfo();
//     unreadRoomInfo = res;
//     int count = 0;
//     unreadRoomInfo.forEach((elem){
//       count = count + elem.unreadCount!;
//     });
//     unreadCount = count;
//   }
//
//   updateUnreadMessage(ChatMessage info){
//     UnreadRoomInfo unreadRoom = unreadRoomInfo.firstWhere((elem)=> elem.roomId == info.roomId, orElse: () => UnreadRoomInfo(
//       roomId: "-1",
//       unreadCount: 0
//     ));
//     if(unreadRoom.roomId == "-1"){
//       unreadRoom.roomId = info.roomId;
//       unreadRoom.unreadCount = 1;
//       unreadRoom.lastChat = info.message;
//       unreadRoom.lastChatTime = info.createdAt;
//       unreadRoomInfo.add(unreadRoom);
//     }else{
//       unreadRoom.unreadCount = unreadRoom.unreadCount! + 1;
//       unreadRoom.lastChat = info.message ?? '';
//       unreadRoom.lastChatTime= info.createdAt;
//     }
//
//     int count = 0;
//     unreadRoomInfo.forEach((elem){
//       count = count + elem.unreadCount!;
//     });
//     unreadCount = count;
//     notifyListeners();
//   }
// }
