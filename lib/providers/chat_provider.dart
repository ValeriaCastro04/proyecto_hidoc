import 'package:flutter/material.dart';
import '../services/socket_service.dart';

class ChatProvider extends ChangeNotifier {
  final SocketService _socketService = SocketService();
  final List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get messages => _messages;

  void connect(String userId) {
    _socketService.connect(userId: userId);

    _socketService.onMessage(userId, (data) {
      _messages.add({
        'from': data['senderId']?.toString() ?? '',
        'content': data['content'] ?? '',
      });
      notifyListeners();
    });
  }

  void sendMessage(String senderId, String receiverId, String text) {
    if (text.trim().isEmpty) return;

    _socketService.sendMessage(senderId, receiverId, text);
    _messages.add({'from': senderId, 'content': text});
    notifyListeners();
  }

  void disconnect() {
    _socketService.disconnect();
  }
}
