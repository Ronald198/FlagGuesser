import 'dart:convert';
import 'dart:math';

import 'package:flagguesser/databaseManager.dart';
import 'package:flagguesser/pages/flags_preset_page.dart';
import 'package:flagguesser/widgets/drawer.dart';
import 'package:flagguesser/widgets/square_button.dart';
import 'package:flagguesser/services/countries.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class FlagGuessingData {
  static int countriesFound = 0;
  static double countriesFoundPercentage = 0;
  static late String imageLink;
  static late int countryIndex;
  static late String countryKey;
  static late List<String> answerList;

  static late List<String> countriesToFind;
  static List<String> countriesSkipped = [];
}

class _HomePageState extends State<HomePage> {
  TextEditingController countryNameTextField = TextEditingController();
  
  late FocusNode countryNameInputFocusNode;

  bool showAnswer = false;
  bool showTip = false;

  @override
  void initState() {
    super.initState();

    countryNameInputFocusNode = FocusNode();

    if(FlagGuessingData.countriesFound == 0) {
      FlagGuessingData.countriesToFind = CountriesApi.chosenPreset.toList();
      generateNextFlag();
    }
  }

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
      title: const Text("Flag Guesser"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: Text("${FlagGuessingData.countriesFound} / ${CountriesApi.chosenPresetLength} | ${FlagGuessingData.countriesFoundPercentage.toStringAsFixed(2)}%"),
        )
      ],
    );
  }

  Widget getBody() {    
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 30),
            child: Column(
              children: [
                Image.asset(FlagGuessingData.imageLink, height: 150,),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Visibility(
                    visible: showAnswer || showTip,
                    child: Text(FlagGuessingData.answerList[0], style: const TextStyle(fontSize: 16),)
                  ),
                ), 
              ],
            ),
          ),
          Padding(
            padding: showAnswer || showTip
            ? 
              const EdgeInsets.only(left: 15, right: 15)
            :
              const EdgeInsets.only(left: 15, right: 15, top: 25),
            child: TextField(
              controller: countryNameTextField,
              focusNode: countryNameInputFocusNode,
              onChanged: (value) {
                checkIfFound(value);
              },
              onSubmitted: (value) {
                if (value == "") {
                  skipFlag();
                }
              },
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        showTip = !showTip;
                        
                        setState(() { });
                      },
                      icon: showTip 
                      ?
                        const Icon(Icons.lightbulb_outline)
                      :
                        const Icon(Icons.lightbulb),
                    ),
                    IconButton(
                      onPressed: () {
                        countryNameTextField.clear();
                      },
                      icon: const Icon(Icons.clear_rounded),
                    ),
                  ],
                )
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              skipFlag();
            },
            child: const Text("Next"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container( // Toggle Answer visibilty
                      color: Colors.blue.shade800,
                      height: 100,
                      width: 100,
                      child: InkWell(
                        splashColor: Colors.blue.shade900, 
                        onTap: () {
                          showAnswer = !showAnswer;
                    
                          setState(() { });
                        }, 
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            showAnswer
                            ?
                              const Icon(Icons.visibility_off, color: Colors.white, size: 36,)
                            :
                              const Icon(Icons.visibility, color: Colors.white, size: 36,),
                            Text(
                              showAnswer ? "Hide\nanswers" : "Show\nanswers", 
                              style: const TextStyle(color: Colors.white, fontSize: 14), 
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    ),
                    SquareButton( //Restart
                      onPress: () {   
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Confirm"),
                              content: const Text("Are you sure you want to restart?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    restartGame();
                
                                    Navigator.pop(context);
                                    setState(() { });
                                  },
                                  child: const Text("Yes"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text("No"),
                                ),
                              ],
                            );
                          },
                        );         
                      }, 
                      text: "Restart",
                      iconData: Icons.refresh,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SquareButton(
                        onPress: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text("This will override the current custom preset. Are you sure you want to continue?"),
                                actions: [
                                  TextButton(
                                    onPressed: () async {   
                                      List<String> customPreset = [];
                                      customPreset = FlagGuessingData.countriesSkipped.toList();
                                      customPreset += FlagGuessingData.countriesToFind.toList();

                                      String flags = json.encode(customPreset);

                                      int res = await DatabaseManager.instance.updateCustomPreset(flags, 1);

                                      if (res != 0)
                                      {
                                        Fluttertoast.showToast(msg: "Saved flags to custom preset!");
                                      }
                                      else
                                      {
                                        Fluttertoast.showToast(msg: "Error while saving to preset!");
                                      }

                                      if (context.mounted)
                                      {
                                        Navigator.pop(context);
                                      }
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
                        },
                        text: "Save rest to custom",
                        iconData: Icons.save,
                      ),
                      SquareButton(
                        onPress: () {   
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => 
                              FlagPresetPage(refreshHomePageCallback: refreshPage)
                            )
                          );
                        }, 
                        text: "Change flags preset",
                        iconData: Icons.flag_circle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Checks if the user has given the correct answer and generates a flag if yes.
  void checkIfFound(String value) {
    if (FlagGuessingData.answerList.any((countryName) => countryName.toLowerCase() == value.toLowerCase())) {
      countryNameTextField.clear();

      FlagGuessingData.countriesToFind.removeAt(FlagGuessingData.countryIndex);
      FlagGuessingData.countriesFound++;
      generateNextFlag();
      
      HapticFeedback.lightImpact();
    }
  }

  /// Skips flag and calls a new one to be generated.
  void skipFlag() {
    countryNameTextField.clear();
    countryNameInputFocusNode.requestFocus();

    FlagGuessingData.countriesSkipped.add(FlagGuessingData.countryKey);
    FlagGuessingData.countriesToFind.removeAt(FlagGuessingData.countryIndex);

    generateNextFlag();
  }

  /// Restart game data and calls a new one to be generated.
  void restartGame() {
    FlagGuessingData.countriesToFind = CountriesApi.chosenPreset.toList();
    FlagGuessingData.countriesFound = 0;
    generateNextFlag();
  }

  void refreshPage() {
    setState(() {});
  }

  /// Gets a random flag that is not found and returns its image asset link.
  void generateNextFlag() {
    FlagGuessingData.countriesFoundPercentage = FlagGuessingData.countriesFound / CountriesApi.chosenPresetLength * 100;

    if(FlagGuessingData.countriesFound != CountriesApi.chosenPresetLength)
    {
      if (FlagGuessingData.countriesToFind.isEmpty) // every country was seen once, restore list to see all again
      {
        FlagGuessingData.countriesToFind = FlagGuessingData.countriesSkipped.toList();
        FlagGuessingData.countriesSkipped = [];
      }

      FlagGuessingData.countryIndex = Random().nextInt(CountriesApi.chosenPresetLength - FlagGuessingData.countriesFound - FlagGuessingData.countriesSkipped.length);
      FlagGuessingData.countryKey = FlagGuessingData.countriesToFind[FlagGuessingData.countryIndex];
      FlagGuessingData.imageLink = "assets/country-flags/${FlagGuessingData.countryKey.toLowerCase()}.png";
      FlagGuessingData.answerList = CountriesApi.getNameFromISOCode(FlagGuessingData.countryKey)!;
    }
    else // You won
    {
      FlagGuessingData.countriesFoundPercentage = 100.0;
    }

    if (showTip)
    {
      showTip = false;
    }
    
    setState(() { });
  }

  @override
  void dispose() {
    countryNameInputFocusNode.dispose();

    super.dispose();
  }
}