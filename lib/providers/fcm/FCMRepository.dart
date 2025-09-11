import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/providers/fcm/dto/Notifications.dart';

class FCMRepository{
  final BaseAPI baseAPI = BaseAPI();

  Future<List<Notifications>> getAllNotifications()async {
    print("noti 가져오기 ");
    int? jwt = await baseAPI.getJWT();
    final resJson = await baseAPI.basicGet("fcm/$jwt/user");
    List<Notifications> result = [];
    resJson.forEach((v) {
      result.add(new Notifications.fromJson(v));
    });

    return result;
  }

  Future<void> sendFCM(String content, int opId, String chatId)async {
    print("채팅 알람 보내기");
    print(opId);

    final resJson = await baseAPI.basicPost("fcm/$opId/user",{
      "title":"채팅 알림",
      "body" :content,
      "routeName":"chat",
      "targetPageId": chatId
    });
  }
}