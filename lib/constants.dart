import 'package:flutter/material.dart';

class FlagGuesserPalette { 
  static const MaterialColor mainColor =  MaterialColor( 
    0xFF474747, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch. 
     <int, Color>{ 
      50:Color(0xFF404040), //10% 
      100:Color(0xFF393939), //20% 
      200:Color(0xFF323232), //30% 
      300:Color(0xFF2b2b2b), //40% 
      400:Color(0xFF242424), //50% 
      500:Color(0xFF1c1c1c), //60% 
      600:Color(0xFF151515), //70% 
      700:Color(0xFF0e0e0e), //80% 
      800:Color(0xFF070707), //90% 
      900:Color(0xFF000000), //100% 
    }, 
  ); 
  // static const Color backgroundColor = Color.fromARGB(255, 175, 175, 175);
}