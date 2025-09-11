import 'package:flutter/material.dart';

class TabUIController with ChangeNotifier {
  bool _visible = true;
  bool get visible => _visible;

  void setVisibility(bool visible) {
    _visible = visible;

    notifyListeners();
  }
}