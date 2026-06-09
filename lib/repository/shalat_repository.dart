import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/shalat_schedule_response.dart';

class ShalatRepository {
  final String baseUrl = 'https://api.myquran.com/v3';

  // Get city ID by coordinates
  Future<String?> getCityIdByCoordinates(double lat, double lon) async {
    try {
      // Step 1: Reverse Geocode to get city name
      final geocodeUrl = Uri.parse('$baseUrl/tools/geocode');
      final geocodeResponse = await http.post(
        geocodeUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': '$lat, $lon'}),
      );

      if (geocodeResponse.statusCode == 200) {
        final geocodeData = json.decode(geocodeResponse.body);
        if (geocodeData['status'] == true) {
          final city = geocodeData['data']['address']['city'] ??
              geocodeData['data']['address']['county'] ??
              geocodeData['data']['address']['state_district'];

          if (city != null) {
            // Step 2: Search city ID by name in myquran
            final searchUrl = Uri.parse('$baseUrl/sholat/kota/find/$city');
            final searchResponse = await http.get(searchUrl);

            if (searchResponse.statusCode == 200) {
              final searchData = json.decode(searchResponse.body);
              if (searchData['status'] == true &&
                  searchData['data'] != null &&
                  (searchData['data'] as List).isNotEmpty) {
                return searchData['data'][0]['id'];
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error getting city ID: $e');
    }
    return null;
  }

  // Fetch schedule for today
  Future<ShalatScheduleResponse> getTodaySchedule(String cityId) async {
    final url = '$baseUrl/sholat/jadwal/$cityId/today';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return ShalatScheduleResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengambil jadwal shalat');
    }
  }

  // Fetch schedule for a specific date
  Future<ShalatScheduleResponse> getScheduleByDate(
      String cityId, DateTime date) async {
    final dateStr =
        '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    final url = '$baseUrl/sholat/jadwal/$cityId/$dateStr';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return ShalatScheduleResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Gagal mengambil jadwal shalat');
    }
  }
}
