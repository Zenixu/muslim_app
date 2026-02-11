import 'package:flutter/material.dart';
import '../repository/shalat_repository.dart';
import '../model/shalat_schedule_response.dart';

class ShalatViewModel extends ChangeNotifier {
  final ShalatRepository repo;

  ShalatViewModel(this.repo);

  // ===== STATE =====
  bool isLoading = false;
  String? error;

  // Menyimpan seluruh response dari API
  ShalatScheduleResponse? scheduleResponse;

  // ===== FETCH JADWAL SHALAT =====
  Future<void> fetchSchedule() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      scheduleResponse = await repo.getSchedule();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
