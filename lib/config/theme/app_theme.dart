import 'package:flutter/material.dart';

class AppTheme {
  static Color myCustomColor = Color.fromARGB(255, 134, 11, 11);

  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: myCustomColor,
      primaryColorDark: myCustomColor,
      hintColor: myCustomColor,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        backgroundColor: Colors.white,
        indicatorColor: Colors.black,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: myCustomColor,
        textTheme: ButtonTextTheme.primary,
        colorScheme: ColorScheme.light(primary: Colors.white),
      ),
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 134, 11, 11),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 134, 11, 11),
        foregroundColor: Colors.white, // Setting text color for FAB to white
      ),
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: MaterialStateColor.resolveWith(
            (states) => myCustomColor,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateColor.resolveWith(
            (states) => myCustomColor,
          ),
          // Setting text color for elevated buttons to white
          foregroundColor: MaterialStateColor.resolveWith(
            (states) => Colors.white,
          ),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: myCustomColor,
        unselectedItemColor: Colors.grey,
      ),
      inputDecorationTheme: InputDecorationTheme(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: myCustomColor),
        ),
      ),
      textTheme: TextTheme(
        button: TextStyle(color: myCustomColor),
        headline6: TextStyle(color: myCustomColor),
        bodyText2: TextStyle(color: myCustomColor),
      ),
    );
  }
}
