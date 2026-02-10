class ShalatScheduleResponse {
    final bool status;
    final ScheduleData data;

    ShalatScheduleResponse({required this.status, required this.data});

    factory ShalatScheduleResponse.fromJson(Map<String, dynamic> json) => ShalatScheduleResponse(
        status: json["status"],
        data: ScheduleData.fromJson(json["data"]),
    );
}

class ScheduleData {
    final String lokasi;
    final String daerah;
    final List<Jadwal> jadwal; // DIUBAH: Menjadi List karena API memberikan data satu bulan

    ScheduleData({required this.lokasi, required this.daerah, required this.jadwal});

    factory ScheduleData.fromJson(Map<String, dynamic> json) => ScheduleData(
        lokasi: json["lokasi"],
        daerah: json["daerah"],
        // Mengubah List JSON menjadi List Objek Jadwal
        jadwal: List<Jadwal>.from(json["jadwal"].map((x) => Jadwal.fromJson(x))),
    );
}

class Jadwal {
    final String tanggal;
    final String imsak;
    final String subuh;
    final String dzuhur;
    final String ashar;
    final String maghrib;
    final String isya;

    Jadwal({required this.tanggal, required this.imsak, required this.subuh, required this.dzuhur, required this.ashar, required this.maghrib, required this.isya});

    factory Jadwal.fromJson(Map<String, dynamic> json) => Jadwal(
        tanggal: json["tanggal"],
        imsak: json["imsak"],
        subuh: json["subuh"],
        dzuhur: json["dzuhur"],
        ashar: json["ashar"],
        maghrib: json["maghrib"],
        isya: json["isya"],
    );
}