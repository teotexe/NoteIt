import 'dart:io';
import "package:NoteIt/feature_home/view_post.dart";
import 'package:flutter/material.dart';
import 'package:NoteIt/feature_home/home_file.dart';
import '../config/theme/app_theme.dart';
import '../core/constants/constants.dart';
import '../entities/post.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    postsFuture = isarService.getAllPosts();
  }

  Future<void> _refresh() async {
    setState(() {
      postsFuture = isarService.getAllPosts();
    });
  }

  void _viewPostDetails(PostEntity post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPostPage(post: post),
      ),
    );
  }

  String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    }
    return '${text.substring(0, maxLength)}...';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        color: AppTheme.getTheme().primaryColor,
        onRefresh: _refresh,
        child: FutureBuilder<List<PostEntity>>(
          future: postsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text('No posts available.'),
              );
            } else {
              List<PostEntity> posts = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                  Expanded(
                    child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        PostEntity post = posts[index];
                        String firstPhoto =
                            post.files.isNotEmpty ? post.files.first : '';
                        return InkWell(
                          onTap: () {
                            _viewPostDetails(post);
                          },
                          child: Card(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (firstPhoto.isNotEmpty)
                                  Image.file(
                                    File(firstPhoto),
                                    fit: BoxFit.cover,
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                  ),
                                ListTile(
                                  title: Text(
                                    truncateText(post.title, 10),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    truncateText(post.description, 10),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
