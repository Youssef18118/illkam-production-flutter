import 'package:flutter/material.dart';

class TabUIController with ChangeNotifier {
  bool _visible = true;
  int _selectedIndex = 0;

  bool get visible => _visible;
  int get selectedIndex => _selectedIndex;

  void setVisibility(bool visible) {
    _visible = visible;
    notifyListeners();
  }

  void setSelectedIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}