import 'package:flagguesser/main.dart';
import 'package:flagguesser/pages/flags_catalog_page.dart';
import 'package:flagguesser/pages/home_page.dart';
import 'package:flutter/material.dart';

Drawer getDrawer(BuildContext context) {
  String greeting = "";
  int hour = DateTime.now().hour;

  if(hour >= 5 && hour < 12)
  {
    greeting = "Good Morning";
  }
  else if(hour >= 12 && hour < 18)
  {
    greeting = "Good Afternoon";
  }
  else if(hour >= 18 && hour <= 23)
  {
    greeting = "Good Evening";
  }
  else if(hour >= 0 && hour < 5)
  {
    greeting = "Good Evening";
  }
  else
  {
    greeting = "Hello";
  }

  greeting = greeting; 
  final double statusBarHeight = MediaQuery.paddingOf(context).top;

  return Drawer(
    child: ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          margin: const EdgeInsets.only(bottom: 8.0),
          height: statusBarHeight + 161,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 71, 71, 71),
          ),
          child: Container(
            padding: EdgeInsets.only(top: statusBarHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("FlagGuesser", style: TextStyle(fontSize: 24, color: Colors.white),),
                    Text("© 2024 Ronald Lamani", style: TextStyle(color: Color.fromARGB(80, 255, 255, 255), fontSize: 12)),
                  ],
                ),
                Text(greeting, style: const TextStyle(fontSize: 16, color: Colors.white),),
              ],
            ),
          ),
        ),
        ListTile(
          title: const Text("Home"),
          trailing: const Icon(Icons.home),
          onTap: () {
            if(StaticVariables.pageIndex == 0)
            {
              Navigator.of(context).pop();
        
              return;
            }
        
            StaticVariables.pageIndex = 0;
        
            if (context.mounted)
            {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => 
                    const HomePage(),
                )
              );
            }
          },
        ),
        ListTile(
          title: const Text("Flags catalog"),
          trailing: const Icon(Icons.flag),
          onTap: () {
            if(StaticVariables.pageIndex == 1)
            {
              Navigator.of(context).pop();
    
              return;
            }
    
            StaticVariables.pageIndex = 1;
    
            if (context.mounted)
            {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => 
                    const FlagCatalog(),
                )
              );
            }
          },
        ),
        ListTile(
          title: const Text("Settings"),
          trailing: const Icon(Icons.settings),
          onTap: () {
            // if(StaticVariables.pageIndex == 2)
            // {
            //   Navigator.of(context).pop();
    
            //   return;
            // }
    
            // StaticVariables.pageIndex = 2;
    
            // if (context.mounted)
            // {
            //   Navigator.of(context).pushReplacement(
            //     MaterialPageRoute(
            //       builder: (context) => 
            //         const SettingsPage(),
            //     )
            //   );
            // }
          },
        ),
      ],
    ),
  );
}