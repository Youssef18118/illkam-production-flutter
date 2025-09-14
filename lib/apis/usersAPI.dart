import 'dart:convert';

import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/models/req/UsersLoginReq.dart';
import 'package:ilkkam/models/req/UsersSaveReq.dart';
import 'package:http/http.dart' as http;
import 'package:ilkkam/providers/works/Works.dart';

class UsersService {
  final BaseAPI baseAPI = BaseAPI();

  Future<Users?> getUserData() async {
    int? jwt = await baseAPI.getJWT();
    print('유저 데이터 불러오기');
    final resJson = await baseAPI.basicGet("users/$jwt");
    if (resJson != null) {
      final result = Users.fromJson(resJson);
      return result;
    }
    return null;
  }

  Future<Users?> getUserInfo(int userid) async {
    print('유저 데이터 불러오기 $userid');
    final resJson = await baseAPI.basicGet("users/$userid");
    if (resJson != null) {
      final result = Users.fromJson(resJson);
      return result;
    }
    return null;
  }

  Future<Users?> getApplierInfo(int userid) async {
    print('유저 데이터 불러오기 $userid');
    final resJson = await baseAPI.basicGet("users/$userid/applier");
    if (resJson != null) {
      final result = Users.fromJson(resJson);
      return result;
    }
    return null;
  }

  Future<Users?> getEmployerInfo(int userid) async {
    print('유저 데이터 불러오기 $userid');
    final resJson = await baseAPI.basicGet("users/$userid/employer");
    if (resJson != null) {
      final result = Users.fromJson(resJson);
      return result;
    }
    return null;
  }

  Future<void> withdraw() async {
    int? jwt = await baseAPI.getJWT();
    await baseAPI.basicDelete("users/$jwt");
    return;
  }

  Future<int?> register(UserSaveReq body) async {
    try {
      final response = await http.post(
        Uri.parse("${BASE_URL}users/"),
        body: json.encode(body.toJson()),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        int res = json.decode(response.body);
        await baseAPI.saveJWT(res);
        return res;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<int?> login(UserLoginReq body) async {
    try {
      final response = await http.post(
        Uri.parse("${BASE_URL}users/login"),
        body: json.encode(body.toJson()),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        int res = json.decode(response.body);
        await baseAPI.saveJWT(res);
        return res;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<int?> edit(UserSaveReq body) async {
    int? jwt = await baseAPI.getJWT();
    try {
      final response = await http.post(
        Uri.parse("${BASE_URL}users/$jwt/edit"),
        body: json.encode(body.toJson()),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        int res = json.decode(response.body);
        await baseAPI.saveJWT(res);
        return res;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<int?> setFCM(UserSaveReq body) async {
    int? jwt = await baseAPI.getJWT();
    try {
      final response = await http.post(
        Uri.parse("${BASE_URL}users/$jwt/fcm"),
        body: json.encode(body.toJson()),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        int res = json.decode(response.body);
        await baseAPI.saveJWT(res);
        return res;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<void> setMarketingConsent(int userId, bool consent) async {
    try {
      final response = await http.put(
        Uri.parse("${BASE_URL}users/$userId/marketing-consent"),
        body: json.encode({"marketingConsent": consent}),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        print(
            'Successfully updated marketing consent for user $userId to $consent');
      } else {
        print(
            'Failed to update marketing consent for user $userId. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to update marketing consent for user $userId. Error: $e');
    }
  }

  Future<void> setOrderConsent(int userId, bool consent) async {
    try {
      final response = await http.put(
        Uri.parse("${BASE_URL}users/$userId/order-consent"),
        body: json.encode({"orderConsent": consent}),
        headers: {
          "Content-Type": "application/json",
        },
      );
      if (response.statusCode == 200) {
        print(
            'Successfully updated order consent for user $userId to $consent');
      } else {
        print(
            'Failed to update order consent for user $userId. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Failed to update order consent for user $userId. Error: $e');
    }
  }
}
