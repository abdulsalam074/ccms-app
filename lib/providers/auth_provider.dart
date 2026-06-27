import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<String> register(
      String email,
      String password,
      String name) async {

    String result =
    await _authService.register(
        email,
        password,
        name);

    notifyListeners();

    return result;
  }

  Future<String> login(
      String email,
      String password) async {

    String result =
    await _authService.login(
        email,
        password);

    notifyListeners();

    return result;
  }

  Future<void> logout() async {
    await _authService.logout();

    notifyListeners();
  }
}
