import 'package:flutter/material.dart';

class ButtonApp extends StatelessWidget {
  final Color? color;
  final Color? textColor;
  final String? text;
  final IconData icon;
  final Color? iconColor;
  final Function? onPressed;

  // ignore: use_key_in_widget_constructors
  const ButtonApp({
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.icon = Icons.arrow_forward_ios,
    this.iconColor = Colors.black,
    this.onPressed,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed!();
      },
      child: Stack(
        children: [
          Align(
              alignment: Alignment.center,
              child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    text!,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ))),
          Align(
            alignment: Alignment.centerRight,
            // ignore: sized_box_for_whitespace
            child: Container(
              height: 50,
              child: CircleAvatar(
                radius: 15,
                child: Icon(
                  icon,
                  color: iconColor,
                ),
                backgroundColor: Colors.white,
              ),
            ),
          ),
        ],
      ),
      style: ElevatedButton.styleFrom(
          primary: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          textStyle: TextStyle(
            color: textColor,
            //fontSize: 30,
            //fontWeight: FontWeight.bold
          )),
    );
  }
}
