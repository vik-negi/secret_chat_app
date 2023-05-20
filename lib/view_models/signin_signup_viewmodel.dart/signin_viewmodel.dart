import 'dart:convert';
import 'package:chatapp/data/remote/api_responce.dart';
import 'package:chatapp/models/user/user_model.dart';
import 'package:chatapp/repositories/login_repo/login_repo_imp.dart';
import 'package:chatapp/utils/routes.dart';
import 'package:chatapp/utils/sharedPreferenced.dart';
import 'package:chatapp/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SigninVM extends GetxController {
  ApiResponce<Map> response = ApiResponce.loading();
  SharedPrefs sharedPrefs = SharedPrefs();
  final LoginRepoImp loginRepo = LoginRepoImp();
  final storage = const FlutterSecureStorage();

  UserModel? userModel;
  bool isSigninClickedBool = false;
  // void isSigninClicked() {
  //   isSigninClickedBool = !isSigninClickedBool;
  //   update();
  // }

  bool rememberMeBool = false;
  bool showPasswordBool = true;
  void showPassword() {
    showPasswordBool = !showPasswordBool;
    update();
  }

  void rememberMe() {
    rememberMeBool = !rememberMeBool;
    update();
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  userSignin() async {
    isSigninClickedBool = true;
    debugPrint("Signin Clicked");
    update();

    Map data = {
      'email': usernameController.text.trim(),
      'password': passwordController.text
    };
    debugPrint(data.toString());
    Map<dynamic, dynamic>? response = await loginRepo.userSignin(data);
    debugPrint("ppppppppppppppppppppppp");
    debugPrint(response.toString());

    debugPrint((response == null).toString());
    if (response!["status"] == "success") {
      await SharedPrefs.setString("userData", jsonEncode(response["data"]));
      await SharedPrefs.setString("token", response["token"]);
      await SharedPrefs.setString("name", response["data"]["name"]);
      await SharedPrefs.setString(
          "profileImage", response["data"]["profileImage"]["url"]);
      await SharedPrefs.setString("email", response["data"]["email"]);
      await SharedPrefs.setString("username", response["data"]["username"]);

      await SharedPrefs.setBool("isLoggedIn", true);
      String userData = jsonEncode(response);
      // await sharedPrefs.setString("user_id", response["data"]["_id"]);
      await SharedPrefs.setString("userId", response["data"]["_id"]);
      print(response.toString());

      // userModel = userModelFromJson(userData);
      var userModel = UserModel.fromJson(userData);

      update();
      debugPrint(userModel.toString());
      Get.offAllNamed(AppRotutes.home);
    } else {
      showSnackBar(
          Get.context!, response['message'] ?? "Invalid credientails", true);
    }
    isSigninClickedBool = false;
    update();
  }
}
