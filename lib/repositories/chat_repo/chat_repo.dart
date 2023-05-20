import 'package:chatapp/models/chat/chat_model.dart';
import 'package:chatapp/models/chat/chat_page_model.dart';
import 'package:chatapp/models/user/user_model.dart';

abstract class ChatRepo {
  Future<ChatModel>? getUserChat(String receiverUserId);
  Future<Map<String, dynamic>>? sendMessageToUser(
      String receiverUserId, String message);
  Future<List<ChatUsers>> getAllChatUsers();
  Future<Map<String, dynamic>> deleteChat(
      String senderReceiverId, List<String> idsForDelete);
  Future<Map<String, dynamic>> functionality(
      String senderReceiverId, String chatId, Map body);
  Future<List<UserData>> getSearchedUsers(String query);
  Future<bool> setIsSend(String senderReceiverId, String chatId);
}
