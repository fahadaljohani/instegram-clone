import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Color borderColor;
  final Function() function;
  const FollowButton(
      {Key? key,
      required this.text,
      required this.textColor,
      required this.backgroundColor,
      required this.borderColor,
      required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      child: Container(
        alignment: Alignment.center,
        width: 250,
        height: 35,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: backgroundColor,
            border: Border.all(color: borderColor)),
        child: TextButton(
          onPressed: function,
          child: Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
