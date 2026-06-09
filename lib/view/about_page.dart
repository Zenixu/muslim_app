import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text("Tentang Aplikasi"),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== HEADER =====
            Container(
              padding: const EdgeInsets.all(32),
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
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F766E).withOpacity(0.1),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0F766E).withOpacity(0.2),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.mosque_rounded,
                      size: 64,
                      color: Color(0xFF0F766E),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Muslim App",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF102A26),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Versi 1.0.0",
                    style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ===== DESKRIPSI =====
            const Text(
              "Deskripsi Aplikasi",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF102A26),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "Aplikasi Muslim adalah aplikasi berbasis Flutter yang menyediakan informasi jadwal shalat, Al-Qur'an digital, dan kumpulan doa harian untuk membantu umat muslim dalam menjalankan ibadah sehari-hari.",
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Color(0xFF102A26).withOpacity(0.8),
              ),
              textAlign: TextAlign.justify,
            ),

            const SizedBox(height: 32),

            // ===== FITUR =====
            const Text(
              "Fitur Utama",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF102A26),
              ),
            ),
            const SizedBox(height: 20),

            const FeatureItem(icon: Icons.access_time, text: "Jadwal Shalat"),
            const FeatureItem(icon: Icons.menu_book, text: "Al-Qur'an Digital"),
            const FeatureItem(icon: Icons.favorite, text: "Doa Harian"),
            const FeatureItem(icon: Icons.explore, text: "Arah Kiblat"),

            const SizedBox(height: 32),

            // ===== FOOTER =====
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF0F766E).withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text(
                  "Dibuat untuk Tugas Project 1\nAplikasi Muslim",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: const Color(0xFF0F766E), size: 24),
              ),
              const SizedBox(width: 16),
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF102A26),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
