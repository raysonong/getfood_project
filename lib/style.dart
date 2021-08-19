import 'package:flutter/material.dart';

// Primary Color
final Color primaryColorStyle = Colors.orange[800];
// Primary Color Highlight
final Color primaryColorHighlightStyle = Colors.orange[900];
// Complementary Color
final Color complementaryColorStyle = Colors.blue;
// Primary Container Color
final Color primaryContainerColorStyle = Colors.white;
// Secondary Container Color
final Color secondaryContainerColorStyle = Colors.grey[100];
// Icon Color
final Color iconColorStyle = Colors.grey[700];
// Text Color 1 Style
final Color textColor1Style = Colors.black;
// Text Color 2 Style
final Color textColor2Style = Colors.grey[700];
// Text Color 3 Style
final Color textColor3Style = Colors.white;
// Text Color 4 Style
final Color textColor4Style = Colors.grey[400];
// Shadow Color Style
final shadowColorStyle = Colors.grey.withOpacity(0.5);
// Image Blender Color Style
final imageBlenderColorStyle = Colors.black.withOpacity(0.5);

// Heading 1 Style
final TextStyle heading1Style = TextStyle(
  color: textColor1Style,
  fontWeight: FontWeight.bold,
  fontSize: 24,
);
// Heading 2 Style
final TextStyle heading2Light = TextStyle(
  color: textColor1Style,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);
final TextStyle heading2Dark = TextStyle(
  color: textColor3Style,
  fontWeight: FontWeight.bold,
  fontSize: 20,
);
// Heading 3 Style
final TextStyle heading3Light = TextStyle(
  color: textColor1Style,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);
final TextStyle heading3Dark = TextStyle(
  color: textColor3Style,
  fontWeight: FontWeight.bold,
  fontSize: 18,
);
// Heading 4 Style
final TextStyle heading4Light = TextStyle(
  color: textColor1Style,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);
final TextStyle heading4Dark = TextStyle(
  color: textColor3Style,
  fontWeight: FontWeight.bold,
  fontSize: 16,
);
// Paragraph Style
final TextStyle paragraph1Style = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
  color: textColor2Style,
);
// Paragraph 2 Style
final TextStyle paragraph2Style = TextStyle(
  fontSize: 14,
  fontWeight: FontWeight.normal,
  color: textColor2Style,
);

// FlatButton Style
final ButtonStyle flatButtonStyle = TextButton.styleFrom(
  padding: EdgeInsets.all(5),
  textStyle: TextStyle(
    fontSize: 18.0,
  ),
  minimumSize: Size(88, 0),
  shape: RoundedRectangleBorder(
    borderRadius: borderRadiusStyle,
  ),
);
// End of FlatButton Style

// RaisedButton Style
final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.white,
  primary: primaryColorStyle,
  textStyle: TextStyle(
    fontSize: 18,
    color: Colors.white,
  ),
  minimumSize: Size(28, 28),
  elevation: 5.0,
  padding: EdgeInsets.all(15.0),
  shape: RoundedRectangleBorder(
    borderRadius: borderRadiusStyle,
  ),
);
// End of RaisedButton Style

// Border Radius Style
final BorderRadius borderRadiusStyle = BorderRadius.all(Radius.circular(10.0));
// End of Border Radius Style

// Box Shadow Style
final BoxShadow boxShadowStyle = BoxShadow(
  color: shadowColorStyle,
  spreadRadius: 1.5,
  blurRadius: 6,
);
// End of Box Shadow Style

// Input Style
final InputDecorationTheme inputStyle = InputDecorationTheme(
  floatingLabelBehavior: FloatingLabelBehavior.never,
  isCollapsed: true,
  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20.0),
  isDense: true,
  focusColor: primaryColorStyle,
  filled: true,
  border: OutlineInputBorder(
    borderRadius: borderRadiusStyle,
    borderSide: BorderSide.none,
  ),
);
// End of Input Style

// Screen Padding Style
final EdgeInsetsGeometry screenPaddingStyle = EdgeInsets.symmetric(
  vertical: 30.0,
  horizontal: 15.0,
);

final EdgeInsetsGeometry screenPadding2Style = EdgeInsets.symmetric(
  vertical: 30.0,
);
// End of Screen Padding Style
