import 'package:flutter/material.dart';
// import 'lib/widgets/bottom_nav_scaffold.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Home Screen',
          style: TextStyle(color: Color.fromARGB(255, 244, 241, 219)),
        ),
      ),
    );
  }
}
