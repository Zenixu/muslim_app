import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ViewModel untuk halaman daftar surat
import '../viewmodel/quran_view_model.dart';

// Repository & ViewModel detail (untuk navigasi ke detail)
import '../repository/quran_repository.dart';
import '../viewmodel/quran_detail_view_model.dart';

// Halaman detail surat
import 'quran_detail_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage> {

  // Dipanggil SATU KALI saat halaman pertama kali dibuat
  @override
  void initState() {
    super.initState();

    // Future.microtask dipakai agar context aman digunakan
    // dan fetch data langsung saat halaman tampil
    Future.microtask(() {
      context.read<QuranViewModel>().fetchDaftarSurat();
    });
  }

  @override
  Widget build(BuildContext context) {

    // watch() → UI otomatis rebuild jika notifyListeners() dipanggil
    final vm = context.watch<QuranViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Al-Qur'an"),
        backgroundColor: Colors.green,
      ),

      body: _buildBody(vm),
    );
  }

  /// =============================
  /// BAGIAN BODY UTAMA
  /// =============================
  Widget _buildBody(QuranViewModel vm) {

    // 1️⃣ Saat loading
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // 2️⃣ Jika error
    if (vm.error != null) {
      return Center(
        child: Text(
          'Terjadi kesalahan:\n${vm.error}',
          textAlign: TextAlign.center,
        ),
      );
    }

    // 3️⃣ Jika data kosong
    if (vm.daftarSurat.isEmpty) {
      return const Center(
        child: Text('Data surat tidak ditemukan'),
      );
    }

    // 4️⃣ Jika data ada → tampilkan list surat
    return ListView.separated(
      itemCount: vm.daftarSurat.length,

      // Garis pemisah antar item
      separatorBuilder: (_, __) => const Divider(height: 1),

      itemBuilder: (context, index) {
        final surat = vm.daftarSurat[index];

        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),

          // Nomor surat
          leading: CircleAvatar(
            backgroundColor: Colors.green.shade100,
            child: Text(
              surat.nomor.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),

          // Nama Latin
          title: Text(
            surat.namaLatin,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),

          // Arti + jumlah ayat
          subtitle: Text(
            '${surat.arti} • ${surat.jumlahAyat} Ayat',
          ),

          // Nama Arab
          trailing: Text(
            surat.nama,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Arabic',
            ),
          ),

          // ⭐⭐⭐ INI KUNCI UTAMA KENAPA SEKARANG BISA DIKLIK ⭐⭐⭐
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ChangeNotifierProvider(
                  // ViewModel khusus untuk halaman detail
                  create: (c) =>
                      QuranDetailViewModel(c.read<QuranRepository>()),

                  // Kirim nomor surat ke halaman detail
                  child: QuranDetailPage(
                    nomor: surat.nomor,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
