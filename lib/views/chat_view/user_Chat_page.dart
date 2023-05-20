import 'package:chatapp/utils/util_widgets_and_functions.dart';
import 'package:chatapp/utils/widgets/OtherSideMsg.dart';
import 'package:chatapp/utils/widgets/OwnMsgCard.dart';
import 'package:chatapp/utils/widgets/PopUpMenuBtn.dart';
import 'package:chatapp/utils/widgets/chat/bottomTextMessaging.dart';
import 'package:chatapp/utils/widgets/custom_user_chat.dart';
import 'package:chatapp/view_models/user_chat_viewmodal.dart';
import 'package:chatapp/views/Individual%20_user_details.dart';
import 'package:chatapp/views/chat_view/forward_message_view.dart';
import 'package:chatapp/views/home/home_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../utils/constants.dart';

class MoreOption {
  final String name;
  final IconData iconName;
  final Color color;

  MoreOption({required this.name, required this.iconName, required this.color});
}

class MessageModel {
  String type;
  String msg;
  String time;
  MessageModel({required this.msg, required this.type, required this.time});
}

class UserChatPage extends StatefulWidget {
  const UserChatPage({
    Key? key,
    required this.receiverId,
    required this.receiverName,
    required this.profileImage,
    this.isWeb,
  }) : super(key: key);
  final String receiverId;
  final String receiverName;
  final bool? isWeb;
  final String profileImage;

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  @override
  UserChatVM vm = Get.put(UserChatVM());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserChatVM>(builder: (vm) {
      return GestureDetector(
        onTap: () {
          if (vm.focusNode.hasFocus) {
            vm.focusNode.unfocus();
          }
          if (vm.showEnojiOption) {
            vm.showEnojiOption = false;
          }
          vm.showBottomNavigation = false;
          vm.update();
        },
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: Colors.white.withOpacity(0.9),
            ),
            Scaffold(
              // backgroundColor: Colors.transparent,
              appBar: AppBar(
                leadingWidth: 35,
                toolbarHeight: 55,
                titleSpacing: 0,
                elevation: 0,
                leading: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back,
                  ),
                ),
                title: InkWell(
                  onTap: () {
                    // Get.to(() => const IndividualUserDetails());
                  },
                  child: Row(
                    children: [
                      CircleAvatar(
                          radius: 20,
                          child: Image.network(widget.profileImage)),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.receiverName,
                            style: const TextStyle(
                              fontSize: 18.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Last seen today at ${vm.individualchats.chats!.isNotEmpty ? vm.convertDateTime(vm.individualchats.chats![vm.individualchats.chats!.length - 1].createdAt) : ""}",
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
                  vm.selectedChatList.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            vm.deleteChat();
                          },
                          icon: const Icon(Icons.delete))
                      : IconButton(
                          onPressed: () async {}, icon: const Icon(Icons.call)),
                  GetBuilder<UserChatVM>(builder: (vm) {
                    return PopupMenuBtn(items: vm.userChatMenuBtn);
                  })
                ],
              ),
              body: vm.loading
                  ? SizedBox(
                      height: Get.height,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: WillPopScope(
                        child: Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                controller: vm.scrollController,
                                // itemCount: messages.length,
                                itemCount: vm.individualchats.chats!.length + 1,

                                itemBuilder: (context, i) {
                                  if (i == vm.individualchats.chats!.length) {
                                    return Container(
                                      height: 20,
                                    );
                                  }
                                  if (vm.individualchats.chats![i]
                                          .receiverUserId !=
                                      vm.senderUserId) {
                                    return OwnMsgCard(
                                        chatId: vm.individualchats.chats![i].id,
                                        text: vm
                                            .individualchats.chats![i].message,
                                        index: i,
                                        time: vm.convertDateTime(vm
                                            .individualchats
                                            .chats![i]
                                            .createdAt));
                                  } else {
                                    // print(
                                    // "isit chala ${vm.individualchats.chats![i].id}, ${vm.senderUserId}");
                                    return OtherSideMsgCard(
                                        chatId: vm.individualchats.chats![i].id,
                                        text: vm
                                            .individualchats.chats![i].message,
                                        time: vm.convertDateTime(vm
                                            .individualchats
                                            .chats![i]
                                            .createdAt));
                                    // if (vm.messages[i].type == "source") {
                                    //   return OwnMsgCard(
                                    //       text: vm.messages[i].msg,
                                    //       time: vm.messages[i].time);
                                    // } else {
                                    //   return OtherSideMsgCard(
                                    //       text: vm.messages[i].msg,
                                    //       time: vm.messages[i].time);
                                  }
                                },
                              ),
                            ),
                            vm.showBottomNavigation
                                ? const SizedBox(
                                    height: 0,
                                  )
                                : BottomTextMessaging()
                          ],
                        ),
                        onWillPop: () {
                          if (vm.showEnojiOption == true) {
                            setState(() {
                              vm.showEnojiOption = false;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                          return Future.value(false);
                        },
                      ),
                    ),
              bottomNavigationBar: vm.showBottomNavigation
                  ? bottomNavigationMsgOption()
                  // Container(
                  //     height: 120,
                  //     width: Get.width,
                  //     child: Container(
                  //       height: 100,
                  //       width: Get.width * 0.8,
                  //       decoration: BoxDecoration(
                  //         color: Colors.white,
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //       child: Column(
                  //         children: [
                  //           const SizedBox(
                  //             height: 10,
                  //           ),
                  //           Center(
                  //               child: Container(
                  //             height: 5,
                  //             width: 50,
                  //             decoration: BoxDecoration(
                  //               color: Colors.grey.shade800,
                  //               borderRadius: BorderRadius.circular(10),
                  //             ),
                  //           )),
                  //           Row(
                  //             children: [
                  //               IconButton(
                  //                   onPressed: () {
                  //                     vm.deleteChat(vm.selectedChatId);
                  //                     Navigator.pop(context);
                  //                   },
                  //                   icon: const Icon(Icons.delete)),
                  //               IconButton(
                  //                   onPressed: () {
                  //                     Navigator.pop(context);
                  //                   },
                  //                   icon: const Icon(Icons.delete)),
                  //             ],
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   )
                  : Container(
                      height: 0,
                    ),
            ),
          ],
        ),
      );
    });
  }

  // Widget sendFiles(){
  //   return ;
  // }
}

