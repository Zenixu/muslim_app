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
        backgroundColor: const Color(0xFFF8FAF9),
        appBar: AppBar(
          title: const Text("Arah Kiblat"),
          backgroundColor: const Color(0xFF0F766E),
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        body: Consumer<QiblaViewModel>(
          builder: (context, vm, _) {
            if (vm.qiblaDirection == null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 48,
                      height: 48,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF0F766E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Memuat arah kiblat...',
                      style: TextStyle(color: Color(0xFF102A26), fontSize: 16),
                    ),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // =====================
                  // INFO CARD
                  // =====================
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F766E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Icon(
                              Icons.explore,
                              color: Color(0xFF0F766E),
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            vm.status,
                            textAlign: TextAlign.center,
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

                  const SizedBox(height: 32),

                  // =====================
                  // KOMPAS
                  // =====================
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Lingkaran dasar
                        Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFF0F766E).withOpacity(0.1),
                                const Color(0xFF14B8A6).withOpacity(0.05),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                        ),

                        // Jarum kiblat
                        Transform.rotate(
                          angle:
                              ((vm.qiblaDirection! -
                                      (vm.deviceDirection ?? 0)) *
                                  pi /
                                  180) *
                              -1,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.navigation,
                                  size: 64,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Kiblat",
                                style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFFEF4444),
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Ka'bah icon
                        const Positioned(
                          bottom: 40,
                          child: Icon(
                            Icons.mosque,
                            size: 48,
                            color: Color(0xFF0F766E),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // =====================
                  // ANGLE INFO
                  // =====================
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F766E).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.rotate_right,
                              color: Color(0xFF0F766E),
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "${vm.qiblaDirection!.toStringAsFixed(2)}° dari Utara",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF102A26),
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
