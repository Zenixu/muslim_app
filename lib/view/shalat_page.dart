import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/shalat_view_model.dart';

class ShalatPage extends StatefulWidget {
  const ShalatPage({super.key});

  @override
  State<ShalatPage> createState() => _ShalatPageState();
}

class _ShalatPageState extends State<ShalatPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ShalatViewModel>().fetchSchedule();
    });
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ShalatViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(ShalatViewModel vm) {
    if (vm.isLoading && vm.scheduleResponse == null) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F766E)),
        ),
      );
    }

    if (vm.error != null && vm.scheduleResponse == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_off,
                  size: 64, color: Color(0xFF94A3B8)),
              const SizedBox(height: 24),
              Text(
                "Gagal Memuat Jadwal",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                vm.error ?? "Terjadi kesalahan tidak dikenal",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => vm.fetchSchedule(forceRefreshLocation: true),
                icon: const Icon(Icons.refresh),
                label: const Text("Coba Lagi"),
              ),
            ],
          ),
        ),
      );
    }

    final data = vm.scheduleResponse?.data;
    final today = vm.todayJadwal;
    final next = vm.nextShalat;

    if (data == null || today == null) {
      return const Center(child: Text("Data tidak tersedia"));
    }

    return RefreshIndicator(
      onRefresh: () => vm.fetchSchedule(forceRefreshLocation: true),
      color: const Color(0xFF0F766E),
      child: CustomScrollView(
        slivers: [
          // ===== ELEGANT HEADER =====
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            stretch: true,
            backgroundColor: const Color(0xFF0F766E),
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [StretchMode.zoomBackground],
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF0F766E), Color(0xFF134E4A)],
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative Pattern (Simplified)
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Opacity(
                        opacity: 0.1,
                        child: Icon(Icons.mosque_rounded, size: 250, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on,
                                  color: Colors.white70, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                data.lokasi,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            data.daerah,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            next?['name'] ?? "Next",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            next?['time'] ?? "--:--",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildCountdown(next),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ===== TIME LIST =====
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
              child: Column(
                children: [
                  _timeRow("Imsak", today.imsak, Icons.wb_twilight,
                      next?['name'] == 'Imsak'),
                  _timeRow("Subuh", today.subuh, Icons.brightness_3,
                      next?['name'] == 'Subuh'),
                  _timeRow("Terbit", today.terbit, Icons.wb_sunny,
                      next?['name'] == 'Terbit'),
                  _timeRow("Dzuhur", today.dzuhur, Icons.wb_sunny,
                      next?['name'] == 'Dzuhur'),
                  _timeRow("Ashar", today.ashar, Icons.wb_sunny_outlined,
                      next?['name'] == 'Ashar'),
                  _timeRow("Maghrib", today.maghrib, Icons.nights_stay,
                      next?['name'] == 'Maghrib'),
                  _timeRow("Isya", today.isya, Icons.dark_mode,
                      next?['name'] == 'Isya'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountdown(Map<String, dynamic>? next) {
    if (next == null || next['remaining'] == null) return const SizedBox();

    final duration = next['remaining'] as Duration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        "- ${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontFamily: 'monospace',
        ),
      ),
    );
  }

  Widget _timeRow(String label, String time, IconData icon, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF0F766E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.white.withOpacity(0.2)
                    : const Color(0xFF0F766E).withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xFF0F766E),
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            const Spacer(),
            Text(
              time,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: isActive ? Colors.white : const Color(0xFF0F766E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
