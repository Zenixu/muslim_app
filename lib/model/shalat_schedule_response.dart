// ==========================================
// MODEL JADWAL SHALAT (API myQuran)
// File : shalat_schedule.dart
// ==========================================

// ==============================
// RESPONSE UTAMA DARI API
// ==============================
class ShalatScheduleResponse {
  // Status request dari API (true / false)
  final bool status;

  // Data utama: lokasi + jadwal
  final ScheduleData data;

  ShalatScheduleResponse({
    required this.status,
    required this.data,
  });

  // Factory untuk mengubah JSON ke Object
  factory ShalatScheduleResponse.fromJson(Map<String, dynamic> json) {
    return ShalatScheduleResponse(
      status: json['status'],
      data: ScheduleData.fromJson(json['data']),
    );
  }
}

// ==============================
// DATA LOKASI & JADWAL BULANAN
// ==============================
class ScheduleData {
  // Nama kota (contoh: Kota Bandung)
  final String lokasi;

  // Nama provinsi/daerah
  final String daerah;

  // Jadwal shalat SATU BULAN (list)
  final List<Jadwal> jadwal;

  ScheduleData({
    required this.lokasi,
    required this.daerah,
    required this.jadwal,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    return ScheduleData(
      lokasi: json['lokasi'],
      daerah: json['daerah'],
      jadwal: List<Jadwal>.from(
        json['jadwal'].map(
          (item) => Jadwal.fromJson(item),
        ),
      ),
    );
  }
}

// ==============================
// JADWAL SHALAT PER HARI
// ==============================
class Jadwal {
  // Format tanggal dari API (dd/MM/yyyy)
  final String tanggal;

  // Waktu imsak
  final String imsak;

  // Waktu subuh
  final String subuh;

  // Waktu dzuhur
  final String dzuhur;

  // Waktu ashar
  final String ashar;

  // Waktu maghrib
  final String maghrib;

  // Waktu isya
  final String isya;

  Jadwal({
    required this.tanggal,
    required this.imsak,
    required this.subuh,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      tanggal: json['tanggal'],
      imsak: json['imsak'],
      subuh: json['subuh'],
      dzuhur: json['dzuhur'],
      ashar: json['ashar'],
      maghrib: json['maghrib'],
      isya: json['isya'],
    );
  }
}
