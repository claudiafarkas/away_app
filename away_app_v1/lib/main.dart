import 'package:flutter/material.dart';
import 'views/welcome_load/welcome_load_screen.dart';
import 'views/home/imported_tab_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// void main() => runApp(const MyApp());
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';

// // ...

// await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
// );

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      routes: {'/imported_tab_screen': (context) => MyImportsTabScreen()},
    );
  }
}
