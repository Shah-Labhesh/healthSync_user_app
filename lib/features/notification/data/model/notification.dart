// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

import 'package:user_mobile_app/features/account/data/model/user.dart';

class Notifications {
  String? id;
  String? title;
  String? body;
  String? notificationType;
  bool? isRead;
  // User? receiver;
  String? targetId;
  String? createdAt;
  String? deletedAt;

  Notifications({
    this.id,
    this.title,
    this.body,
    this.notificationType,
    this.isRead,
    // this.receiver,
    this.targetId,
    this.createdAt,
    this.deletedAt,
  });


  factory Notifications.fromMap(Map<String, dynamic> map) {
    return Notifications(
      id: map['id'] != null ? map['id'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      body: map['body'] != null ? map['body'] as String : null,
      notificationType: map['type'] != null ? map['type'] as String : null,
      isRead: map['read'] != null ? map['read'] as bool : null,
      // receiver: map['receiver'] != null ? User.fromMap(map['receiver'] as Map<String,dynamic>) : null,
      targetId: map['targetId'] != null ? map['targetId'] as String : null,
      createdAt: map['createdAt'] != null ? map['createdAt'] as String : null,
      deletedAt: map['deletedAt'] != null ? map['deletedAt'] as String : null,
    );
  }

}
