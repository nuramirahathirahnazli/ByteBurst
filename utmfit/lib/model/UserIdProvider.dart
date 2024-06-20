import 'package:flutter/material.dart';

class UserIdProvider with ChangeNotifier {
  String? _userEmail;

  String? get userEmail => _userEmail;

  void setUserEmail(String email) {
    _userEmail = email;
    notifyListeners();
  }
}



