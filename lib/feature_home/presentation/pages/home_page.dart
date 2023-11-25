import 'package:flutter/material.dart';
import 'package:noteit/feature_home/domain/entities/post.dart';
import 'package:noteit/feature_home/presentation/items/home_post_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[300],
                child: Center(
                  child: ListView(
                    children: [
                      PostItem(post: PostEntity()),
                      PostItem(post: PostEntity()),
                      PostItem(post: PostEntity()),
                      PostItem(post: PostEntity())
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
