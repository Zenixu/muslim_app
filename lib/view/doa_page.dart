import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/doa_view_model.dart';

class DoaPage extends StatefulWidget {
  const DoaPage({super.key});
  @override
  State<DoaPage> createState() => _DoaPageState();
}

class _DoaPageState extends State<DoaPage> {
  @override
  void initState() {
    super.initState();
    // Memanggil API segera setelah halaman terbuka
    Future.microtask(() => context.read<DoaViewModel>().fetchDaftarDoa());
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DoaViewModel>(); // Mendengarkan perubahan di ViewModel
    return Scaffold(
      appBar: AppBar(title: const Text("Doa-doa"), backgroundColor: Colors.green),
      body: vm.isLoading 
          ? const Center(child: CircularProgressIndicator()) // Jika loading, tampilkan spinner
          : ListView.builder(
              itemCount: vm.daftarDoa.length,
              itemBuilder: (context, i) => ExpansionTile( // Bisa di klik untuk buka detail
                title: Text(vm.daftarDoa[i].doa),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Text(vm.daftarDoa[i].ayat, textAlign: TextAlign.right, style: const TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
    );
  }
}