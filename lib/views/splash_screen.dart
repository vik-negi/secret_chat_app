import 'dart:async';

import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/routes.dart';
import 'package:chatapp/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

// i have chnaged somthing

class SplashScreen extends StatefulWidget {
  SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      // Get.offAllNamed(AppRotutes.home);
      Get.offAll(HomePage());
      // isUserAuthenticated();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          width: Get.width,
          height: Get.height,
          child: Image.asset(
            "assets/images/splashlogo.gif",
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
