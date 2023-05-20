import 'dart:convert';

import 'package:chatapp/data/remote/api_services/api_services.dart';
import 'package:chatapp/models/chat/chat_page_model.dart';
import 'package:chatapp/repositories/chat_repo/chat_repo_imp.dart';
import 'package:chatapp/utils/sharedPreferenced.dart';
import 'package:chatapp/utils/snackbar.dart';
import 'package:chatapp/views/chat_view/user_Chat_page.dart';
import 'package:chatapp/views/home/home_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:chatapp/models/chat/chat_model.dart';
import 'package:http/http.dart' as http;

// import 'package:web_socket_channel/io.dart';
// import 'package:web_socket_channel/status.dart' as status;

class UserChatVM extends GetxController {
  List<String> userChatMenuBtn = [
    "view contact",
    "Media, links, and docs",
    "Search",
    "Mute notifications",
    "Disappering messages",
    "Wallpaper",
    "More"
  ];
  List<MoreOption> moreOptionsToSend = [
    MoreOption(
        name: "Document",
        iconName: Icons.insert_drive_file,
        color: Colors.indigo),
    MoreOption(
        name: "Document",
        iconName: Icons.insert_drive_file,
        color: Colors.indigo),
    MoreOption(name: "Camera", iconName: Icons.camera_alt, color: Colors.pink),
    MoreOption(
        name: "Audio", iconName: Icons.headset_rounded, color: Colors.orange),
    MoreOption(
        name: "Payment", iconName: Icons.currency_rupee, color: Colors.teal),
    MoreOption(
        name: "Location", iconName: Icons.location_pin, color: Colors.green),
    MoreOption(name: "Contact", iconName: Icons.person, color: Colors.blue)
  ];
  List<MoreOption> moreOptionsToSendWeb = [
    MoreOption(name: "Contact", iconName: Icons.person, color: Colors.blue),
    MoreOption(
        name: "Document",
        iconName: Icons.insert_drive_file,
        color: Colors.indigo),
    MoreOption(
        name: "Camera", iconName: Icons.photo_camera, color: Colors.pink),
    MoreOption(
        name: "Sticker", iconName: Icons.memory, color: Colors.blue.shade600),
    MoreOption(
        name: "Photos & Video", iconName: Icons.photo, color: Colors.purple),
  ];

  List<MessageModel> messages = [];
  List<ChatData> selectedChatList = [];
  bool showBottomNavigation = false;

  bool showEnojiOption = false;
  String selectedChatId = "";
  int? selectedIndex;
  bool sendButton = false;
  bool loading = false;
  String frowardedText = "";
  final ScrollController scrollController = ScrollController();
  FocusNode focusNode = FocusNode();
  final TextEditingController txtController = TextEditingController();
  late io.Socket socket;
  String? senderUserId;

