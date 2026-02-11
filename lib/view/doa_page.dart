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

    // Ambil data doa saat halaman pertama kali dibuka
    Future.microtask(
      () => context.read<DoaViewModel>().fetchDaftarDoa(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DoaViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Doa Harian"),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: _buildBody(vm),
    );
  }

  // Mengatur tampilan berdasarkan kondisi data
  Widget _buildBody(DoaViewModel vm) {
    // 1. Loading
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // 2. Error
    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }

    // 3. Data kosong
    if (vm.daftarDoa.isEmpty) {
      return const Center(child: Text("Data doa tidak tersedia"));
    }

    // 4. Tampilkan list doa
    return ListView.separated(
      itemCount: vm.daftarDoa.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final Doa doa = vm.daftarDoa[index];

        return ListTile(
          title: Text(
            doa.doa,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: const Icon(Icons.chevron_right),

          // Navigasi ke halaman detail doa
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DoaDetailPage(doa: doa),
              ),
            );
          },
        );
      },
    );
  }
}
