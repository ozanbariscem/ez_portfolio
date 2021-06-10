import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BuildUtils {
  static Color barColor = Colors.deepPurple;
  static Color backgroundColor = Colors.deepPurpleAccent[50];// Colors.blueGrey.shade200;
  static Color shadowColor = Colors.deepPurple[100];// Colors.blueGrey.shade500;

  static Color linkTextColor = Colors.lightBlue.shade700;
  static Color headerTextColor = Colors.blueGrey.shade800;

  static Color green = Colors.lightGreen.shade800;
  static Color red = Colors.red.shade800;
  static Color white = Colors.white;

  static TextStyle elevatedButtonTextStyle({
    BuildContext context,
    double fontSize: 0.02,
    FontWeight fontWeight: FontWeight.normal,}) {
      return TextStyle(
        fontSize: MediaQuery.of(context).size.height * fontSize,
        fontWeight: fontWeight,
        color: backgroundColor,
    );
  }

  static TextStyle linkTextStyle(
      {BuildContext context,
      double fontSize: 0.02,
      FontWeight fontWeight: FontWeight.normal,}) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * fontSize,
      fontWeight: fontWeight,
      color: linkTextColor,
    );
  }

  static TextStyle headerTextStyle(context,
      [double fontSize = 0.02, FontWeight fontWeight = FontWeight.normal]) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * fontSize,
      fontWeight: fontWeight,
      color: headerTextColor,
    );
  }

  static TextStyle pnlTextStyle(context, bool isPositive,
      [double fontSize = 0.025, FontWeight fontWeight = FontWeight.bold]) {
    return TextStyle(
      fontSize: MediaQuery.of(context).size.height * fontSize,
      fontWeight: fontWeight,
      color: isPositive ? green : red,
    );
  }

  static Decoration buildBoxDecoration(context) {
    return BoxDecoration(
      borderRadius:
          BorderRadius.circular(MediaQuery.of(context).size.height * .005),
      color: white,
      boxShadow: [
        BoxShadow(
            color: shadowColor,
            blurRadius: MediaQuery.of(context).size.height * .01,
            offset: Offset(0.0, MediaQuery.of(context).size.height * .01)),
      ],
    );
  }

  static Widget buildEmptySpaceWidth(context, [double size = .1]) {
    return Container(width: MediaQuery.of(context).size.width * size);
  }

  static Widget buildEmptySpaceHeight(context, [double size = .005]) {
    return Container(height: MediaQuery.of(context).size.height * size);
  }
}
