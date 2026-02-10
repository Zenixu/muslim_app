import 'package:flutter/material.dart';
import '../model/quran_response.dart'; // Import model Surat
import '../repository/quran_repository.dart'; // Import repository Quran

class QuranViewModel extends ChangeNotifier {
  final QuranRepository repo; // Tempat menyimpan referensi repository
  QuranViewModel(this.repo); // Constructor untuk mengambil repository dari Provider

  bool isLoading = false; // Status untuk menunjukkan apakah data sedang dimuat
  String? error; // Menyimpan pesan error jika terjadi kegagalan
  List<Surat> daftarSurat = []; // Menyimpan list surat hasil dari API

  // Fungsi utama untuk mengambil data surat
  Future<void> fetchDaftarSurat() async {
    isLoading = true; // Set loading ke true agar UI menampilkan spinner
    error = null; // Reset error sebelum memulai request baru
    notifyListeners(); // Beritahu UI bahwa status berubah (mulai loading)

    try {
      daftarSurat = await repo.getDaftarSurat(); // Memanggil data dari internet lewat repository
    } catch (e) {
      error = e.toString(); // Jika gagal, simpan pesan errornya
    } finally {
      isLoading = false; // Proses selesai, matikan loading
      notifyListeners(); // Beritahu UI untuk menampilkan data atau pesan error
    }
  }
}