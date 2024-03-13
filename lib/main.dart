import 'package:flagguesser/constants.dart';
import 'package:flagguesser/pages/home_page.dart';
import 'package:flutter/material.dart';

class StaticVariables {
  static int pageIndex = 0;
}

void main() {
  runApp(const FlagGuesserMain());
}

class FlagGuesserMain extends StatelessWidget {
  const FlagGuesserMain({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flag Guesser',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: FlagGuesserPalette.mainColor,
          foregroundColor: Colors.white
        ),
        drawerTheme: const DrawerThemeData(backgroundColor: Color.fromARGB(255, 177, 175, 175)),
        scaffoldBackgroundColor: const Color.fromARGB(255, 218, 216, 216),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: FlagGuesserPalette.mainColor,
          foregroundColor: Colors.white
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 112, 111, 111),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
      ),
      home: const HomePage(),
    );
  }
}