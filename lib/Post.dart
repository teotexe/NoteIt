import 'package:flutter/material.dart';

class Post extends StatelessWidget {
  const Post({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(radius: 25, foregroundImage: AssetImage('assets/avatar-placeholder.jpeg'),),
            Text("Post title", style: TextStyle(fontWeight: FontWeight.bold),),
            ]
        ),
        Row(
          children: [
            Image(image: AssetImage('assets/note-placeholder.png'), width: 200, height: 200,),
            Text("Post description")
          ],
        )

      ],
    );
  }
}