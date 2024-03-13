import 'dart:math';

import 'package:flagguesser/constants.dart';
import 'package:flagguesser/pages/home_page.dart';
import 'package:flagguesser/services/countries.dart';
import 'package:flutter/material.dart';

class FlagPreset extends StatefulWidget {
  final Function refreshHomePageCallback;

  const FlagPreset({super.key, required this.refreshHomePageCallback });

  @override
  State<FlagPreset> createState() => _FlagPresetState();
}

class _FlagPresetState extends State<FlagPreset> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getHeader(),
      body: getBody(),
    );
  }

  PreferredSizeWidget getHeader() {
    return AppBar(
      title: const Text("Flags Preset"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text("${CountriesApi.chosenPresetLength} / 255"),
        )
      ],
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

  Widget flagTile(int index) {
    bool isContained = false;
    String countryKey = CountriesApi.allCountries[index];
    String imageLink = "assets/country-flags/${countryKey.toLowerCase()}.png";
    String countryName = CountriesApi.getNameFromKey(countryKey)!;

    if (CountriesApi.chosenPreset.contains(countryKey))
    {
      isContained = true;
    }

    return InkWell(
      onTap: () {
        if (FlagGuessingData.countriesFound != 0) // ongoing game
        {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content: const Text("Changing the preset restarts the current game. Are you sure you want to continue?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      if (isContained) {
                        removeFlagFromPreset(countryKey);
                        isContained = false;
                      }
                      else {
                        addFlagToPreset(countryKey);
                        isContained = true;
                      }

                      FlagGuessingData.countries = CountriesApi.chosenPreset.toList();
                      FlagGuessingData.countriesFound = 0;
                      FlagGuessingData.countriesFoundPercentage = 0;
                      FlagGuessingData.countryIndex = Random().nextInt(CountriesApi.chosenPresetLength);
                      FlagGuessingData.countryKey = FlagGuessingData.countries[FlagGuessingData.countryIndex];
                      FlagGuessingData.imageLink = "assets/country-flags/${FlagGuessingData.countryKey.toLowerCase()}.png";
                      FlagGuessingData.answer = CountriesApi.getNameFromKey(FlagGuessingData.countryKey)!;
  
                      Navigator.pop(context);

                      widget.refreshHomePageCallback();
                      setState(() { });
                      return;
                    },
                    child: const Text("Yes"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    
                      return;
                    },
                    child: const Text("No"),
                  ),
                ],
              );
            },
          );
        }
        else
        {
          if (isContained) {
            removeFlagFromPreset(countryKey);
            isContained = false;
          }
          else {
            addFlagToPreset(countryKey);
            isContained = true;
          }

          widget.refreshHomePageCallback();
          setState(() { });
        }
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          Card(
            color: const Color.fromARGB(255, 186, 186, 187),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(imageLink, width: 100,),
                Text(countryName, textAlign: TextAlign.center,)
              ],
            ),
          ),
          if (isContained) ...[
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(158, 255, 255, 255),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            Icon(Icons.check_circle, color: Colors.green.shade900, size: 52,)
          ],
        ],
      ),
    );
  }

  /// Removes flag to preset
  void removeFlagFromPreset(String countryKey) {
    CountriesApi.chosenPreset.remove(countryKey);
    CountriesApi.chosenPresetLength--;

    if (FlagGuessingData.countryKey == countryKey)
    {
      FlagGuessingData.countries = CountriesApi.chosenPreset;
      FlagGuessingData.countriesFound = 0;
      FlagGuessingData.countriesFoundPercentage = 0;
      FlagGuessingData.countryIndex = Random().nextInt(CountriesApi.chosenPresetLength);
      FlagGuessingData.countryKey = FlagGuessingData.countries[FlagGuessingData.countryIndex];
      FlagGuessingData.imageLink = "assets/country-flags/${FlagGuessingData.countryKey.toLowerCase()}.png";
      FlagGuessingData.answer = CountriesApi.getNameFromKey(FlagGuessingData.countryKey)!;
    }
  }

  /// Adds flag to preset
  void addFlagToPreset(String countryKey) {
    CountriesApi.chosenPreset.add(countryKey);
    CountriesApi.chosenPresetLength++;
  }
}