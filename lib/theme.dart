import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Theme and Style
import 'package:getfood_project/style.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _selectedTheme;

  // Light Theme
  ThemeData light = ThemeData.light().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColorStyle,
    ),
    iconTheme: IconThemeData(color: iconColorStyle),
    primaryColor: primaryColorStyle,
    cardColor: secondaryContainerColorStyle,
    cardTheme: CardTheme(
      color: secondaryContainerColorStyle,
      shape: RoundedRectangleBorder(borderRadius: borderRadiusStyle),
    ),
    scaffoldBackgroundColor: primaryContainerColorStyle,
    textButtonTheme: TextButtonThemeData(style: flatButtonStyle),
    elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
    inputDecorationTheme: inputStyle.copyWith(
      fillColor: secondaryContainerColorStyle,
      hintStyle: TextStyle(
        color: textColor2Style,
        fontWeight: FontWeight.normal,
      ),
      labelStyle: TextStyle(
        color: textColor2Style,
        fontWeight: FontWeight.normal,
      ),
    ),
    textTheme: TextTheme(
      headline1: heading1Style,
      headline2: heading2Light,
      headline3: heading3Light,
      headline4: heading4Light,
      headline6: TextStyle(color: Colors.black),
      bodyText1: paragraph1Style,
      bodyText2: paragraph2Style,
      subtitle1: TextStyle(
        color: Colors.black,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: complementaryColorStyle,
      selectionHandleColor: primaryColorStyle,
    ),
  );
  // End of Light Theme

  // Dark Theme
  ThemeData dark = ThemeData.dark().copyWith(
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
    ),
    iconTheme: IconThemeData(color: textColor4Style),
    primaryColor: primaryColorStyle,
    cardColor: Colors.grey[800],
    cardTheme: CardTheme(
      color: Colors.grey[800],
      shape: RoundedRectangleBorder(borderRadius: borderRadiusStyle),
    ),
    textButtonTheme: TextButtonThemeData(style: flatButtonStyle),
    elevatedButtonTheme: ElevatedButtonThemeData(style: raisedButtonStyle),
    inputDecorationTheme: inputStyle.copyWith(
      fillColor: Colors.grey[800],
      hintStyle: TextStyle(
        color: textColor4Style,
        fontWeight: FontWeight.normal,
      ),
      labelStyle: TextStyle(
        color: textColor4Style,
        fontWeight: FontWeight.normal,
      ),
    ),
    textTheme: TextTheme(
      headline1: heading1Style.copyWith(color: textColor3Style),
      headline2: heading2Dark,
      headline3: heading3Dark,
      headline4: heading4Dark,
      headline6: TextStyle(color: Colors.white),
      bodyText1: paragraph1Style.copyWith(color: textColor4Style),
      bodyText2: paragraph2Style.copyWith(color: textColor4Style),
      subtitle1: TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: complementaryColorStyle,
      selectionHandleColor: primaryColorStyle,
    ),
  );
  // End of Dark Theme

  ThemeProvider({bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark : light;
  }

  // Swap Theme Function
  void swapTheme() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    _selectedTheme = _selectedTheme == dark ? light : dark;
    // Check selected theme
    if (_selectedTheme == dark) {
      sp.setBool('isDarkMode', true);
    } else {
      sp.setBool('isDarkMode', false);
    }
    notifyListeners();
  }
  // End of Swap Theme Function

  // Get Theme
  ThemeData get getTheme => _selectedTheme;
}
