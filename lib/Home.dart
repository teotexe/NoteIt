import 'package:flutter/material.dart';
import 'Profile.dart';
import 'AddPost.dart';
import 'Ranking.dart';

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
        '/ranking': (context) => Ranking(),
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
        currentIndex: _currentIndex,
        onTap: (index) {
          // Handle navigation when a bottom navigation bar item is tapped
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Post'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // Function to return the corresponding body based on the selected tab
  Widget _getBody(int currentIndex) {
    switch (currentIndex) {
      case 0:
        // Return the home page body
        return HomePage();
      case 1:
        // Return the add post page body
        return AddPost();
      case 2:
        // Return the profile page body
        return ProfilePage();
      default:
        return Container();
    }
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            // Add button and move it on the left
            margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.06),
            child: Icon(Icons.book),
          ),
          Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.only(
                  right: MediaQuery.of(context).size.width * 0.02),
              child: TextField(
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  contentPadding: EdgeInsets.all(16),
                ),
                // On submit, navigate
                onSubmitted: (value) {},
              )),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.grey[300],
              child: const Center(
                child: Text('Home content goes here'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/ranking');
        },
        child: const Icon(Icons.emoji_events),
      ),
    );
  }
}
