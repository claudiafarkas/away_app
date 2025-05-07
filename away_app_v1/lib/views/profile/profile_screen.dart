import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(color: Color.fromARGB(255, 244, 241, 219)),
        ),
      ),
    );
  }
}
