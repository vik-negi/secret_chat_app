import 'package:chatapp/views/add_notes/add_notes.dart';
import 'package:chatapp/views/register/signup.dart';
import 'package:chatapp/views/chat_view/chart_view_home.dart';
import 'package:chatapp/views/home/home.dart';
import 'package:chatapp/views/search/search.dart';
import 'package:chatapp/views/register/signin.dart';
import 'package:chatapp/views/splash_screen.dart';
import 'package:get/get.dart';

class AppRotutes {
  static const home = '/';
  static const chat = '/chat';
  static const signin = '/signin';
  static const signup = '/signup';
  static const profile = '/profile';
  static const search = '/search';
  static const addNotes = '/addNotes';
  static const splashScreen = '/splashScreen';

  static final pages = [
    GetPage(name: AppRotutes.signin, page: () => SigninPage()),
    GetPage(name: AppRotutes.signup, page: () => const RegisterPage()),
    GetPage(name: AppRotutes.chat, page: () => ChatHomeView()),
    GetPage(name: AppRotutes.home, page: () => HomePage()),
    GetPage(name: AppRotutes.splashScreen, page: () => SplashScreen()),
    GetPage(name: AppRotutes.search, page: () => SearchPage()),
    GetPage(name: AppRotutes.addNotes, page: () => AddNotes()),
  ];
}
