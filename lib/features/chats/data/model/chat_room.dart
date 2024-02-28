

import 'package:user_mobile_app/features/account/data/model/user.dart';

class ChatRoom {
  String? id;
  String? lastMessage;
  String? senderId;
  String? deletedBy;
  String? lastMessageAt;
  String? messageType;
  String? createdAt;
  String? deletedAt;
  User? user;
  User? doctor;
  ChatRoom({
    this.id,
    this.lastMessage,
    this.senderId,
    this.deletedBy,
    this.lastMessageAt,
    this.messageType,
    this.createdAt,
    this.deletedAt,
    this.user,
    this.doctor,
  });

 

  


  factory ChatRoom.fromMap(Map<String, dynamic> map) {
    return ChatRoom(
      id: map['id'] != null ? map['id'] as String : null,
      lastMessage: map['lastMessage'] != null ? map['lastMessage'] as String : null,
      senderId: map['senderId'] != null ? map['senderId'] as String : null,
      deletedBy: map['deletedBy'] != null ? map['deletedBy'] as String : null,
      lastMessageAt: map['lastMessageAt'] != null ? map['lastMessageAt'] as String : null,
      messageType: map['messageType'] != null ? map['messageType'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
      user: map['user'] != null ? User.fromMap(map['user'] as Map<String,dynamic>) : null,
      doctor: map['doctor'] != null ? User.fromMap(map['doctor'] as Map<String,dynamic>) : null,
    );
  }

 

}
