import 'package:flutter/material.dart';
import 'config/theme/app_theme.dart';
import 'entities/user.dart';
import 'feature_home/home_page.dart';
import 'feature_login/login_page.dart';
import 'feature_search/search_page.dart';
import 'feature_profile/newpost_page/add_post_page.dart';
import 'feature_profile/profile_page/profile_page.dart';
import 'feature_ranking/presentation/ranking_page.dart';
import 'feature_favorites/favorites_page.dart';
import 'package:NoteIt/core/constants/constants.dart';
import 'local/isar_service.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // credentialsList = [];
  // isarService.cleanDB();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.getTheme(),
      home: LoginPage(),
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
