import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/shalat_schedule_response.dart';

class ShalatRepository {

  // Fungsi mengambil jadwal shalat berdasarkan bulan & tahun saat ini
  Future<ShalatScheduleResponse> getSchedule() async {

    // Ambil tanggal sekarang dari sistem
    final now = DateTime.now();

    // Ambil tahun sekarang (contoh: 2026)
    final year = now.year;

    // Ambil bulan sekarang (1–12)
    // padLeft(2, '0') agar jadi 02, 03, dst
    final month = now.month.toString().padLeft(2, '0');

    // URL API jadwal shalat (ID kota = 1206)
    final url =
        'https://api.myquran.com/v2/sholat/jadwal/1206/$year/$month';

    // Request ke API
    final response = await http.get(Uri.parse(url));

    // Jika sukses
    if (response.statusCode == 200) {
      return ShalatScheduleResponse.fromJson(
        json.decode(response.body),
      );
    } else {
      throw Exception('Gagal mengambil jadwal shalat');
    }
  }
}
