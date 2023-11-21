import 'package:flutter/material.dart';

import 'feature_profile/presentation/pages/add_post_page.dart';
import 'feature_notes/presentation/pages/home_page.dart';
import 'feature_notes/presentation/pages/search_posts_page.dart';
import 'feature_notes/presentation/pages/home_page.dart';
import 'feature_profile/presentation/pages/add_post_page.dart';
import 'feature_profile/presentation/pages/profile_page.dart';
import 'feature_ranking/presentation/ranking_page.dart';
import 'feature_favorites/presentatiion/favorites_posts_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          // Modify the colors as per your requirement
          primaryColor: Color.fromARGB(255, 134, 11, 11), // App bar color
          primaryColorDark:
              Color.fromARGB(255, 134, 11, 11), // Status bar color
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
        ),
        home: AppState());
  }
}

class AppState extends StatefulWidget {
  @override
  _AppStateState createState() => _AppStateState();
}

class _AppStateState extends State<AppState> {
  int _currentIndex = 0; // Track the current index of the bottom navigation bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getBody(
          _currentIndex), // Add this line to display the corresponding body based on the selected tab

      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle navigation when a bottom navigation bar item is tapped
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Search posts'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events), label: 'Ranking'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: "Favorite"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // Function to return the corresponding body based on the selected tab
  Widget _getBody(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return HomePage();
      case 1:
        return SearchPage();
      case 2:
        return RankingPage();
      case 3:
        return FavoritesPage();
      case 4:
        return ProfilePage();
      default:
        return Container();
    }
  }
}
