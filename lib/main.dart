import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// ================= REPOSITORY =================
import 'repository/doa_repository.dart';
import 'repository/quran_repository.dart';
import 'repository/shalat_repository.dart';
import 'repository/chat_repository.dart';

// ================= VIEWMODEL =================
import 'viewmodel/doa_view_model.dart';
import 'viewmodel/quran_view_model.dart';
import 'viewmodel/shalat_view_model.dart';
import 'viewmodel/qibla_view_model.dart';
import 'viewmodel/chat_view_model.dart';

// ================= VIEW =================
import 'view/home_page.dart';
import 'view/shalat_page.dart';
import 'view/quran_page.dart';
import 'view/doa_page.dart';
import 'view/splash_screen.dart';
import 'view/about_page.dart';
import 'view/qibla_page.dart';
import 'view/chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ================= REPOSITORY =================
        Provider(create: (_) => DoaRepository()),
        Provider(create: (_) => QuranRepository()),
        Provider(create: (_) => ShalatRepository()),
        Provider(create: (_) => ChatRepository()),

        // ================= VIEWMODEL =================
        ChangeNotifierProvider(
          create: (c) => DoaViewModel(c.read<DoaRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => QuranViewModel(c.read<QuranRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => ShalatViewModel(c.read<ShalatRepository>()),
        ),
        ChangeNotifierProvider(create: (_) => QiblaViewModel()),
        ChangeNotifierProvider(
          create: (c) => ChatViewModel(c.read<ChatRepository>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Muslim App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: const ColorScheme(
            brightness: Brightness.light,
            primary: Color(0xFF0F766E),
            onPrimary: Colors.white,
            secondary: Color(0xFF14B8A6),
            onSecondary: Colors.white,
            surface: Color(0xFFF8FAF9),
            onSurface: Color(0xFF102A26),
            error: Color(0xFFB91C1C),
            onError: Colors.white,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8FAF9),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0F766E),
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          cardTheme: CardThemeData(
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: Color(0xFF0F766E), width: 2),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F766E),
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomePage(),
          '/shalat': (context) => const ShalatPage(),
          '/quran': (context) => const QuranPage(),
          '/doa': (context) => const DoaPage(),
          '/about': (context) => const AboutPage(),
          '/qibla': (context) => const QiblaPage(),
          '/chat': (context) => ChatPage(),
        },
      ),
    );
  }
}