  @override
  void onInit() {
    super.onInit();
    initSocket();
    getUserChat();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showEnojiOption = false;
      }
      update();
    });
  }

  void initSocket() async {
    print("init socket");
    socket = io.io(baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false
    });
    senderUserId = await SharedPrefs.getString("userId");
    socket.connect();
    print("socket connection : $senderUserId");
    socket.emit("signin", senderUserId);

    socket.onConnect((data) {
      print("message : $data");
      socket.on("message", (msg) {
        print("message : $msg");
        Map<String, dynamic> res = msg;
        if (res["status"] == "success") {
          ChatData chat = ChatData.fromMap(res["data"]);
          var response = chatRepoImp.setIsSend(individualchats.id, chat.id);
          setMessage(res["data"]);
        }
      });
    });
    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    print("socket connection : ${socket.connected}");
  }

  void sendMessage({String? receiverUserId}) async {
    String meassge = txtController.text;
    individualchats.chats!.add(ChatData(
      message: meassge,
      createdAt: DateTime.now(),
      id: senderUserId!,
      isDeleted: false,
      isPinned: false,
      isRead: true,
      isReceived: false,
      isSent: false,
      messageType: "text",
      receiverUserId: receiverUserId ?? Get.arguments["receiverUserId"],
      recieveBy: "",
      sendBy: await SharedPrefs.getString("username") ?? "",
      senderUserId: senderUserId ?? "",
    ));
    updateUserLastMessageAtHome(individualchats.chats!.last);
    txtController.text;
    txtController.clear();

    socket.emit("message", {
      "message": meassge,
      "receiverUserId": receiverUserId ?? Get.arguments["receiverUserId"],
      "senderUserId": senderUserId,
    });
  }

  HomeVM homeVM = Get.put<HomeVM>(HomeVM());

  void updateUserLastMessageAtHome(ChatData chat) {
    homeVM.chatUsersList.forEach((element) {
      if (element.receiverId == chat.receiverUserId) {
        element.lastMessage = chat.message;
        element.lastMessageTime = chat.createdAt;
      }
    });
    homeVM.chatUsersList
        .sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    homeVM.update();
  }

  String time = DateFormat.jm().format(DateTime.now()).toString();
  void setMessage(Map<String, dynamic> map) {
    ChatData chat = ChatData.fromMap(map);
    print("chat : ${chat.message}");
    individualchats.chats!.add(chat);
    updateUserLastMessageAtHome(chat);
    update();
    scrollController.animateTo(scrollController.position.maxScrollExtent + 40,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    update();
  }

  ChatRepoImp chatRepoImp = ChatRepoImp();
  ChatModel individualchats = ChatModel(id: "", isBlocked: false, chats: []);

  void getUserChat() async {
    loading = true;
    String receiverUserId = Get.arguments["receiverUserId"];
    senderUserId = await SharedPrefs.getString("userId");
    update();
    ChatModel? chatModelList = await chatRepoImp.getUserChat(receiverUserId);
    // print("chat list : $chatModelList");
    // individualchats =
    //     ChatModel(id: senderUserId ?? '', isBlocked: false, chats: []);
    individualchats =
        chatModelList ?? ChatModel(id: senderUserId ?? '', isBlocked: false);
    loading = false;
    update();
  }

  bool functionalityLoding = false;
  bool multipleSelect = false;

  void deleteChat() async {
    functionalityLoding = true;
    List<String> idsForDelete = [];

    if (!multipleSelect) {
      idsForDelete.add(selectedChatId);
    } else {
      idsForDelete = selectedChatList.map((e) => e.id).toList();
      for (var chat in selectedChatList) {
        individualchats.chats!.removeWhere((element) => element.id == chat.id);
      }
    }
    update();
    print("ids for delete : $idsForDelete");
    Map<String, dynamic>? deleteMessage =
        await chatRepoImp.deleteChat(individualchats.id, idsForDelete);
    update();
    print("chat list : $deleteMessage");
    if (deleteMessage == {} || deleteMessage["status"] == "failed") {
      showSnackBar(Get.context!,
          deleteMessage["message"] ?? "Error in Deleting Message", true);
    }
    if (deleteMessage["status"] == "success") {
      showSnackBar(Get.context!, "Message Deleted", false);
      if (!multipleSelect) {
        individualchats.chats!
            .removeWhere((element) => idsForDelete.contains(element.id));
      } else {
        individualchats.chats!
            .removeWhere((element) => selectedChatList.contains(element));
      }
      selectedChatId = "";
      selectedChatList = [];
    }
    multipleSelect = false;
    // getUserChat();
    functionalityLoding = false;
    update();
  }

  void functionality(String chatId, String type, String trueFalse) async {
    Map body = {type: trueFalse};
    Map<String, dynamic>? deleteMessage =
        await chatRepoImp.functionality(individualchats.id, chatId, body);
    update();
    print("chat list : $deleteMessage");
    if (deleteMessage == {} || deleteMessage["status"] == "failed") {
      Get.snackbar("Message Deleted",
          deleteMessage["message"] ?? "Error in Deleting Message");
    }
    if (deleteMessage["status"] == "success") {
      Get.snackbar("Success", "Message Deleted");
    }
    getUserChat();
    update();
  }

  void forwardToAll(List<ChatUsers> forwardedTo) async {
    for (var element in forwardedTo) {
      sendMessageToUser(receiverId: element.receiverId);
    }
  }

  void sendMessageToUser({String? receiverId}) async {
    ChatData chatModel = ChatData(
      message: txtController.text,
      createdAt: DateTime.now(),
      id: senderUserId!,
      isDeleted: false,
      isPinned: false,
      isRead: true,
      isReceived: false,
      isSent: true,
      messageType: "text",
      receiverUserId: '',
      recieveBy: '',
      sendBy: '',
      senderUserId: '',
    );
    print("lllllllllllllll");
    print(individualchats.chats?.length);
    receiverId == null ? individualchats.chats!.add(chatModel) : null;
    update();
    String receiverUserId = receiverId ?? Get.arguments["receiverUserId"];
    String message = receiverId != null ? frowardedText : txtController.text;
    txtController.clear();
    print("message : $message");
    print("receiverUserId : $receiverUserId");

    socket.emit("message", {
      "senderId": senderUserId,
      "receiverId": receiverUserId,
      "message": message,
    });
    Map<String, dynamic> res =
        await chatRepoImp.sendMessageToUser(receiverUserId, message);
    print("res : $res");
    if (res.isNotEmpty && res != {}) {
      ChatData newChat = ChatData.fromJson(jsonEncode(res));
      individualchats.chats!.removeAt(individualchats.chats!.length - 1);
      individualchats.chats!.add(newChat);
      update();
    }
    if (res["status"] == "success") {
      Get.snackbar("success", "Message sent successfully");
    } else {
      Get.snackbar("error", "Message not sent");
    }
    receiverId = null;
    update();
  }

  String getDateTime(String datetime) {
    return DateFormat("h:mma").format(DateTime.parse(datetime));
  }

  @override
  void onClose() {
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }

  String convertDateTime(DateTime dateTime) {
    // print("ttttttttttttttt");
    // print("dateTime : $dateTime");
    dateTime = dateTime.toUtc().toLocal();
    String date = dateTime.toString().substring(8, 10);
    String month = dateTime.toString().substring(5, 7);
    String year = dateTime.toString().substring(2, 4);
    String time = dateTime.toString().substring(11, 16);
    // function to convert time in 12 hours format
    String hour = time.substring(0, 2);
    String min = time.substring(3, 5);
    String ampm = "AM";
    if (int.parse(hour) > 12) {
      hour = (int.parse(hour) - 12).toString();
      ampm = "PM";
    }
    return "$hour:$min $ampm";
  }
}
