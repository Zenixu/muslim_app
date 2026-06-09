import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GeminiServices {
  final String _apiKey = dotenv.env['GEMINI_API_KEY'] ?? "";

  Future<String> sendMessage(String message) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-3-flash-preview',
        apiKey: _apiKey,
        systemInstruction: Content.text(
          "Kamu adalah asisten aplikasi Muslim App. "
          "Jawab hanya seputar Agama Islam seperti jadwal shalat, Al-Quran, dan Doa. "
          "Jawab dengan bahasa Indonesia yang sopan dan jelas.",
        ),
      );

      final response = await model.generateContent(
        [Content.text(message)],
      );

      return response.text ?? "Tidak ada respon.";
    } catch (e) {
      return "Terjadi kesalahan: $e";
    }
  }
}
