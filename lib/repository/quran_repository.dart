import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/quran_response.dart';
import '../model/quran_detail_response.dart';

class QuranRepository {

  // Ambil daftar surat
  Future<List<Surat>> getDaftarSurat() async {
    final response =
        await http.get(Uri.parse('https://equran.id/api/v2/surat'));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => Surat.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil daftar surat');
    }
  }

  // Ambil DETAIL surat berdasarkan nomor
  Future<SuratDetail> getDetailSurat(int nomor) async {
    final response = await http.get(
      Uri.parse('https://equran.id/api/v2/surat/$nomor'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return SuratDetail.fromJson(data);
    } else {
      throw Exception('Gagal mengambil detail surat');
    }
  }
}
