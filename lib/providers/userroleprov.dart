import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserRoleProvider extends ChangeNotifier {
  bool isAdmin = false;

  void setRole(bool _isAdmin) {
    isAdmin = _isAdmin;
    notifyListeners();
  }
}
