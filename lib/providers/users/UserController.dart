import 'package:flutter/material.dart';
import 'package:ilkkam/apis/base.dart';
import 'package:ilkkam/apis/usersAPI.dart';
import 'package:ilkkam/providers/works/Works.dart';

class UserController with ChangeNotifier {
  int _userId = -1;
  bool isLogIn = false;
  Users? me;

  UserController(bool fetchedLoginValue){
    isLogIn =  fetchedLoginValue;
  }

  int get id => _userId;
  bool get login => isLogIn;
  BaseAPI baseAPI = BaseAPI();
  UsersService usersService= UsersService();

  Users? applier;
  Users? employer;

  fetchApplier(int userid)async {
    applier =  await usersService.getApplierInfo(userid);
    notifyListeners();
  }
  fetchEmployer(int userid)async {
    employer =  await usersService.getEmployerInfo(userid);
    notifyListeners();
  }

  void setLogin(bool login) {
    isLogIn = login;

    notifyListeners();
  }
  // void setUserId(int? user){
  //   if(int != null){
  //     _userId = user!;
  //   }
  // }

  void setUserId(int? user){
    if (user != null) {
      _userId = user;
    }
  }

  // Future<int?> initialize()async {
  //   int? jwt = await baseAPI.getJWT();
  //   print(jwt);
  //   if(jwt!= null){
  //     me = await  usersService.getUserData();
  //   }
  //   _userId = jwt ?? -1;
  //   notifyListeners();
  //   return jwt;
  // }
  Future<int?> initialize()async {
    int? jwt = await baseAPI.getJWT();
    print(jwt);
    if (jwt != null) {
      // It's safer to also wrap this in a try-catch block in case of token expiration
      try {
        me = await usersService.getUserData();
      } catch (e) {
        print("Failed to get user data, token might be expired: $e");
        // Handle token expiration if needed, e.g., logout user
      }
    }
    _userId = jwt ?? -1;
    notifyListeners();
    return jwt;
  }
}