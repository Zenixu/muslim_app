import 'package:flutter/material.dart';
import '../model/doa_response.dart';
import '../repository/doa_repository.dart';

class DoaViewModel extends ChangeNotifier {
  final DoaRepository repo;
  DoaViewModel(this.repo); // Injeksi repository melalui constructor

  bool isLoading = false;
  String? error;
  List<Doa> daftarDoa = [];

  Future<void> fetchDaftarDoa() async {
    isLoading = true; // Set loading true sebelum ambil data
    notifyListeners(); // Beritahu UI untuk update tampilan (muncul spinner)
    try {
      daftarDoa = await repo.getDaftarDoa();
      error = null;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false; // Loading selesai
      notifyListeners(); // Beritahu UI data sudah ada atau ada error
    }
  }
}