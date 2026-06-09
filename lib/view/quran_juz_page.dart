import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/quran_view_model.dart';
import '../viewmodel/quran_detail_view_model.dart';
import '../repository/quran_repository.dart';
import 'quran_detail_page.dart';

class QuranJuzPage extends StatefulWidget {
  const QuranJuzPage({super.key});

  @override
  State<QuranJuzPage> createState() => _QuranJuzPageState();
}

class _QuranJuzPageState extends State<QuranJuzPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<QuranViewModel>().fetchDaftarSurat();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(QuranViewModel vm) {
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
              'Memuat data juz...',
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

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 30,
      itemBuilder: (context, juzIndex) {
        final juzNumber = juzIndex + 1;
        final surahsInJuz = _getSurahsInJuz(vm.daftarSurat, juzNumber);

        if (surahsInJuz.isEmpty) {
          return const SizedBox.shrink();
        }

        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F766E).withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(22),
                  ),
                ),
                child: Text(
                  'Juz $juzNumber',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0F766E),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: surahsInJuz.map((surat) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ChangeNotifierProvider(
                                create: (c) => QuranDetailViewModel(
                                    c.read<QuranRepository>()),
                                child: QuranDetailPage(nomor: surat.nomor),
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: const Color(0xFF0F766E).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  surat.nomor.toString(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xFF0F766E),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    surat.namaLatin,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      color: Color(0xFF102A26),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${surat.arti} • ${surat.jumlahAyat} Ayat',
                                    style: TextStyle(
                                      color: Color(0xFF64748B),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              surat.nama,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: 'Arabic',
                                color: Color(0xFF102A26),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<dynamic> _getSurahsInJuz(List<dynamic> surahs, int juzNumber) {
    final Map<int, List<int>> juzToSurahs = {
      1: [1, 2],
      2: [2],
      3: [2, 3],
      4: [3, 4],
      5: [4],
      6: [4, 5],
      7: [5, 6],
      8: [6, 7],
      9: [7, 8],
      10: [8, 9],
      11: [9, 10, 11],
      12: [11, 12],
      13: [12, 13, 14],
      14: [15, 16],
      15: [17, 18],
      16: [18, 19, 20],
      17: [21, 22],
      18: [23, 24, 25],
      19: [25, 26, 27],
      20: [27, 28, 29],
      21: [29, 30, 31, 32, 33],
      22: [33, 34, 35, 36],
      23: [36, 37, 38, 39],
      24: [39, 40, 41],
      25: [41, 42, 43, 44, 45],
      26: [46, 47, 48, 49, 50, 51],
      27: [51, 52, 53, 54, 55, 56, 57],
      28: [58, 59, 60, 61, 62, 63, 64, 65, 66],
      29: [67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77],
      30: List.generate(114 - 78 + 1, (i) => 78 + i),
    };

    final surahIds = juzToSurahs[juzNumber] ?? [];
    return surahs.where((s) => surahIds.contains(s.nomor)).toList();
  }
}
