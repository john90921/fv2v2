import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fv2/api/ApiHelper.dart';
import 'package:fv2/models/User.dart';
import 'package:fv2/token/TokenManager.dart';
import 'package:loader_overlay/loader_overlay.dart';

class Userprovider extends ChangeNotifier {
  User _loginUser = User.initial();
  bool _disposed = false;

void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  void setUser(User user) async {
    _loginUser = user;
  }

  User get getUser => _loginUser;

  parseUser(Map<String, dynamic> data) {
    return User.fromMap(data);
  }
  setUserInfo() async{
    try {
  ApiResult result = await Apihelper.get(
      ApiRequest(path: "/getLoginUserInfo"));
    if (result.status == true) {
      Map<String, dynamic> user = result.data as Map<String, dynamic>;
      setUser(parseUser(user));
      notifyListeners();
    }
    else{
      print("setUserInfo failed: ${result.message}");
    }
} on Exception catch (e) {
  // TODO
  print("setUserInfo error: $e");
}

  }

  void login(Map<String, dynamic> data){
    setUser(parseUser(data));
  }

  Future<bool> logout(BuildContext context) async {  
    ApiResult result = await Apihelper.post(ApiRequest(path: "/logout"));
    if (result.status != true) {
      return false;
    }

    await TokenManager.instance.clearAccessToken();
    _loginUser = User.initial();
    return true;
  }

  Future<String?> editProfile(
   {required String name,
    required String description, 
    required bool isRemoveImage,
    required bool HaveUploadedImage,
    required String? newImagePath,
    }
  ) async {
    print("editProfile called");
    try{
        FormData formData;

      formData = FormData.fromMap({
        // if new image selected or delered image before, then send image field
        'name': name,
        'description': description,
        '_method': 'PATCH',
        if (isRemoveImage == true && HaveUploadedImage == true)
          'remove_image': true,
        if (newImagePath != null)
          'profile_image': await MultipartFile.fromFile(
            newImagePath,
            filename: 'profile.jpg',
          ), //if new image selected
      });
        ApiResult result = await Apihelper.patch(
        ApiRequest(path: "/profile/${_loginUser.profile_id}", data: formData),
      );
    if (result.status == true) {
        print(result.data);
        Map<String, dynamic> data = result.data as Map<String, dynamic>;
        setUser(parseUser(data));
        notifyListeners();
        return "success edit profile";

    }
     else {
        print("error ${result.message}");
        return "error ${result.message}";
      }
  
  
  }
   on Exception catch (e) {
      // TODO
      print("error $e");
    }}

}
