import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/quran_detail_view_model.dart';

class QuranDetailPage extends StatefulWidget {
  final int nomor;

  const QuranDetailPage({super.key, required this.nomor});

  @override
  State<QuranDetailPage> createState() => _QuranDetailPageState();
}

class _QuranDetailPageState extends State<QuranDetailPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<QuranDetailViewModel>().fetchDetailSurat(widget.nomor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranDetailViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: Text('Surat ${vm.surat?.namaLatin ?? "Detail"}'),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(QuranDetailViewModel vm) {
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
              'Memuat detail surat...',
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
                vm.error!,
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

    if (vm.surat == null) {
      return Center(
        child: Text(
          'Data tidak tersedia',
          style: TextStyle(color: Color(0xFF102A26).withOpacity(0.7)),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: vm.surat!.ayat.length,
      itemBuilder: (context, index) {
        final ayat = vm.surat!.ayat[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 24),
          child: Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== BARIS ATAS (NOMOR AYAT) =====
                  Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F766E),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Text(
                          ayat.nomorAyat.toString(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Ayat ${ayat.nomorAyat}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF102A26),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ===== TEKS ARAB =====
                  Text(
                    ayat.arab,
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 28,
                      height: 1.8,
                      fontFamily: 'Arabic',
                      color: Color(0xFF102A26),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ===== LATIN =====
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F766E).withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      ayat.latin,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF102A26),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ===== TERJEMAHAN =====
                  Text(
                    ayat.arti,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.6,
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
