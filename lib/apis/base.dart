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

  // Future<dynamic> basicGet(String route) async {
  //   String base = BASE_URL;
  //   String url = '$base$route';

  //   int? jwt = await getJWT();

  //   if (jwt == null) {
  //     return;
  //   }

  //   // TODO jwt 갱신하거나 로그아웃 하는 방안
  //   String? accessToken = jwt.toString();
  //   final response = await http.get(Uri.parse(url),headers:{
  //      'Authorization': 'Bearer $accessToken', // Bearer 토큰 추가
  //    });
  //   // }: Options(headers:{
  //   //   'Authorization': 'Bearer $accessToken', // Bearer 토큰 추가
  //   // }));


  //   if (response.statusCode == 200) {
  //     final data = json.decode(response.body);
  //     return data;
  //   } else {
  //     throw Exception('Failed to fetch');
  //   }
  // }
  
  Future<dynamic> basicGet(String route) async {
    String base = BASE_URL;
    String url = '$base$route';

    int? jwt = await getJWT();

    // Prepare headers map
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    // If a JWT exists, add the Authorization header.
    // If it doesn't exist, this header will simply be omitted.
    if (jwt != null) {
      String accessToken = jwt.toString();
      headers['Authorization'] = 'Bearer $accessToken';
    }

    // Now, make the API call for EVERYONE, with or without the token.
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      try {
        final data = json.decode(utf8.decode(response.bodyBytes)); // Handles Korean characters correctly
        return data;
      } catch (e) {
        print("Error decoding JSON: $e");
        return null; // Return null if JSON is malformed
      }
    } else {
      // For guest users, the backend might return a 401 or 403 error.
      // We should not throw an exception, but instead return null so the UI can handle it.
      print('Failed to fetch data for route: $route, status code: ${response.statusCode}');
      return null;
    }
  }


  Future<dynamic> basicDelete(String route) async {
    final url = '$BASE_URL$route'; // 데이터를 가져올 서버의 URL
    // TODO jwt 갱신하거나 로그아웃 하는 방안
    int? jwt = await getJWT();
    if (jwt == null) {
      return;
    }
    String accessToken = jwt.toString();

    final response =
        await http.delete(Uri.parse(url), headers: <String, String>{
      'Authorization': 'Bearer $accessToken', // Bearer 토큰 추가
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch');
    }
  }

  Future<dynamic> basicPost(String route, dynamic body) async {
    final url = '$BASE_URL$route'; // 데이터를 가져올 서버의 URL
    // TODO jwt 갱신하거나 로그아웃 하는 방안
    int? jwt = await getJWT();
    if (jwt == null) {
      return;
    }
    String accessToken = jwt.toString();
    try{
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Authorization': 'Bearer $accessToken', // Bearer 토큰 추가
            "Content-Type": "application/json",
          },
          body: json.encode(body)  );
      print(json.encode(body));

      if (response.statusCode == 200) {
        try{
          print(json.encode(response));
          final data = json.decode(response.body);
          print(json.encode(response.body));
          return data;
        }catch(error){
          return response.body;
        }

      } else {
        print(response.body);
        throw Exception('Failed to fetch');
      }
    }catch(error){
      print(error);
    }


  }

  Future<dynamic> basicPut(String route, dynamic body) async {
    final url = '$BASE_URL$route'; // 데이터를 가져올 서버의 URL
    // TODO jwt 갱신하거나 로그아웃 하는 방안
    int? jwt = await getJWT();
    if (jwt == null) {
      return;
    }
    String accessToken = jwt.toString();

    final response = await http.put(Uri.parse(url),
        headers: <String, String>{
          'Authorization': 'Bearer $accessToken', // Bearer 토큰 추가
          "Content-Type": "application/json",
        },
        body: json.encode(body) );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch');
    }
  }
}
