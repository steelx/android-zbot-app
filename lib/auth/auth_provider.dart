import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zbot_app/auth/user_model.dart';
import 'package:zbot_app/resources/api_client.dart';

import 'http_exception.dart';
//https://github.com/Emmandez/ShopAppFlutter/blob/master/lib/providers/auth.dart
class Auth with ChangeNotifier {

  final _apiClient = BehaviorSubject<ApiClient>();

  Stream<ApiClient> get apiClient => _apiClient.stream;

  Auth.addApiClient(ApiClient apiClient) {
    _apiClient.add(apiClient);
  }

  String _token;
  DateTime _expiryDate;
  Timer _authTimer;
  User _user;

  User get user {
    return _user;
  }

  void setUser(User user) {
    _user = user;
    setPrefData(_token, _expiryDate, _user);
  }

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }

    return null;
  }

  // Login
  Future<Map<String, dynamic>> basicAuth(String username, String password) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$username:$password'));
    print(basicAuth);
    ApiClient client = await apiClient.first;
    client = client.withAdditionalHeaders({
      "authorization": basicAuth,
    });
    return await client.postWithoutBody("/auth");
  }

  Future<void> _authenticate(String username, String password) async {
    try {
      var responseData = await basicAuth(username, password);
      // var responseData = json.decode(response);
      if (responseData.containsKey("error") && responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      this._token = responseData['token'];
      ApiClient client = await apiClient.first;
      ApiClient authClient = client.withAdditionalHeaders({
        "Authorization": "Bearer $_token",
      });
      this._apiClient.add(authClient);
      responseData = await authClient.get("/me");
      // responseData = json.decode(response);

      this._user = User.fromJson(responseData);
      this._expiryDate = DateTime.now().add(Duration(hours: 24));

      _autoLogout();
      notifyListeners();

      await setPrefData(_token, _expiryDate, _user);

    } catch (error) {
      if (error == 401) {
        throw HttpException("INVALID_CREDENTIALS");
      }
      throw HttpException(error);
    }
  }

  Future<void> setPrefData(token, expiryDate, user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'expiryDate': expiryDate.toIso8601String(),
        'user': user.toJson(),
      });

      prefs.setString("userData", userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signup(String username, String email, String password) async {
    try {
      Map<String, dynamic> body = {
        "username": username, "email": email, "password": password
      };
      ApiClient client = await apiClient.first;
      await client.post("/signup", body);

      this._authenticate(username, password);

    } catch(error) {
      throw error;
    }
  }

  Future<void> signin(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<bool> tryAutoLogin() async {
    var client = await _apiClient.first;
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData')) return false;

    final extractedUserData = prefs.getString('userData');
    final userData = json.decode(extractedUserData) as Map<String, Object>;
    final userJson = userData['user'] as Map<String, Object>;
    final expiryDate = DateTime.parse(userData['expiryDate']);

    if(expiryDate.isBefore(DateTime.now())) return false;

    _token = userData['token'];
    _user = User.fromJson(userJson);
    _expiryDate = expiryDate;

    this._apiClient.add(client.withAdditionalHeaders({
      "Authorization": "Bearer $_token",
    }));

    notifyListeners();

    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }

    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    //prefs.remove('userData');
    prefs.clear();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
