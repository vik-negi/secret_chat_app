import 'package:chatapp/view_models/profile_viewmodels/profile_viewmodel.dart';
import 'package:chatapp/view_models/signin_signup_viewmodel.dart/signup_viewmodel.dart';
import 'package:get/get.dart';

class SignupBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(SignupVM());
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ProfileVM());
  }
}
