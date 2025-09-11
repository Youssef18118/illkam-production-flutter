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
    // If there is no JWT, we know there is no user. Return null immediately.
    if (jwt == null) {
      return null;
    }
    print('유저 데이터 불러오기');
    final resJson = await baseAPI.basicGet("users/${jwt}");

    // If the API call returns null (e.g., invalid/expired token), return null.
    if (resJson == null) {
      return null;
    }

    final result = Users.fromJson(resJson);
    return result;
  }

  Future<Users> getUserInfo(int userid) async {
    print('유저 데이터 불러오기 $userid');
    final resJson = await baseAPI.basicGet("users/$userid");
    final result = Users.fromJson(resJson);
    return result;
  }

  Future<Users> getApplierInfo(int userid) async {
    print('유저 데이터 불러오기 $userid');
    final resJson = await baseAPI.basicGet("users/$userid/applier");
    final result = Users.fromJson(resJson);
    return result;
  }
  Future<Users> getEmployerInfo(int userid) async {
    print('유저 데이터 불러오기 $userid');
    final resJson = await baseAPI.basicGet("users/$userid/employer");
    final result = Users.fromJson(resJson);
    return result;
  }

  Future<void> withdraw() async {
    int? jwt =await baseAPI.getJWT();
    await baseAPI.basicDelete("users/$jwt");
    return;
  }

  Future<int> register(UserSaveReq body) async {
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
      throw Exception('Failed to fetch');
    }
  }

  Future<int> login(UserLoginReq body) async {
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
      throw Exception('Failed to fetch');
    }
  }

  Future<int> edit(UserSaveReq body) async {
    int? jwt =await baseAPI.getJWT();
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
      throw Exception('Failed to fetch');
    }
  }

  Future<int> setFCM(UserSaveReq body) async {
    int? jwt =await baseAPI.getJWT();
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
      throw Exception('Failed to fetch');
    }
  }

  Future<void> setMarketingConsent(int userId, bool consent) async {
    final response = await http.put(
      Uri.parse("${BASE_URL}users/$userId/marketing-consent"),
      body: json.encode({"marketingConsent": consent}),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      print('Successfully updated marketing consent for user $userId to $consent');
    } else {
      print('Failed to update marketing consent for user $userId. Status code: ${response.statusCode}');
      throw Exception('Failed to update marketing consent');
    }
  }
}
