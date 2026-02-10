import 'dart:convert';

// Fungsi untuk merubah string JSON mentah menjadi List Objek Doa
List<Doa> doaFromJson(String str) => List<Doa>.from(json.decode(str).map((x) => Doa.fromJson(x)));

class Doa {
    final String id;
    final String doa;
    final String ayat;
    final String latin;
    final String artinya;

    Doa({required this.id, required this.doa, required this.ayat, required this.latin, required this.artinya});

    // Factory untuk memetakan Map dari JSON ke properti Class
    factory Doa.fromJson(Map<String, dynamic> json) => Doa(
        id: json["id"] ?? "", // Menggunakan ?? "" untuk menghindari error null
        doa: json["doa"] ?? "",
        ayat: json["ayat"] ?? "",
        latin: json["latin"] ?? "",
        artinya: json["artinya"] ?? "",
    );
}