class Message {
  final int id;
  final int chatId;
  final int senderId;
  final String text;
  final String timestamp;
  final String? username;
  final String? displayName;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.text,
    required this.timestamp,
    this.username,
    this.displayName,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'],
      chatId: json['chat_id'],
      senderId: json['sender_id'],
      text: json['text'],
      timestamp: json['timestamp'],
      username: json['username'],
      displayName: json['display_name'],
    );
  }
}

class ChatPreview {
  final int id;
  final bool isGroup;
  final String? name;
  final String? displayName;
  final String? lastMsg;
  final String? lastTime;

  ChatPreview({
    required this.id,
    this.isGroup = false,
    this.name,
    this.displayName,
    this.lastMsg,
    this.lastTime,
  });

  factory ChatPreview.fromJson(Map<String, dynamic> json) {
    return ChatPreview(
      id: json['id'],
      isGroup: json['is_group'] == 1,
      name: json['name'],
      displayName: json['display_name'],
      lastMsg: json['last_msg'],
      lastTime: json['last_time'],
    );
  }
}
