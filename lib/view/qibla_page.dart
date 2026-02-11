import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodel/qibla_view_model.dart';

class QiblaPage extends StatelessWidget {
  const QiblaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QiblaViewModel()..initQibla(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Arah Kiblat"),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: Consumer<QiblaViewModel>(
          builder: (context, vm, _) {
            if (vm.qiblaDirection == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  // =====================
                  // INFO CARD
                  // =====================
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.explore,
                              color: Colors.green, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            vm.status,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // =====================
                  // KOMPAS
                  // =====================
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lingkaran dasar
                        Container(
                          width: 260,
                          height: 260,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.green.shade100,
                                Colors.green.shade50,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),

                        // Jarum kiblat
                        Transform.rotate(
                          angle: ((vm.qiblaDirection! -
                                      (vm.deviceDirection ?? 0)) *
                                  pi /
                                  180) *
                              -1,
                          child: Column(
                            children: const [
                              Icon(
                                Icons.navigation,
                                size: 110,
                                color: Colors.redAccent,
                              ),
                              SizedBox(height: 4),
                              Text(
                                "Kiblat",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.redAccent,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Ka'bah icon
                        const Positioned(
                          bottom: 35,
                          child: Icon(
                            Icons.mosque,
                            size: 42,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // =====================
                  // ANGLE INFO
                  // =====================
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.rotate_right,
                              color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            "${vm.qiblaDirection!.toStringAsFixed(2)}° dari Utara",
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
