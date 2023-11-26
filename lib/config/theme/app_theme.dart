// theme.dart

import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData getTheme() {
    return ThemeData(
      // Modify the colors as per your requirement
      primaryColor: Color.fromARGB(255, 134, 11, 11), // App bar color
      primaryColorDark: Color.fromARGB(255, 134, 11, 11), // Status bar color
      hintColor:
          Color.fromARGB(255, 134, 11, 11), // Floating action button color
      scaffoldBackgroundColor: Colors.white, // Background color
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
        buttonColor: Color.fromARGB(255, 134, 11, 11), // Button color
        textTheme: ButtonTextTheme.primary, // Button text color
      ),
      iconTheme: const IconThemeData(
        color: Color.fromARGB(255, 134, 11, 11), // Icon color
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color.fromARGB(255, 134, 11, 11), // FAB color
      ),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
        iconColor: MaterialStateColor.resolveWith(
            (states) => Color.fromARGB(255, 134, 11, 11)),
      )),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Color.fromARGB(255, 134, 11, 11),
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
