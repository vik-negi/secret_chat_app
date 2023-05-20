import 'dart:convert';

import 'package:chatapp/data/remote/api_interface.dart';
import 'package:chatapp/data/remote/api_services/api_services.dart';
import 'package:chatapp/utils/sharedPreferenced.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getToken() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  return sharedPreferences.getString("token")!;
}

class CommonApiServices extends CommoApiInterface {
  ApiServices apiServices = ApiServices();

  @override
  Future<Map<String, dynamic>> otherUsersData(String userId) async {
    print("other user id : $userId");
    final response = await http.get(
      Uri.parse('$baseUrl/api/account/user-data/$userId'),
    );
    // print("other user response : ${response.body}");
    if (response.statusCode == 200) {
      Map<String, dynamic> body = apiServices.returnResponse(response);
      return body;
    }
    return {};
  }
}
