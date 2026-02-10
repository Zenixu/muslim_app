import 'package:flutter/material.dart';
import '../model/shalat_schedule_response.dart'; // Import model respons shalat
import '../repository/shalat_repository.dart'; // Import repository shalat

class ShalatViewModel extends ChangeNotifier {
  final ShalatRepository repo; // Referensi repository
  ShalatViewModel(this.repo); // Ambil repository lewat constructor

  bool isLoading = false; // Status loading
  String? error; // Status error
  ShalatScheduleResponse? scheduleResponse; // Menyimpan satu paket respons jadwal shalat

  // Fungsi untuk mengambil jadwal shalat
  Future<void> fetchSchedule() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      // Mengambil objek ShalatScheduleResponse secara utuh dari repo
      scheduleResponse = await repo.getSchedule(); 
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}