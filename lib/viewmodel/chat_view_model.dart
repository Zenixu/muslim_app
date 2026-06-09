import 'package:flutter/material.dart';
import '../model/chat_message_model.dart';
import '../repository/chat_repository.dart';

class ChatViewModel extends ChangeNotifier {
  final ChatRepository _repository;

  ChatViewModel(this._repository);

  List<ChatMessage> messages = [];
  bool isLoading = false;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add(ChatMessage(message: text, isUser: true));
    isLoading = true;
    notifyListeners();

    final response = await _repository.sendMessage(text);

    messages.add(ChatMessage(message: response, isUser: false));
    isLoading = false;
    notifyListeners();
  }
}
