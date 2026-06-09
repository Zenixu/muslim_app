import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/doa_view_model.dart';
import '../model/doa_response.dart';
import 'doa_detail_page.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});

  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<DoaViewModel>().fetchDaftarDoa();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DoaViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF9),
      appBar: AppBar(
        title: const Text("Doa Harian"),
        backgroundColor: const Color(0xFF0F766E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildBody(vm),
    );
  }

  Widget _buildBody(DoaViewModel vm) {
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
              'Memuat daftar doa...',
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

    if (vm.daftarDoa.isEmpty) {
      return Center(
        child: Text(
          "Data doa tidak tersedia",
          style: TextStyle(color: Color(0xFF102A26).withOpacity(0.7)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: vm.daftarDoa.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final Doa doa = vm.daftarDoa[index];

        return Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doa.doa,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xFF102A26),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doa.latin,
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F766E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Color(0xFF0F766E),
                    size: 24,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
