import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final VoidCallback? onPress;
  final Color? backgroundColor;
  final String text;
  final IconData iconData;

  const SquareButton({super.key, required this.onPress, this.backgroundColor, required this.text, required this.iconData });

  @override
  Widget build(BuildContext context) {
    return Container( // Toggle Answer visibilty
      color: backgroundColor ?? Colors.blue.shade800,
      height: 100,
      width: 100,
      child: InkWell(
        splashColor: Colors.blue.shade900, 
        onTap: onPress,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData, color: Colors.white, size: 36,),
            Text(
              text, 
              style: const TextStyle(color: Colors.white, fontSize: 14), 
              textAlign: TextAlign.center,
            ),
          ],
        ),
      )
    );
  }
}