import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../repository/shalat_repository.dart';
import '../model/shalat_schedule_response.dart';

class ShalatViewModel extends ChangeNotifier {
  final ShalatRepository repo;

  ShalatViewModel(this.repo);

  // ===== STATE =====
  bool isLoading = false;
  String? error;
  ShalatScheduleResponse? scheduleResponse;
  String? currentCityId;
  Position? currentPosition;

  // ===== FETCH JADWAL SHALAT =====
  Future<void> fetchSchedule({bool forceRefreshLocation = false}) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (currentCityId == null || forceRefreshLocation) {
        await _determinePosition();
        if (currentPosition != null) {
          currentCityId = await repo.getCityIdByCoordinates(
            currentPosition!.latitude,
            currentPosition!.longitude,
          );
        }
      }

      // Default to Jakarta if city ID still null (or use a default one)
      final cityId = currentCityId ?? 'fc221309746013ac554571fbd180e1c8'; // Default Bandung for now
      scheduleResponse = await repo.getTodaySchedule(cityId);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled.
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    currentPosition = await Geolocator.getCurrentPosition();
  }

  // Get current day's jadwal from the map
  Jadwal? get todayJadwal {
    if (scheduleResponse == null) return null;
    final now = DateTime.now();
    final dateKey =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return scheduleResponse!.data.jadwal[dateKey] ??
        scheduleResponse!.data.jadwal.values.first;
  }

  // ===== NEXT SHALAT LOGIC =====
  Map<String, dynamic>? get nextShalat {
    final jadwal = todayJadwal;
    if (jadwal == null) return null;

    final now = DateTime.now();
    final times = {
      'Subuh': jadwal.subuh,
      'Dzuhur': jadwal.dzuhur,
      'Ashar': jadwal.ashar,
      'Maghrib': jadwal.maghrib,
      'Isya': jadwal.isya,
    };

    for (var entry in times.entries) {
      final shalatTime = _parseTime(entry.value);
      if (shalatTime.isAfter(now)) {
        return {
          'name': entry.key,
          'time': entry.value,
          'remaining': shalatTime.difference(now),
        };
      }
    }

    // If all shalat for today have passed, return tomorrow's Subuh (simplified)
    return {
      'name': 'Subuh',
      'time': jadwal.subuh,
      'isTomorrow': true,
    };
  }

  DateTime _parseTime(String timeStr) {
    final now = DateTime.now();
    final parts = timeStr.split(':');
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(parts[0]),
      int.parse(parts[1]),
    );
  }
}
