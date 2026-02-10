
class Surat {
    final int nomor;
    final String nama;
    final String namaLatin;
    final int jumlahAyat;
    final String tempatTurun; // Ubah ke String agar lebih fleksibel dibanding Enum jika API berubah
    final String arti;

    Surat({required this.nomor, required this.nama, required this.namaLatin, required this.jumlahAyat, required this.tempatTurun, required this.arti});

    factory Surat.fromJson(Map<String, dynamic> json) => Surat(
        nomor: json["nomor"],
        nama: json["nama"],
        namaLatin: json["namaLatin"],
        jumlahAyat: json["jumlahAyat"],
        tempatTurun: json["tempatTurun"],
        arti: json["arti"],
    );
}