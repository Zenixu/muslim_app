import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart';

class QiblaViewModel extends ChangeNotifier {
  double? qiblaDirection;   // arah kiblat (derajat)
  double? deviceDirection;  // arah perangkat (kompas)
  bool isDesktop = false;
  String status = "Memuat arah kiblat...";

  /// INIT
  Future<void> initQibla() async {
    try {
      // ================= MOBILE =================
      if (Platform.isAndroid || Platform.isIOS) {
        await Geolocator.requestPermission();

        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        _calculateQibla(position.latitude, position.longitude);

        FlutterCompass.events?.listen((event) {
          deviceDirection = event.heading;
          notifyListeners();
        });

        status = "Arah kiblat berdasarkan lokasi Anda";
      }

      // ================= DESKTOP =================
      else {
        isDesktop = true;

        // Lokasi default: Jakarta
        _calculateQibla(-6.2088, 106.8456);

        // PENTING: agar tidak loading selamanya
        deviceDirection = 0;

        status = "Mode Desktop (tanpa sensor)";
      }

      notifyListeners();
    } catch (e) {
      status = "Gagal memuat arah kiblat";
      notifyListeners();
    }
  }

  /// HITUNG KIBLAT
  void _calculateQibla(double lat, double lon) {
    const kaabaLat = 21.4225;
    const kaabaLon = 39.8262;

    final latRad = _degToRad(lat);
    final lonRad = _degToRad(lon);
    final kaabaLatRad = _degToRad(kaabaLat);
    final kaabaLonRad = _degToRad(kaabaLon);

    final y = sin(kaabaLonRad - lonRad);
    final x = cos(latRad) * tan(kaabaLatRad) -
        sin(latRad) * cos(kaabaLonRad - lonRad);

    qiblaDirection = (_radToDeg(atan2(y, x)) + 360) % 360;
  }

  double _degToRad(double deg) => deg * pi / 180;
  double _radToDeg(double rad) => rad * 180 / pi;
}
