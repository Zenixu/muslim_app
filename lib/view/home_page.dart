import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Muslim App'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2, // 2 kolom
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
    );
  }

  // Widget reusable untuk item menu
  Widget _menuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Icon(
              icon,
              size: 48,
              color: Colors.green,
            ),

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
