abstract class LoginRepo {
  Future<Map<String, dynamic>>? userSignup(Map data);
  Future<Map<String, dynamic>?> userSignin(Map data);
  Future<Map>? updateUserLocation(Map updateLocation);
}
