import 'package:chatapp/utils/sharedPreferenced.dart';
import 'package:chatapp/utils/widgets/PopUpMenuBtn.dart';
import 'package:chatapp/views/chat_view/chart.dart';
import 'package:chatapp/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatHomeView extends StatelessWidget {
  ChatHomeView({super.key});

  final List<String> homePagePopUpMenu = [
    // "New group",
    // "Starred messages",
    "Setting",
    "logout"
  ];

  // int contrr = 1;
  final controller = ScrollController();

  HomeVM vm = Get.put(HomeVM());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeVM>(
      builder: (vm) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Chatapp"),
              actions: [
                IconButton(
                    onPressed: () {
                      Get.toNamed('/search');
                    },
                    icon: const Icon(Icons.search)),
                PopupMenuBtn(items: homePagePopUpMenu)
              ],
            ),
            body: const Chats());
        ;
      },
    );
  }
}
