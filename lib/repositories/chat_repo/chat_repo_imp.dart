import 'dart:convert';

import 'package:chatapp/data/remote/api_services/chat_api_Services.dart';
import 'package:chatapp/models/chat/chat_model.dart';
import 'package:chatapp/models/chat/chat_page_model.dart';
import 'package:chatapp/models/user/user_model.dart';
import 'package:chatapp/repositories/chat_repo/chat_repo.dart';
import 'package:chatapp/utils/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChatRepoImp extends ChatRepo {
  ChatApiServices chatApiServices = ChatApiServices();
  @override
  Future<ChatModel>? getUserChat(String receiverUserId) async {
    Map<String, dynamic>? res =
        await chatApiServices.getUserChat(receiverUserId);
    ChatModel chatUsers;
    // debugPrint("common Repo Imp $res");
    if (res != null && res.isNotEmpty) {
      chatUsers = ChatModel.fromMap(res["data"]);

      return chatUsers;
    }
    return ChatModel(id: "", isBlocked: false);
  }

  @override
  Future<List<ChatUsers>> getAllChatUsers() async {
    Map<String, dynamic>? res = await chatApiServices.getAllChatUsers();
    List<ChatUsers> chatUsers = [];
    // debugPrint("getAllChatUsers response : $res");
    if (res != null && res.isNotEmpty) {
      for (var i in res["data"]) {
        chatUsers.add(ChatUsers.fromJson(jsonEncode(i)));
      }
      return chatUsers;
    }
    return [];
  }

  @override
  Future<List<UserData>> getSearchedUsers(String query) async {
    Map<String, dynamic>? res = await chatApiServices.getSearchedUsers(query);
    List<UserData> chatUsers = [];
    debugPrint("getSearchedUsers response : $res");
    if (res != null && res.isNotEmpty) {
      chatUsers =
          res["data"].map<UserData>((e) => UserData.fromMap(e)).toList();
      return chatUsers;
    }
    showSnackBar(Get.context!, res!["message"], false);
    return [];
  }

  @override
  Future<Map<String, dynamic>> sendMessageToUser(
      String receiverUserId, String message) async {
    Map<String, dynamic>? res =
        await chatApiServices.sendMessageToUser(receiverUserId, message);
    debugPrint("send message Repo Imp $res");
    if (res != null && res.isNotEmpty) {
      return res["data"];
    }
    return {};
  }

  @override
  Future<Map<String, dynamic>> deleteChat(
    String senderReceiverId,
    List<String> idsForDelete,
  ) async {
    Map<String, dynamic>? res =
        await chatApiServices.deleteChat(senderReceiverId, idsForDelete);
    debugPrint("chat detele Repo Imp $res");
    if (res != null && res.isNotEmpty) {
      return res;
    }
    return {};
  }

  @override
  Future<bool> setIsSend(String senderReceiverId, String chatId) async {
    Map<String, dynamic>? res =
        await chatApiServices.setIsSend(senderReceiverId, chatId);
    debugPrint("chat setIsSend Repo Imp $res");
    if (res != null && res["status"] == "success") {
      return true;
    }
    return false;
  }

  @override
  Future<Map<String, dynamic>> functionality(
      String senderReceiverId, String chatId, Map body) async {
    Map<String, dynamic>? res =
        await chatApiServices.functionality(senderReceiverId, chatId, body);
    debugPrint("chat functionality Repo Imp $res");
    if (res != null && res.isNotEmpty) {
      return res;
    }
    return {};
  }
}
