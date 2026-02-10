import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/shalat_view_model.dart';

class ShalatPage extends StatefulWidget {
  const ShalatPage({super.key});

  @override
  State<ShalatPage> createState() => _ShalatPageState();
}

class _ShalatPageState extends State<ShalatPage> {

  @override
  void initState() {
    super.initState();

    // Memanggil API saat halaman pertama kali dibuka
    Future.microtask(() {
      context.read<ShalatViewModel>().fetchSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShalatViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Jadwal Shalat Hari Ini"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(ShalatViewModel vm) {

    // ===== 1. LOADING =====
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ===== 2. ERROR =====
    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }

    // ===== 3. DATA KOSONG =====
    if (vm.scheduleResponse == null) {
      return const Center(child: Text("Data tidak tersedia"));
    }

    final dataLokasi = vm.scheduleResponse!.data;

    // Ambil tanggal hari ini
    final now = DateTime.now();

    // Format hari ini menjadi dd/MM/yyyy (contoh: 01/02/2026)
    final todayFormatted =
        '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';

    // Cari jadwal yang tanggalnya mengandung hari ini
    final jadwalHariIni = dataLokasi.jadwal.firstWhere(
      (jadwal) => jadwal.tanggal.contains(todayFormatted),
      orElse: () => dataLokasi.jadwal.first, // fallback aman
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          // ===== HEADER LOKASI =====
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.location_on, color: Colors.green),
                  const SizedBox(height: 8),
                  Text(
                    dataLokasi.lokasi,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(dataLokasi.daerah),
                  const Divider(),
                  Text(
                    jadwalHariIni.tanggal,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          _timeCard("Imsak", jadwalHariIni.imsak, Icons.wb_twilight),
          _timeCard("Subuh", jadwalHariIni.subuh, Icons.brightness_3),
          _timeCard("Dzuhur", jadwalHariIni.dzuhur, Icons.wb_sunny),
          _timeCard("Ashar", jadwalHariIni.ashar, Icons.wb_sunny_outlined),
          _timeCard("Maghrib", jadwalHariIni.maghrib, Icons.nights_stay),
          _timeCard("Isya", jadwalHariIni.isya, Icons.dark_mode),
        ],
      ),
    );
  }

  // ===== KOMPONEN WAKTU SHALAT =====
  Widget _timeCard(String label, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.green),
              const SizedBox(width: 15),
              Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
          Text(
            time,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
