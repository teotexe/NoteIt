import 'dart:io';

import 'package:flutter/material.dart';
import 'package:noteit/feature_home/home_file.dart';

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
                      itemCount: (posts.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        int startIndex = index * 2;
                        int endIndex = (index * 2) + 1;
                        return Row(
                          children: [
                            Expanded(
                              flex: 0,
                              child: Container(
                                width:
                                    MediaQuery.of(context).size.width * 0.5 - 4,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(truncateText(
                                          posts[startIndex].title,
                                          10)), // Adjust the length as needed
                                      subtitle: Text(truncateText(
                                          posts[startIndex].description,
                                          30)), // Adjust the length as needed
                                    ),
                                    posts[startIndex].files.isNotEmpty
                                        ? AddFileWidget(
                                            file: File(
                                                posts[startIndex].files.first),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            if (endIndex < posts.length)
                              Expanded(
                                flex: 0,
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.5 -
                                          4,
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Column(
                                    children: [
                                      ListTile(
                                        title: Text(truncateText(
                                            posts[endIndex].title,
                                            10)), // Adjust the length as needed
                                        subtitle: Text(truncateText(
                                            posts[endIndex].description,
                                            30)), // Adjust the length as needed
                                      ),
                                      posts[endIndex].files.isNotEmpty
                                          ? AddFileWidget(
                                              file: File(
                                                  posts[endIndex].files.first),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                ),
                              ),
                          ],
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
