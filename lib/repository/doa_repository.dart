import 'package:http/http.dart' as http;
import '../model/doa_response.dart';

class DoaRepository {
  // Fungsi untuk mengambil data doa dari API
  Future<List<Doa>> getDaftarDoa() async {
    final response = await http.get(Uri.parse('https://doa-doa-api-ahmadramadhan.fly.dev/api'));
    if (response.statusCode == 200) {
      return doaFromJson(response.body); // Gunakan helper yang ada di model
    } else {
      throw Exception('Gagal mengambil doa');
    }
  }
}