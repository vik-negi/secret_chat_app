import 'package:chatapp/utils/sharedPreferenced.dart';

class UserFunctions {
  static Future<bool> isUserLoggedInFun() async {
    return (await SharedPrefs.getString("userId")) != null ? true : false;
  }
}
