import 'package:user_mobile_app/features/chats/data/model/chat_room.dart';

class ChatMessage {
  final String? id;
  final String? message;
  final String? senderId;
  final String? messageType;
  final String? createdAt;
  final String? deletedAt;
  final String? receiverId;
  final String? file;
  final bool? isMe;
  final ChatRoom? chatRoom;

  ChatMessage({
    this.id,
    this.message,
    this.senderId,
    this.messageType,
    this.createdAt,
    this.deletedAt,
    this.receiverId,
    this.file,
    this.isMe,
    this.chatRoom,
  });

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'] != null ? map['id'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      messageType:
          map['messageType'] != null ? map['messageType'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
      receiverId:
          map['receiverId'] != null ? map['receiverId'] as String : null,
      file: map['file'] != null ? map['file'] as String : null,
      chatRoom: map['chatRoom'] != null
          ? ChatRoom.fromMap(map['chatRoom'] as Map<String, dynamic>)
          : null,
      isMe: map['me'] != null ? map['me'] as bool : false,
    );
  }
}
