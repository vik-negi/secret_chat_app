import 'package:chatapp/data/remote/api_responce.dart';
import 'package:chatapp/models/user/user_model.dart';
import 'package:chatapp/repositories/login_repo/login_repo_imp.dart';
import 'package:chatapp/utils/routes.dart';
import 'package:chatapp/utils/sharedPreferenced.dart';
import 'package:chatapp/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class SignupVM extends GetxController {
  ApiResponce<Map> response = ApiResponce.loading();
  final LoginRepoImp loginRepo = LoginRepoImp();

  UserModel userModel = Get.put(UserModel());
  bool isSignup = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  TextEditingController get nameController => _nameController;
  TextEditingController get usernameController => _usernameController;
  TextEditingController get emailController => _emailController;
  TextEditingController get mobileController => _mobileController;
  TextEditingController get passwordController => _passwordController;
  TextEditingController get confirmPasswordController =>
      _confirmPasswordController;

  bool rememberMeBool = false;
  bool showPasswordBool = true;
  List<double> coordinatesPoints = [];
  void showPassword() {
    showPasswordBool = !showPasswordBool;
    update();
  }

  bool isNextClicked = false;
  String selectedValue = "";

  Future<Map?> userSignup() async {
    await OneSignal.shared.setAppId("90dda10a-86d2-4f79-a30d-0620cff40d00");
    OSDeviceState? device = await OneSignal.shared.getDeviceState();
    print(device!.userId!);
    SharedPrefs.setString("notificationId", device.userId!);
    Map data = {
      'name': nameController.text,
      'email': emailController.text,
      'mobile': mobileController.text,
      'password': passwordController.text,
      'deviceNotificationId': device.userId!,
      "username": usernameController.text
    };
    Map<dynamic, dynamic>? response = await loginRepo.userSignup(data);

    if (response!["status"] == "success") {
      isSignup = true;
      update();
      showSnackBar(Get.context!, response["message"], false);
      Get.offAllNamed(AppRotutes.signin);
    }
    return null;
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
    mobileController.clear();
  }
}
