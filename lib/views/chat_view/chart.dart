import 'package:chatapp/utils/widgets/custom_user_chat.dart';
import 'package:chatapp/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  final ScrollController controller = ScrollController();
  HomeVM vm = Get.find();
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeVM>(builder: (vm) {
      return RefreshIndicator(
        onRefresh: () async {
          vm.getAllChatUsers();
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          // controller: widget.controller,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: vm.chatUsersList.length,
          itemBuilder: (context, i) => Padding(
              padding: EdgeInsets.only(
                  top: 2,
                  bottom: i == vm.chatUsersList.length - 1
                      ? (vm.chatUsersList.length < 7
                          ? (7 - vm.chatUsersList.length) * 100
                          : 65.0)
                      : 2.0),
              child: CustomUser(
                userChatModel: vm.chatUsersList[i],
                index: i,
              )),
        ),
      );
    });
  }
}
