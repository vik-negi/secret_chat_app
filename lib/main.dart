import 'package:chatapp/appTheme.dart';
import 'package:chatapp/utils/constants.dart';
import 'package:chatapp/utils/routes.dart';
import 'package:chatapp/views/chat_view/chart_view_home.dart';
import 'package:chatapp/views/home/home.dart';
import 'package:chatapp/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // darkTheme: darkThemeData(context),
      theme: lightThemeData(context),
      scrollBehavior: const ScrollBehavior(
          androidOverscrollIndicator: AndroidOverscrollIndicator.stretch),
      // themeMode: ThemeMode.dark,
      // themeMode: ThemeMode.light,

      getPages: AppRotutes.pages,
      // initialRoute: AppRotutes.splashScreen,
      home: HomePage(),
    );
  }
}

class WebFilterWidget extends StatelessWidget {
  WebFilterWidget({super.key, required this.pageWidget, this.appBar});
  final Widget pageWidget;
  bool? appBar = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: (width > Constants.webWidth || !(appBar ?? false))
          ? AppBar(
              toolbarHeight: 0,
            )
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Text(
                "ShizuManu",
                style: TextStyle(
                    color: HexColor('#224957').withOpacity(0.7),
                    fontFamily: 'LexendDeca',
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
            ),
      body: RefreshIndicator(
        onRefresh: () {
          return Future(() => null);
        },
        child: Container(
          width: width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: Get.width < Constants.webWidth
                    ? width
                    : width - Constants.sizeBarWidth,
                child: Center(
                  child: SizedBox(
                    width: Get.width < Constants.mwidth ? width : 560,
                    child: Center(
                      child: pageWidget,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
