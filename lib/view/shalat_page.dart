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

    // Ambil data saat halaman dibuka
    Future.microtask(() {
      context.read<ShalatViewModel>().fetchSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShalatViewModel>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Jadwal Shalat"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(ShalatViewModel vm) {

    // ===== LOADING =====
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // ===== ERROR =====
    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }

    // ===== DATA KOSONG =====
    if (vm.scheduleResponse == null) {
      return const Center(child: Text("Data tidak tersedia"));
    }

    final data = vm.scheduleResponse!.data;

    // Ambil tanggal hari ini
    final now = DateTime.now();
    final todayFormatted =
        '${now.day.toString().padLeft(2, '0')}/'
        '${now.month.toString().padLeft(2, '0')}/'
        '${now.year}';

    // Ambil jadwal hari ini
    final todaySchedule = data.jadwal.firstWhere(
      (e) => e.tanggal.contains(todayFormatted),
      orElse: () => data.jadwal.first,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [

          // ===== HEADER LOKASI =====
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(Icons.location_on, color: Colors.green),
                  const SizedBox(height: 8),
                  Text(
                    data.lokasi,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(data.daerah),
                  const Divider(),
                  Text(
                    todaySchedule.tanggal,
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          _timeCard("Imsak", todaySchedule.imsak, Icons.wb_twilight),
          _timeCard("Subuh", todaySchedule.subuh, Icons.brightness_3),
          _timeCard("Dzuhur", todaySchedule.dzuhur, Icons.wb_sunny),
          _timeCard("Ashar", todaySchedule.ashar, Icons.wb_sunny_outlined),
          _timeCard("Maghrib", todaySchedule.maghrib, Icons.nights_stay),
          _timeCard("Isya", todaySchedule.isya, Icons.dark_mode),
        ],
      ),
    );
  }

  // ===== WIDGET WAKTU SHALAT =====
  Widget _timeCard(String label, String time, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Row(
            children: [
              Icon(icon, color: Colors.green),
              const SizedBox(width: 14),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