class bottomNavigationMsgOption extends StatelessWidget {
  bottomNavigationMsgOption({
    Key? key,
  }) : super(key: key);

  UserChatVM vm = Get.find();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserChatVM>(builder: (vm) {
      return Container(
          height: 56 * 6.3,
          width: Get.width < Constants.mwidth ? Get.width : 500,
          alignment: Alignment.bottomCenter,
          margin: const EdgeInsets.only(bottom: 10),
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xff344955),
            ),
            width: Get.width < Constants.mwidth ? Get.width * 0.95 : 500,
            height: 56 * 6.3,
            child: ListView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                Container(
                  height: 20,
                ),
                ListTile(
                  title: const Text(
                    "Copy",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(
                    Icons.copy,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                          text: vm.individualchats.chats![vm.selectedIndex!]
                              .message),
                    );
                    vm.showBottomNavigation = false;
                    vm.update();
                    UtilWidgetsAndFunctions.appSnakBar(
                        message: "Copied to clipboard",
                        isError: false,
                        maxwidth: 220);
                  },
                ),
                ListTile(
                  title: const Text(
                    "React",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(
                    Icons.add_reaction,
                    color: Colors.white,
                  ),
                  onTap: () {},
                ),
                ListTile(
                  title: const Text(
                    "Forword",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(
                    CupertinoIcons.arrowshape_turn_up_right_fill,
                    color: Colors.white,
                  ),
                  onTap: () {
                    vm.showBottomNavigation = false;
                    vm.frowardedText =
                        vm.individualchats.chats![vm.selectedIndex!].message;
                    vm.update();
                    Get.to(() => const ForwardView());
                  },
                ),
                ListTile(
                  title: const Text(
                    "Starred",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: Icon(
                    vm.individualchats.chats![vm.selectedIndex!].isPinned
                        ? Icons.star
                        : Icons.star_border,
                    color: vm.individualchats.chats![vm.selectedIndex!].isPinned
                        ? Colors.yellow
                        : Colors.white,
                  ),
                  onTap: () {
                    vm.functionality(
                        vm.selectedChatId,
                        "isPinned",
                        vm.individualchats.chats![vm.selectedIndex!].isPinned
                            ? "false"
                            : "true");
                    vm.showBottomNavigation = false;
                    vm.update();
                  },
                ),
                ListTile(
                  title: const Text(
                    "Trash",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                  ),
                  onTap: () {
                    debugPrint("tapped on trash");
                    vm.deleteChat();
                    vm.showBottomNavigation = false;
                    vm.update();
                  },
                ),
                ListTile(
                  title: const Text(
                    "Spam",
                    style: TextStyle(color: Colors.white),
                  ),
                  leading: const Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                  onTap: () {},
                ),
              ],
            ),
          ));
    });
  }
}

class IconBtn extends StatelessWidget {
  const IconBtn({
    Key? key,
    this.iconColor,
    this.iconSize,
    required this.icon,
    this.iconOnPress,
  }) : super(key: key);

  // final List<MoreOption> moreOptionsToSend;
  final IconData icon;
  final Color? iconColor;
  final double? iconSize;
  final void Function()? iconOnPress;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: iconOnPress ?? () {},
        icon: Icon(
          icon,
          color: iconColor ?? Colors.grey,
          size: iconSize ?? 24,
        ));
  }
}
