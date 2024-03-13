import 'package:flagguesser/constants.dart';
import 'package:flagguesser/services/countries.dart';
import 'package:flagguesser/widgets/drawer.dart';
import 'package:flutter/material.dart';

class FlagCatalog extends StatefulWidget {
  const FlagCatalog({super.key});

  @override
  State<FlagCatalog> createState() => _FlagCatalogState();
}

class _FlagCatalogState extends State<FlagCatalog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(),
      drawer: getDrawer(context),
      body: getBody(),
    );
  }

  PreferredSizeWidget getHeader() {
    return AppBar(
      title: const Text("Flags Catalog"),
    );
  }

  Widget getBody() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: RawScrollbar(
        thumbColor: FlagGuesserPalette.mainColor,
        thickness: 8,
        radius: const Radius.circular(30),
        crossAxisMargin: 2,
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.79
          ),
          children: [
            for (int i = 0; i < 255; i++) ...[
              flagTile(i)
            ],
          ],
        ),
      ),
    );
  }

  /// Gets a random flag that is not found and returns its image asset link.
  Widget flagTile(int index) {
    String imageLink = "assets/country-flags/${CountriesApi.countries[index].toLowerCase()}.png";
    String countryName = CountriesApi.getNameFromKey(CountriesApi.countries[index])!;

    return Card(
      color: const Color.fromARGB(255, 186, 186, 187),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imageLink, width: 100,),
          Text(countryName, textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}