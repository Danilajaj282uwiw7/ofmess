import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models.dart';

class ChatScreen extends StatefulWidget {
  final int chatId;
  final String chatName;
  const ChatScreen({super.key, required this.chatId, required this.chatName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final List<Message> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final data = await ApiService.getMessages(widget.chatId);
    setState(() {
      _messages.clear();
      _messages.addAll(data.map((e) => Message.fromJson(e)));
      _isLoading = false;
    });
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    await ApiService.sendMessage(widget.chatId, text);
    _msgCtrl.clear();
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.chatName)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    reverse: true,
                    itemCount: _messages.length,
                    itemBuilder: (ctx, i) {
                      final msg = _messages[_messages.length - 1 - i];
                      final isMe = msg.senderId == int.tryParse(ApiService.token!.split(':')[0] ?? '0');
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blueAccent : Colors.grey[800],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!isMe)
                                Text(msg.displayName ?? msg.username ?? '',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text(msg.text),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(child: TextField(controller: _msgCtrl, decoration: const InputDecoration(hintText: 'Сообщение'))),
                      IconButton(onPressed: _send, icon: const Icon(Icons.send)),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
