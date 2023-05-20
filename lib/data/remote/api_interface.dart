abstract class LoginApiInterface {
  Future<Map<String, dynamic>?> userSignin(Map data);
  Future<Map<String, dynamic>?> userSignup(Map data);
}

abstract class CommoApiInterface {
  Future<Map<String, dynamic>?> otherUsersData(String userId);
  // Future<bool> addComment(String postId, String text);
}

abstract class ChatApiInterface {
  Future<Map<String, dynamic>>? getUserChat(String receiverUserId);
  Future<Map<String, dynamic>>? sendMessageToUser(
      String receiverUserId, String message);
  Future<Map<String, dynamic>>? getAllChatUsers();
  Future<Map<String, dynamic>>? deleteChat(
      String senderReceiverId, List<String> idsForDelete);
  Future<Map<String, dynamic>>? functionality(
      String senderReceiverId, String chatId, Map body);
  Future<Map<String, dynamic>>? getSearchedUsers(String query);
  Future<Map<String, dynamic>>? setIsSend(
      String senderReceiverId, String chatId);
}
