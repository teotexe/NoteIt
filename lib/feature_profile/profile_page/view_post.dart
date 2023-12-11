import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:NoteIt/entities/post.dart';
import 'package:NoteIt/config/theme/app_theme.dart';
import 'package:NoteIt/feature_profile/profile_page/post_file_widget.dart';

import '../../core/constants/constants.dart';

class ViewPostPage extends StatelessWidget {
  final PostEntity post;

  ViewPostPage({required this.post});

  void _copyToClipboard(BuildContext context, String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Description copied to clipboard'),
      ),
    );
  }

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to remove this post?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _removePost(context);
                Navigator.of(context).pop();
              },
              child: Text('Remove'),
            ),
          ],
        );
      },
    );
  }

  void _removePost(BuildContext context) {
    isarService.deletePost(post.id);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          post.title,
          style: TextStyle(
            color: AppTheme.myCustomColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.content_copy),
            onPressed: () => _copyToClipboard(context, post.description),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20.0),
              child: Text(
                post.description,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            SizedBox(height: 10.0),
            post.files.isNotEmpty
                ? AddFileWidget(files: post.files.map((e) => File(e)).toList())
                : Container(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showConfirmationDialog(context),
        tooltip: 'Remove Post',
        child: Icon(Icons.delete),
      ),
    );
  }
}
