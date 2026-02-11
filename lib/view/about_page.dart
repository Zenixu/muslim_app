import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Judul Aplikasi
            const Center(
              child: Column(
                children: [
                  Icon(
                    Icons.mosque,
                    size: 80,
                    color: Colors.green,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Aplikasi Muslim",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Versi 1.0.0",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// Deskripsi Aplikasi
            const Text(
              "Deskripsi Aplikasi",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Aplikasi Muslim adalah aplikasi berbasis Flutter yang "
              "menyediakan informasi jadwal shalat, Al-Qur'an digital, "
              "dan kumpulan doa harian untuk membantu umat muslim "
              "dalam menjalankan ibadah sehari-hari.",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 20),

            /// Fitur Aplikasi
            const Text(
              "Fitur Utama",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const FeatureItem(
              icon: Icons.access_time,
              text: "Jadwal Shalat",
            ),
            const FeatureItem(
              icon: Icons.menu_book,
              text: "Al-Qur'an Digital",
            ),
            const FeatureItem(
              icon: Icons.favorite,
              text: "Doa Harian",
            ),
            const FeatureItem(
              icon: Icons.explore,
              text: "Arah Kiblat (Opsional)",
            ),

            const Spacer(),

            /// Footer
            const Center(
              child: Text(
                "Dibuat untuk Tugas Project 1\nAplikasi Muslim",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget kecil untuk item fitur
class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }
}
