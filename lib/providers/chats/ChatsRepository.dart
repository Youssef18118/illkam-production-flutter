import 'dart:convert';

import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/providers/chats/dto/ChatMessage.dart';
import 'package:ilkkam/providers/chats/dto/Chats.dart';
import 'package:ilkkam/providers/chats/dto/CreateChatRes.dart';
import 'package:ilkkam/providers/chats/dto/UnreadRoomInfo.dart';
import 'package:ilkkam/providers/fcm/FCMRepository.dart';

class ChatsRepository {
  final BaseAPI baseAPI = BaseAPI();
  final FCMRepository fcmRepository = FCMRepository();

  Future<bool> exitChat(String chatId) async {
    int userid = await baseAPI.getJWT() ?? 1;
    final resJson = await baseAPI.basicGet("chats/$chatId/exit/$userid");
    return resJson;
  }

  Future<bool> makeActive(String chatId) async {
    final resJson = await baseAPI.basicGet("chats/$chatId/active");
    return resJson;
  }

  Future<List<Chats>> getApplyChats() async {
    int userid = await baseAPI.getJWT() ?? 1;
    print('채팅 employee 불러오기');
    final resJson = await baseAPI.basicGet("chats/$userid/apply");
    List<Chats> result = [];
    resJson.forEach((v) {
      result.add(new Chats.fromJson(v));
    });

    return result;
  }

  Future<List<Chats>> getRequestChat() async {
    int userid = await baseAPI.getJWT() ?? 1;
    print('채팅 employer 불러오기');
    final resJson = await baseAPI.basicGet("chats/$userid/request");
    List<Chats> result = [];
    resJson.forEach((v) {
      result.add(new Chats.fromJson(v));
    });
    return result;
  }

  Future<Chats> getChat(String chatid) async {
    print('채팅 $chatid 불러오기');
    final resJson = await baseAPI.basicGet("chats/$chatid");
    return Chats.fromJson(resJson);
  }

  Future<Chats?> getChatApplier(int workId) async {
    print('채팅  불러오기');
    int userid = await baseAPI.getJWT() ?? 1;
    final resJson = await baseAPI.basicGet("chats/$workId/work/$userid/apply");
    return Chats.fromJson(resJson);
  }
  //
  Future<Chats?> getChatRequester(int workId, int applierId) async {
    print('채팅  불러오기');
    print("$workId  $applierId");
    final resJson =
        await baseAPI.basicGet("chats/$workId/work/$applierId/apply");
    return Chats.fromJson(resJson);
  }

  Future<void> makeChat(int workId) async {
    int userid = await baseAPI.getJWT() ?? 1;
    print('채팅 생성 요청');
    final res = await baseAPI
        .basicPost("chats/", {"employee_id": userid, "work_id": workId});
    // CreateChatRes response = CreateChatRes.fromJson(res);
    // await  createChatRoom(int.parse(res));
  }

  Future<void> makeRequesterChat(int workId, int applierid) async {
    print('채팅 생성 요청');
    final res = await baseAPI
        .basicPost("chats/", {"employee_id": applierid, "work_id": workId});
    // CreateChatRes response = CreateChatRes.fromJson(res);
    // await createChatRoom(int.parse(res));
  }

  Future<void> sendMessage(String roomId, String text, String senderId,
      int receiverId, String senderName,
      {String? imageURL}) async {
    fcmRepository.sendFCM("${senderName} : ${text}", receiverId, roomId);
  }

  Future<List<ChatMessage>> getPastMessages(String roomId, {int page = 0}) async {
    final res = await baseAPI
        .basicGet("chats/messages?chatRoomId=$roomId&page=${page}");
    List<ChatMessage> result = [];
    res['content'].forEach((v) {
      result.add(new ChatMessage.fromJson(v));
    });
    return result;
  }

  Future<void> readReceivedMessage(String roomId, int userid) async {
    print("chats/messages/$roomId/read/$userid");
    await baseAPI
        .basicGet("chats/messages/$roomId/read/$userid");
    return;
  }

  Future<List<UnreadRoomInfo>> getUnreadRoomInfo({int? userid}) async {
    int? jwt = userid;
    if(jwt == null){
      jwt = await baseAPI.getJWT();
    }
    final res = await baseAPI
        .basicGet("chats/unread/$jwt");
    List<UnreadRoomInfo> result = [];
    if(res!= null){
      res.forEach((v) {
        result.add(new UnreadRoomInfo.fromJson(v));
      });
      return result;
    }else{
      return [];
    }


  }
}

Future<void> createChatRoom(
  int roomName,
) async {
  // Firestore에 채팅방 추가
  // await FirebaseFirestore.instance.collection('chat_rooms').doc(roomName.toString()).set({
  //   'roomName': roomName,
  //   'createdAt': FieldValue.serverTimestamp(), // 생성 시간
  // });
}
