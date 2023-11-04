import 'package:flutter/material.dart';
import 'package:noteit/feature_notes/domain/model/post.dart';

import 'post_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
            // Add button and move it on the left
            margin: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.06),
            child: const Icon(Icons.book),
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
              child: Center(
                child: ListView(
                  children: const [
                    PostItem(post: PostModel()),
                    PostItem(post: PostModel()),
                    PostItem(post: PostModel()),
                    PostItem(post: PostModel())
                  ],
                ),
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
