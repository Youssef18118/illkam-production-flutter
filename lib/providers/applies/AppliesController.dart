import 'package:flutter/cupertino.dart';
import 'package:ilkkam/providers/applies/dto/Apply.dart';

class AppliesController extends ChangeNotifier {
  Apply? selectedApply;

  selectApply(Apply a){
    selectedApply = a;
    notifyListeners();
  }
}