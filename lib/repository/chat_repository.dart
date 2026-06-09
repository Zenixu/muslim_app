import '../services/gemini_services.dart';

class ChatRepository {
  final GeminiServices _service = GeminiServices();

  Future<String> sendMessage(String message) async {
    return await _service.sendMessage(message);
  }
}
