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

    // Ambil detail surat saat halaman dibuka
    Future.microtask(() {
      context
          .read<QuranDetailViewModel>()
          .fetchDetailSurat(widget.nomor);
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuranDetailViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Surat'),
        backgroundColor: Colors.green,
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(QuranDetailViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }

    if (vm.surat == null) {
      return const Center(child: Text('Data tidak tersedia'));
    }

    return ListView.builder(
      itemCount: vm.surat!.ayat.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final ayat = vm.surat!.ayat[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [

              // ===== BARIS ATAS (NOMOR AYAT) =====
              Row(
                children: [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.green,
                    child: Text(
                      ayat.nomorAyat.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ===== TEKS ARAB =====
              Text(
                ayat.arab,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 26,
                  height: 1.8,
                  fontFamily: 'Arabic',
                ),
              ),

              const SizedBox(height: 12),

              // ===== LATIN =====
              Text(
                ayat.latin,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                ),
              ),

              const SizedBox(height: 8),

              // ===== TERJEMAHAN =====
              Text(
                ayat.arti,
                style: const TextStyle(
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
