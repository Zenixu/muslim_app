class ShalatScheduleResponse {
  final bool status;
  final String message;
  final ScheduleData data;

  ShalatScheduleResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ShalatScheduleResponse.fromJson(Map<String, dynamic> json) {
    return ShalatScheduleResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ScheduleData.fromJson(json['data']),
    );
  }
}

class ScheduleData {
  final String id;
  final String lokasi;
  final String daerah;
  final Map<String, Jadwal> jadwal;

  ScheduleData({
    required this.id,
    required this.lokasi,
    required this.daerah,
    required this.jadwal,
  });

  factory ScheduleData.fromJson(Map<String, dynamic> json) {
    Map<String, Jadwal> jadwalMap = {};
    if (json['jadwal'] != null) {
      json['jadwal'].forEach((key, value) {
        jadwalMap[key] = Jadwal.fromJson(value);
      });
    }

    return ScheduleData(
      id: json['id'] ?? '',
      lokasi: json['kabko'] ?? '',
      daerah: json['prov'] ?? '',
      jadwal: jadwalMap,
    );
  }
}

class Jadwal {
  final String tanggal;
  final String imsak;
  final String subuh;
  final String terbit;
  final String dhuha;
  final String dzuhur;
  final String ashar;
  final String maghrib;
  final String isya;

  Jadwal({
    required this.tanggal,
    required this.imsak,
    required this.subuh,
    required this.terbit,
    required this.dhuha,
    required this.dzuhur,
    required this.ashar,
    required this.maghrib,
    required this.isya,
  });

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      tanggal: json['tanggal'] ?? '',
      imsak: json['imsak'] ?? '',
      subuh: json['subuh'] ?? '',
      terbit: json['terbit'] ?? '',
      dhuha: json['dhuha'] ?? '',
      dzuhur: json['dzuhur'] ?? '',
      ashar: json['ashar'] ?? '',
      maghrib: json['maghrib'] ?? '',
      isya: json['isya'] ?? '',
    );
  }
}
