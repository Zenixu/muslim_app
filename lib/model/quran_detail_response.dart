// Model ini merepresentasikan DETAIL 1 surat Al-Qur'an
class SuratDetail {
  final int nomor; // Nomor surat
  final String nama; // Nama Arab
  final String namaLatin; // Nama Latin
  final List<Ayat> ayat; // List ayat dalam surat

  SuratDetail({
    required this.nomor,
    required this.nama,
    required this.namaLatin,
    required this.ayat,
  });

  // Factory untuk convert JSON → Object
  factory SuratDetail.fromJson(Map<String, dynamic> json) {
    return SuratDetail(
      nomor: json['nomor'],
      nama: json['nama'],
      namaLatin: json['namaLatin'],
      ayat: (json['ayat'] as List)
          .map((e) => Ayat.fromJson(e))
          .toList(),
    );
  }
}

// Model ayat
class Ayat {
  final int nomorAyat; // Nomor ayat
  final String arab; // Teks Arab
  final String latin; // Latin
  final String arti; // Terjemahan

  Ayat({
    required this.nomorAyat,
    required this.arab,
    required this.latin,
    required this.arti,
  });

  factory Ayat.fromJson(Map<String, dynamic> json) {
    return Ayat(
      nomorAyat: json['nomorAyat'],
      arab: json['teksArab'],
      latin: json['teksLatin'],
      arti: json['teksIndonesia'],
    );
  }
}
