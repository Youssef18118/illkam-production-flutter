import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

const String BASE_URL = "https://api.ilkkam.com/api/v1/";
const String BASE_WS = "wss://chat.ilkkam.com/chat/inbox";
// const String BASE_URL = "http://127.0.0.1:8080/api/v1/";

// const String BASE_URL = "http://10.0.2.2:8080/api/v1/";
// const String BASE_WS = "ws://10.0.2.2:8080/chat/inbox";
//
final dio = Dio();

class BaseAPI {
  String? accessToken;
  String? refreshToken;

  Future<int?> getJWT() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? jwt = prefs.getInt('jwt');
    // return 1;
    return jwt;
    // return null;
  }

  Future<void> saveJWT(int token) async {
    print("saveJWT working");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt("jwt", token);
  }

  Future<void> clearAllSharedPref() async {
    print("clearAllSharedPref working after sign out");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<dynamic> basicGet(String route, {bool auth = true}) async {
    String base = BASE_URL;
    String url = '$base$route';
    Map<String, String> headers = {};

    if (auth) {
      int? jwt = await getJWT();
      if (jwt != null) {
        String accessToken = jwt.toString();
        headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> basicDelete(String route, {bool auth = true}) async {
    final url = '$BASE_URL$route';
    Map<String, String> headers = {};

    if (auth) {
      int? jwt = await getJWT();
      if (jwt != null) {
        String accessToken = jwt.toString();
        headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    try {
      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<dynamic> basicPost(
      String route, dynamic body, {bool auth = true}) async {
    final url = '$BASE_URL$route';
    Map<String, String> headers = {"Content-Type": "application/json"};

    if (auth) {
      int? jwt = await getJWT();
      if (jwt != null) {
        String accessToken = jwt.toString();
        headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    try {
      final response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode(body));
      print(json.encode(body));

      if (response.statusCode == 200) {
        try {
          print(json.encode(response));
          final data = json.decode(response.body);
          print(json.encode(response.body));
          return data;
        } catch (error) {
          return response.body;
        }
      } else {
        print(response.body);
        return null;
      }
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<dynamic> basicPut(String route, dynamic body, {bool auth = true}) async {
    final url = '$BASE_URL$route';
    Map<String, String> headers = {"Content-Type": "application/json"};

    if (auth) {
      int? jwt = await getJWT();
      if (jwt != null) {
        String accessToken = jwt.toString();
        headers['Authorization'] = 'Bearer $accessToken';
      }
    }

    try {
      final response = await http.put(Uri.parse(url),
          headers: headers, body: json.encode(body));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
