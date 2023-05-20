import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ChatModel {
  final String id;
  final List<ChatData>? chats;
  bool isBlocked;

  ChatModel({
    required this.id,
    required this.isBlocked,
    this.chats,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'chats': chats, 'isBlocked': isBlocked};
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
        id: map['_id'] as String,
        isBlocked: map['isBlocked'] as bool,
        chats: map["chat"] != null
            ? List<ChatData>.from(map["chat"].map((x) => ChatData.fromMap(x)))
            : []);
  }

  String toJson() => json.encode(toMap());

  factory ChatModel.fromJson(String source) =>
      ChatModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

class ChatData {
  final String id;
  final String message;
  final String sendBy;
  final String recieveBy;
  final String receiverUserId;
  final String senderUserId;
  final DateTime createdAt;
  final bool isSent;
  final bool isRead;
  final bool isDeleted;
  final bool isReceived;
  final String messageType;
  final bool isPinned;
  bool selected = false;
  ChatData({
    required this.message,
    required this.sendBy,
    required this.recieveBy,
    required this.receiverUserId,
    required this.senderUserId,
    required this.createdAt,
    required this.isSent,
    required this.isRead,
    required this.id,
    required this.isDeleted,
    required this.isReceived,
    required this.messageType,
    required this.isPinned,
    this.selected = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      '_id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isSent': isSent,
      'isRead': isRead,
      'isDeleted': isDeleted,
      'isReceived': isReceived,
      'messageType': messageType,
      'isPinned': isPinned,
      'sendBy': sendBy,
      'recieveBy': recieveBy,
      'receiverUserId': receiverUserId,
      'senderUserId': senderUserId,
    };
  }

  factory ChatData.fromMap(Map<String, dynamic> map) {
    return ChatData(
      message: map['message'] as String,
      id: map['_id'] as String,
      createdAt: DateTime.parse(map['timestamp']),
      isSent: map['isSent'] as bool,
      isRead: map['isRead'] as bool,
      isDeleted: map['isDeleted'] as bool,
      isReceived: map['isReceived'] as bool,
      messageType: map['messageType'] as String,
      isPinned: map['isPinned'] as bool,
      sendBy: map['sendBy'] as String,
      recieveBy: map['recieveBy'] as String,
      receiverUserId: map['receiverUserId'] as String,
      senderUserId: map['senderUserId'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ChatData.fromJson(String source) =>
      ChatData.fromMap(json.decode(source) as Map<String, dynamic>);
}
