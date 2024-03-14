import 'package:flagguesser/constants.dart';
import 'package:flagguesser/databaseManager.dart';
import 'package:flagguesser/pages/home_page.dart';
import 'package:flagguesser/services/countries.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StaticVariables {
  static int pageIndex = 0;
  static SharedPreferences? sharedPrefs;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  StaticVariables.sharedPrefs = await SharedPreferences.getInstance();

  if (!StaticVariables.sharedPrefs!.containsKey("chosenPreset"))
  {
    await StaticVariables.sharedPrefs!.setString("chosenPreset", "worldwidePreset");
    CountriesApi.loadPreset(CountriesApi.allCountries);
  }
  else
  {
    String chosenPreset = StaticVariables.sharedPrefs!.getString("chosenPreset")!;

    switch (chosenPreset) {
      case "worldwidePreset":
        CountriesApi.loadPreset(CountriesApi.allCountries);
        break;
      case "europePreset":
        CountriesApi.loadPreset(CountriesApi.europePreset);
        break;
      case "asiaPreset":
        CountriesApi.loadPreset(CountriesApi.asiaPreset);     
        break;
      case "africaPreset":
        CountriesApi.loadPreset(CountriesApi.africaPreset);
        break;
      case "northAmericaPreset":
        CountriesApi.loadPreset(CountriesApi.northAmericaPreset);
        break;
      case "southAmericaPreset":
        CountriesApi.loadPreset(CountriesApi.southAmericaPreset);
        break;
      case "oceaniaPreset":
        CountriesApi.loadPreset(CountriesApi.oceaniaPreset);
        break;
      case "sporclePreset":
        CountriesApi.loadPreset(CountriesApi.sporclePreset);
        break;
      case "customPreset":
        FlagPreset? customPreset = await DatabaseManager.instance.getFlagPresetById(1);
        CountriesApi.loadPreset(customPreset!.flags);
        break;
    }
  }

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