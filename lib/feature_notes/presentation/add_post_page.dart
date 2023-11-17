import 'package:flutter/material.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String _title = '';
  String _body = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {
            // Add attach logic
          }, icon: const Icon(Icons.attach_file))
        ],
        title: Text('Add Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              style: const TextStyle(fontSize: 48),
              // Set text style to match hint style
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                hintText: 'Titolo',
                hintStyle: TextStyle(fontSize: 48),
              ),
              onChanged: (value) {
                setState(() {
                  _title = value;
                });
              },
            ),
            TextFormField(
              style: const TextStyle(fontSize: 24),
              // Set text style to match hint style
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                hintText: 'Scrivi qualcosa',
                hintStyle: TextStyle(fontSize: 24),
              ),
              onChanged: (value) {
                setState(() {
                  _body = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
