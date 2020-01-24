import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:product_store_app/src/preferences/user_preferences.dart';

class UserProvider {
  final String _firebaseToken = 'AIzaSyDkaTsrAYTpSq8yhaUPww5YOSIjcXpp7EI';
  final _prefs = UserPreferences();

  Future<LoginResponse> login(String email, String pass) {
    String url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword';
    return _request(email, pass, url);
  }

  Future<LoginResponse> newUser(String email, String pass) {
    String url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp';
    return _request(email, pass, url);
  }

  Future<LoginResponse> _request(String email, String pass, String url) async {
    final outData = {
      'email': email,
      'password': pass,
      'returnSecureToken': true,
    };
    final resp = await http.post(
      '$url?key=$_firebaseToken',
      body: json.encode(outData),
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    // print(decodedResp);

    if (decodedResp.containsKey('idToken')) {
      _prefs.token = decodedResp['idToken'];
      return LoginResponse.ok(token: decodedResp['idToken']);
    } else {
      return LoginResponse.err(errMessage: decodedResp['error']['message']);
    }
  }
}

class LoginResponse {
  bool ok;
  String token;
  String errMessage;

  LoginResponse.ok({this.token}) {
    ok = true;
    errMessage = null;
  }

  LoginResponse.err({this.errMessage}) {
    this.ok = false;
    this.token = null;
  }
}
