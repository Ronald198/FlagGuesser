import 'package:flagguesser/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FlagGuesserMain());
}

class FlagGuesserMain extends StatelessWidget {
  const FlagGuesserMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flag Guesser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}