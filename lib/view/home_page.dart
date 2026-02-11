import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/shalat_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch jadwal shalat saat home dibuka
    Future.microtask(() {
      context.read<ShalatViewModel>().fetchSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muslim App'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: _currentIndex == 0 ? _homeContent(context) : _emptyPage(),

      // =============================
      // BOTTOM NAVBAR
      // =============================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/shalat');
            return;
          }
          if (index == 2) {
            Navigator.pushNamed(context, '/qibla');
            return;
          }
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Awal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Kiblat',
          ),
        ],
      ),
    );
  }

  // =============================
  // HOME CONTENT
  // =============================
  Widget _homeContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // =============================
          // CARD JADWAL SHALAT
          // =============================
          Consumer<ShalatViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }

              if (vm.error != null) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(vm.error!),
                  ),
                );
              }

              final jadwalList = vm.scheduleResponse?.data?.jadwal;

              if (jadwalList == null || jadwalList.isEmpty) {
                return const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Data jadwal tidak tersedia'),
                  ),
                );
              }

              // ✅ AMBIL JADWAL HARI INI
              final today = jadwalList.first;
              final nextPrayer = _getNextPrayer(today);

              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Jadwal Shalat",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Lokasi Anda",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Divider(height: 20),
                      const Text(
                        "Shalat Berikutnya",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            nextPrayer['name']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            nextPrayer['time']!,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 20),

          // =============================
          // GRID MENU
          // =============================
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _menuItem(
                  context,
                  icon: Icons.access_time,
                  label: 'Jadwal Shalat',
                  route: '/shalat',
                ),
                _menuItem(
                  context,
                  icon: Icons.menu_book,
                  label: 'Al-Qur\'an',
                  route: '/quran',
                ),
                _menuItem(
                  context,
                  icon: Icons.favorite,
                  label: 'Doa Harian',
                  route: '/doa',
                ),
                _menuItem(
                  context,
                  icon: Icons.info_outline,
                  label: 'Tentang Aplikasi',
                  route: '/about',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyPage() {
    return const SizedBox.shrink();
  }

  // =============================
  // LOGIC SHALAT BERIKUTNYA
  // =============================
  Map<String, String> _getNextPrayer(dynamic jadwal) {
    final now = TimeOfDay.now();

    final prayerTimes = {
      'Subuh': jadwal.subuh,
      'Dzuhur': jadwal.dzuhur,
      'Ashar': jadwal.ashar,
      'Maghrib': jadwal.maghrib,
      'Isya': jadwal.isya,
    };

    for (final entry in prayerTimes.entries) {
      final parts = entry.value.split(':');
      final prayerTime = TimeOfDay(
        hour: int.parse(parts[0]),
        minute: int.parse(parts[1]),
      );

      if (_isAfter(now, prayerTime)) {
        return {
          'name': entry.key,
          'time': entry.value,
        };
      }
    }

    // Jika semua sudah lewat → Subuh besok
    return {
      'name': 'Subuh',
      'time': jadwal.subuh,
    };
  }

  bool _isAfter(TimeOfDay now, TimeOfDay target) {
    return now.hour < target.hour ||
        (now.hour == target.hour && now.minute < target.minute);
  }

  // =============================
  // MENU ITEM
  // =============================
  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.green),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
