import 'dart:async';

import 'package:user_mobile_app/features/chats/data/model/chat_room.dart';
import 'package:user_mobile_app/features/chats/data/repo/chat_repo.dart';

class ChatRoomStream {
  final _chatRoomFetcher = StreamController<List<ChatRoom>>.broadcast();

  Stream<List<ChatRoom>> get chatRoom => _chatRoomFetcher.stream;

  Future<void> fetchChatRoom() async {
    try {
      final response = await ChatRepo().getChatRooms();
      if (response.statusCode == 200) {
        _chatRoomFetcher.sink.add((response.data as List<dynamic>)
            .map((e) => ChatRoom.fromMap(e as Map<String, dynamic>))
            .toList());
        fetchChatRoom();
      } else {
        _chatRoomFetcher.sink.addError(response.data['message']);
      }
    } catch (e) {
      _chatRoomFetcher.sink
          .addError('Something went wrong. Please try again later');
    }
  }

  void dispose() {
    _chatRoomFetcher.close();
  }
}
