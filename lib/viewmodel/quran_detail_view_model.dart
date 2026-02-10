import 'package:flutter/material.dart';
import '../model/quran_detail_response.dart';
import '../repository/quran_repository.dart';

class QuranDetailViewModel extends ChangeNotifier {
  final QuranRepository repo;

  QuranDetailViewModel(this.repo);

  bool isLoading = false; // Status loading
  String? error; // Pesan error
  SuratDetail? surat; // Data surat detail

  // Ambil detail surat
  Future<void> fetchDetailSurat(int nomor) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      surat = await repo.getDetailSurat(nomor);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
  