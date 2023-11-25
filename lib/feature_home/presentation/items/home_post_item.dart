import 'package:flutter/material.dart';
import 'package:noteit/feature_home/domain/entities/post.dart';

class PostItem extends StatelessWidget {
  PostEntity post;
  PostItem({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const CircleAvatar(
            radius: 25,
            foregroundImage: AssetImage('assets/avatar-placeholder.jpeg'),
          ),
          Text(
            post.title ?? "Post title",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ]),
        Row(
          children: [
            const Image(
              image: AssetImage('assets/note-placeholder.png'),
              width: 200,
              height: 200,
            ),
            Text(post.description ?? "Post description")
          ],
        ),
        // Carousel slider
      ],
    );
  }
}
