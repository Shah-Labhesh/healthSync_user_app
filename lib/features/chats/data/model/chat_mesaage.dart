
class ChatMessage {
  final String? text;
  final String time;
  final bool isMe;
  final bool isImage;
  final String? image;

  const ChatMessage({
    this.text,
    required this.time,
    required this.isMe,
    required this.isImage,
    this.image,
  });
}

class ChatMessageModelData {
  static List<ChatMessage> chatMessages = const [
    ChatMessage(
      text: 'Hello',
      time: '10:00 AM',
      isMe: false,
      isImage: false,
    ),
    ChatMessage(
      text: 'Hi',
      time: '10:00 AM',
      isMe: true,
      isImage: false,
    ),
    ChatMessage(
      text: 'How are you?',
      time: '10:00 AM',
      isMe: false,
      isImage: false,
    ),
    ChatMessage(
      text: 'I am fine',
      time: '10:00 AM',
      isMe: true,
      isImage: false,
    ),
    ChatMessage(
      text: 'How are you?',
      time: '10:00 AM',
      isMe: false,
      isImage: false,
    ),
    ChatMessage(
      text: 'I am fine',
      time: '10:00 AM',
      isMe: true,
      isImage: false,
    ),
    ChatMessage(
      text: 'How are you?',
      time: '10:00 AM',
      isMe: false,
      isImage: false,
    ),
    ChatMessage(
      text: 'I am fine',
      time: '10:00 AM',
      isMe: true,
      isImage: false,
    ),
    ChatMessage(
      text: 'How are you?',
      time: '10:00 AM',
      isMe: false,
      isImage: false,
    ),
    ChatMessage(
      text: 'I am fine',
      time: '10:00 AM',
      isMe: true,
      isImage: false,
    ),
    ChatMessage(
      text: 'How are you?',
      time: '10:00 AM',
      isMe: false,
      isImage: false,
    ),
    ChatMessage(
      text: 'I am fine',
      time: '10:00 AM',
      isMe: true,
      isImage: false,
    ),
    ChatMessage(
      text: 'How are you?',
      time: '10:00 AM',
      isMe: false,
      isImage: false,
    ),
    ChatMessage(
      text: 'I am fine',
      time: '10:00 AM',
      isMe: true,
      isImage: false,
    ),
    ChatMessage(
      text: 'How are you?',
      time: '10:00 AM',
      isMe: false,
      isImage: false,
    )
  ];
}
