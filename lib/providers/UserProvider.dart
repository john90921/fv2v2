import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/models/User.dart';
import 'package:fv2/token/TokenManager.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Userprovider extends ChangeNotifier {
  User? _loginUser;

  void setUser(User user) async {
    _loginUser = user;
  }

  parseUser(Map<String, dynamic> data) {
    return User.fromMap(data);
  }

  void login(Map<String, dynamic> data){
    setUser(parseUser(data));
    print("name: ${_loginUser?.name}");
    notifyListeners();
  }
  Future<bool> logout(BuildContext context) async {
    context.loaderOverlay.show();
    ApiResult result = await Apihelper.post(ApiRequest(path: "/logout"));
    context.loaderOverlay.hide();
    if (result.status != true) {
      return Future.value(false);
    }

    TokenManager.instance.clearAccessToken();
    _loginUser = null;
    notifyListeners();
    return Future.value(true);
  }
}
