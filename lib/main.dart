import 'package:flutter/material.dart';

import 'feature_notes/presentation/add_post_page.dart';
import 'feature_notes/presentation/home_page.dart';
import 'feature_notes/presentation/search_posts_page.dart';
import 'feature_profile/presentation/profile_page.dart';
import 'feature_ranking/presentation/ranking_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AppState(),
      routes: {
        '/profile': (context) => ProfilePage(),
        '/addPost': (context) => AddPost(),
        '/ranking': (context) => RankingPage(),
        '/savedPosts': (context) => Placeholder(),

      },
    );
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
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search posts'),
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Ranking'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Favorite"),
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
        return Placeholder();
      case 4:
        return ProfilePage();
      default:
        return Container();
    }
  }
}