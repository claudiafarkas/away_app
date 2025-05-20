import 'package:flutter/material.dart';
import 'views/welcome_load/welcome_load_screen.dart';
import 'views/home/imported_tab_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'views/map/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to initialize, but ignore the "duplicate-app" error
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print("Firebase initialized");
    }
  } on FirebaseException catch (e) {
    if (e.code == 'duplicate-app') {
      print("Firebase already initialized, skipping");
    } else {
      rethrow; // any other error should still crash
    }
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Away App',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF062D40)),
        scaffoldBackgroundColor: const Color.fromARGB(255, 6, 29, 41),
      ),
      home: const WelcomeLoad(),
      routes: {
        '/imported_tab_screen': (context) => MyImportsTabScreen(),
        '/map': (context) => const MapScreen(),
      },
    );
  }
}
