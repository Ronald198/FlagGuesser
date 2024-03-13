import 'dart:math';

import 'package:flagguesser/pages/flags_preset_page.dart';
import 'package:flagguesser/widgets/drawer.dart';
import 'package:flagguesser/widgets/square_button.dart';
import 'package:flagguesser/services/countries.dart';
import 'package:flutter/material.dart';

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
  static late String answer;

  static List<String> countries = [
    "AD", "AE", "AF", "AG", "AI", "AL", "AM", "AO", "AQ", "AR", "AS", "AT", "AU", "AW", "AX", "AZ", "BA", "BB", "BD", "BE", "BF", "BG", "BH", "BI", "BJ",
    "BL", "BM", "BN", "BO", "BQ", "BR", "BS", "BT", "BV", "BW", "BY", "BZ", "CA", "CC", "CD", "CF", "CG", "CH", "CI", "CK", "CL", "CM", "CN", "CO", "CR",
    "CU", "CV", "CW", "CX", "CY", "CZ", "DE", "DJ", "DK", "DM", "DO", "DZ", "EC", "EE", "EG", "EH", "ER", "ES", "ET", "EU", "FI", "FJ", "FK", "FM", "FO",
    "FR", "GA", "GB-ENG", "GB-NIR", "GB-SCT", "GB-WLS", "GB", "GD", "GE", "GF", "GG", "GH", "GI", "GL", "GM", "GN", "GP", "GQ", "GR", "GS", "GT", "GU", "GW", "GY", "HK", 
    "HM", "HN", "HR", "HT", "HU", "ID", "IE", "IL", "IM", "IN", "IO", "IQ", "IR", "IS", "IT", "JE", "JM", "JO", "JP", "KE", "KG", "KH", "KI", "KM", "KN",
    "KP", "KR", "KW", "KY", "KZ", "LA", "LB", "LC", "LI", "LK", "LR", "LS", "LT", "LU", "LV", "LY", "MA", "MC", "MD", "ME", "MF", "MG", "MH", "MK", "ML",
    "MM", "MN", "MO", "MP", "MQ", "MR", "MS", "MT", "MU", "MV", "MW", "MX", "MY", "MZ", "NA", "NC", "NE", "NF", "NG", "NI", "NL", "NO", "NP", "NR", "NU",
    "NZ", "OM", "PA", "PE", "PF", "PG", "PH", "PK", "PL", "PM", "PN", "PR", "PS", "PT", "PW", "PY", "QA", "RE", "RO", "RS", "RU", "RW", "SA", "SB", "SC",
    "SD", "SE", "SG", "SH", "SI", "SJ", "SK", "SL", "SM", "SN", "SO", "SR", "SS", "ST", "SV", "SX", "SY", "SZ", "TC", "TD", "TF", "TG", "TH", "TJ", "TK",
    "TL", "TM", "TN", "TO", "TR", "TT", "TV", "TW", "TZ", "UA", "UG", "UM", "US", "UY", "UZ", "VA", "VC", "VE", "VG", "VI", "VN", "VU", "WF", "WS", "XK",
    "YE", "YT", "ZA", "ZM", "ZW",
  ]; // length: 255
}

class _HomePageState extends State<HomePage> {
  TextEditingController countryNameTextField = TextEditingController();
  
  late FocusNode countryNameInputFocusNode;

  bool showAnswer = false;

  @override
  void initState() {
    super.initState();

    countryNameInputFocusNode = FocusNode();

    if(FlagGuessingData.countriesFound == 0) {
      FlagGuessingData.countries = CountriesApi.chosenPreset;
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
          child: Text("${FlagGuessingData.countriesFound} / ${CountriesApi.chosenPresetLength} | ${FlagGuessingData.countriesFoundPercentage.toStringAsPrecision(2)}%"),
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
                    visible: showAnswer,
                    child: Text(FlagGuessingData.answer, style: const TextStyle(fontSize: 16),)
                  ),
                ), 
              ],
            ),
          ),
          Padding(
            padding: showAnswer 
            ? 
              const EdgeInsets.only(left: 15, right: 15)
            :
              const EdgeInsets.only(left: 15, right: 15, top: 25),
            child: TextField(
              controller: countryNameTextField,
              focusNode: countryNameInputFocusNode,
              onChanged: (value) {
                if (value.toLowerCase() == FlagGuessingData.answer.toLowerCase()) {
                  countryNameTextField.clear();

                  FlagGuessingData.countries.removeAt(FlagGuessingData.countryIndex);
                  FlagGuessingData.countriesFound++;
                  generateNextFlag();
                }
              },
              onSubmitted: (value) {
                if (value == "") {
                  skipFlag();
                }
              },
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  onPressed: () {
                    countryNameTextField.clear();
                  },
                  icon: const Icon(Icons.clear_rounded),
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
                          Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => 
                              FlagPreset(refreshHomePageCallback: refreshPage)
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

  /// Skips flag and calls a new one to be generated.
  void skipFlag() {
    countryNameTextField.clear();
    countryNameInputFocusNode.requestFocus();
    generateNextFlag();
  }

  /// Restart game data and calls a new one to be generated.
  void restartGame() {
    FlagGuessingData.countries = CountriesApi.chosenPreset.toList();
    FlagGuessingData.countriesFound = 0;
    generateNextFlag();
  }

  void refreshPage() {
    setState(() {});
  }

  /// Gets a random flag that is not found and returns its image asset link.
  void generateNextFlag() {
    FlagGuessingData.countriesFoundPercentage = FlagGuessingData.countriesFound / CountriesApi.chosenPresetLength * 100;
    FlagGuessingData.countryIndex = Random().nextInt(CountriesApi.chosenPresetLength - FlagGuessingData.countriesFound);
    FlagGuessingData.countryKey = FlagGuessingData.countries[FlagGuessingData.countryIndex];
    FlagGuessingData.imageLink = "assets/country-flags/${FlagGuessingData.countryKey.toLowerCase()}.png";
    FlagGuessingData.answer = CountriesApi.getNameFromKey(FlagGuessingData.countryKey)!;
    
    setState(() { });
  }

  @override
  void dispose() {
    countryNameInputFocusNode.dispose();

    super.dispose();
  }
}