import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/shalat_view_model.dart';
import '../viewmodel/chat_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final TextEditingController _chatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<ShalatViewModel>().fetchSchedule();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muslim App'),
        backgroundColor: const Color(0xFF0F766E),
        centerTitle: true,
        elevation: 0,
      ),
      body: _currentIndex == 0 ? _homeContent(context) : _emptyPage(),

      // ================= FLOATING CHAT =================
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF0F766E),
        onPressed: () => _openChat(context),
        child: const Icon(Icons.chat, color: Colors.white),
      ),

      // ================= BOTTOM NAV =================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF0F766E),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Awal'),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Jadwal',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Kiblat'),
        ],
      ),
    );
  }

  // ================= HOME CONTENT =================
  Widget _homeContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================= HEADER =================
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF0F766E).withOpacity(0.1),
                  const Color(0xFF14B8A6).withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Selamat Datang",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF102A26),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Mari kita mulai hari dengan ibadah",
                  style: TextStyle(
                    fontSize: 16,
                    color: const Color(0xFF102A26).withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ================= CARD JADWAL =================
          Consumer<ShalatViewModel>(
            builder: (context, vm, _) {
              if (vm.isLoading) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 32,
                          height: 32,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF0F766E),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Memuat jadwal shalat...',
                          style: TextStyle(
                            color: Color(0xFF102A26).withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (vm.error != null) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: Colors.red.shade400,
                          size: 32,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Gagal memuat jadwal",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final today = vm.todayJadwal;
              final nextPrayer = vm.nextShalat;

              if (today == null) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Data jadwal tidak tersedia',
                      style: TextStyle(
                        color: Color(0xFF102A26).withOpacity(0.7),
                      ),
                    ),
                  ),
                );
              }

              return Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F766E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.access_time,
                              color: Color(0xFF0F766E),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Jadwal Shalat",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF102A26),
                                  ),
                                ),
                                Text(
                                  vm.scheduleResponse?.data.lokasi ?? "Lokasi",
                                  style: TextStyle(
                                    color: Color(0xFF64748B),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F766E).withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Shalat Berikutnya",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF102A26),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      nextPrayer?['name'] ?? "Subuh",
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF102A26),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "Waktu shalat",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0F766E),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    nextPrayer?['time'] ?? "--:--",
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // ================= GRID MENU =================
          const Text(
            "Menu Utama",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF102A26),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
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
                label: 'Tentang',
                route: '/about',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emptyPage() => const SizedBox.shrink();

  // ================= NEXT PRAYER LOGIC =================
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
        return {'name': entry.key, 'time': entry.value};
      }
    }

    return {'name': 'Subuh', 'time': jadwal.subuh};
  }

  bool _isAfter(TimeOfDay now, TimeOfDay target) {
    return now.hour < target.hour ||
        (now.hour == target.hour && now.minute < target.minute);
  }

  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      borderRadius: BorderRadius.circular(20),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 32, color: const Color(0xFF0F766E)),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF102A26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= FLOATING CHAT OVERLAY =================
  void _openChat(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Consumer<ChatViewModel>(
          builder: (context, chatVM, _) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(top: 12, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F766E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.chat,
                              color: Color(0xFF0F766E),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            "Muslim Assistant",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF102A26),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 24),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: chatVM.messages.length,
                        itemBuilder: (context, index) {
                          final msg = chatVM.messages[index];

                          return Align(
                            alignment: msg.isUser
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              padding: const EdgeInsets.all(16),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width * 0.7,
                              ),
                              decoration: BoxDecoration(
                                color: msg.isUser
                                    ? const Color(0xFF0F766E)
                                    : const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                msg.message,
                                style: TextStyle(
                                  color: msg.isUser
                                      ? Colors.white
                                      : const Color(0xFF102A26),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    if (chatVM.isLoading)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Color(0xFF0F766E),
                              ),
                            ),
                          ),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _chatController,
                              decoration: InputDecoration(
                                hintText: "Tanya seputar Islam...",
                                hintStyle: TextStyle(
                                  color: const Color(0xFF64748B),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F766E),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white),
                              onPressed: () {
                                final text = _chatController.text;
                                if (text.isNotEmpty) {
                                  _chatController.clear();
                                  chatVM.sendMessage(text);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
