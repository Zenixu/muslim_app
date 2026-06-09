import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/quran_view_model.dart';
import '../repository/quran_repository.dart';
import '../viewmodel/quran_detail_view_model.dart';
import 'quran_detail_page.dart';
import 'quran_juz_page.dart';

class QuranPage extends StatefulWidget {
  const QuranPage({super.key});

  @override
  State<QuranPage> createState() => _QuranPageState();
}

class _QuranPageState extends State<QuranPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    Future.microtask(() {
      context.read<QuranViewModel>().fetchDaftarSurat();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text("Al-Qur'an"),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.7),
          indicator: const UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.white, width: 3),
            insets: EdgeInsets.symmetric(horizontal: 16),
          ),
          tabs: const [
            Tab(text: 'Semua Surat'),
            Tab(text: 'Menurut Juz'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildSurahList(vm), const QuranJuzPage()],
      ),
    );
  }

  Widget _buildSurahList(QuranViewModel vm) {
    if (vm.isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              width: 48,
              height: 48,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF0F766E)),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Memuat daftar surat...',
              style: TextStyle(color: Color(0xFF102A26), fontSize: 16),
            ),
          ],
        ),
      );
    }

    if (vm.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 48),
              const SizedBox(height: 16),
              Text(
                'Terjadi kesalahan:\n${vm.error}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF102A26).withOpacity(0.8),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (vm.daftarSurat.isEmpty) {
      return Center(
        child: Text(
          'Data surat tidak ditemukan',
          style: TextStyle(color: Color(0xFF102A26).withOpacity(0.7)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: vm.daftarSurat.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final surat = vm.daftarSurat[index];

        return Card(
          elevation: 0,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (c) =>
                        QuranDetailViewModel(c.read<QuranRepository>()),
                    child: QuranDetailPage(nomor: surat.nomor),
                  ),
                ),
              );
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F766E).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      surat.nomor.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF0F766E),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          surat.namaLatin,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: Color(0xFF102A26),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${surat.arti} • ${surat.jumlahAyat} Ayat',
                          style: TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    surat.nama,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: 'Arabic',
                      color: Color(0xFF102A26),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
