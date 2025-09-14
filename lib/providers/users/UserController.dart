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
  void setUserId(int? user){
    if(user != null){
      _userId = user;
    }
  }

  Future<int?> initialize()async {
    int? jwt = await baseAPI.getJWT();
    print(jwt);
    if(jwt!= null){
      me = await  usersService.getUserData();
    }
    _userId = jwt ?? -1;
    isLogIn = jwt != null;
    notifyListeners();
    return jwt;
  }

  Future<void> signOut() async {
    _userId = -1;
    isLogIn = false;
    me = null;
    await baseAPI.clearAllSharedPref();
    notifyListeners();
  }
}
