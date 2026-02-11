import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import semua dependensi
import 'repository/doa_repository.dart';
import 'repository/quran_repository.dart';
import 'repository/shalat_repository.dart';
import 'viewmodel/doa_view_model.dart';
import 'viewmodel/quran_view_model.dart';
import 'viewmodel/shalat_view_model.dart';
import 'viewmodel/qibla_view_model.dart';
import 'view/home_page.dart';
import 'view/shalat_page.dart';
import 'view/quran_page.dart';
import 'view/doa_page.dart';
import 'view/splash_screen.dart';
import 'view/about_page.dart';
import 'view/qibla_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Daftarkan semua Repository sebagai Provider sederhana
        Provider(create: (_) => DoaRepository()),
        Provider(create: (_) => QuranRepository()),
        Provider(create: (_) => ShalatRepository()),
        
        // Daftarkan semua ViewModel dan hubungkan dengan Repository masing-masing
        ChangeNotifierProvider(create: (c) => DoaViewModel(c.read<DoaRepository>())),
        ChangeNotifierProvider(create: (c) => QuranViewModel(c.read<QuranRepository>())),
        ChangeNotifierProvider(create: (c) => ShalatViewModel(c.read<ShalatRepository>())),
        ChangeNotifierProvider(create: (_) => QiblaViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Muslim App',
        theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.green),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomePage(),
          '/shalat': (context) => const ShalatPage(),
          '/quran': (context) => const QuranPage(),
          '/doa': (context) => const DoaPage(),
          '/about': (context) => const AboutPage(),
          '/qibla': (context) => const QiblaPage(),
        },
      ),
    );
  }
}