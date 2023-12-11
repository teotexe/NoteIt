import 'dart:io';
import "package:noteit/feature_home/view_post.dart";
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
                                    Text(
                                      posts[startIndex].username,
                                      style: TextStyle(
                                        color: AppTheme.getTheme().primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    ListTile(
                                      title: InkWell(
                                        onTap: () {
                                          _viewPostDetails(posts[startIndex]);
                                        },
                                        child: Text(
                                          truncateText(
                                              posts[startIndex].title, 10),
                                        ),
                                      ),
                                      subtitle: InkWell(
                                        onTap: () {
                                          _viewPostDetails(posts[startIndex]);
                                        },
                                        child: Text(
                                          posts[startIndex].files.isNotEmpty
                                              ? truncateText(
                                                  posts[startIndex].description,
                                                  10)
                                              : "",
                                        ),
                                      ),
                                    ),
                                    posts[startIndex].files.isNotEmpty
                                        ? AddFileWidget(
                                            files: posts[startIndex]
                                                .files
                                                .map((e) => File(e))
                                                .toList())
                                        : InkWell(
                                            onTap: () {
                                              _viewPostDetails(
                                                  posts[startIndex]);
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(truncateText(
                                                  posts[startIndex].description,
                                                  300)),
                                            ),
                                          )
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
                                      Text(
                                        posts[endIndex].username,
                                        style: TextStyle(
                                          color:
                                              AppTheme.getTheme().primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      ListTile(
                                        title: InkWell(
                                          onTap: () {
                                            _viewPostDetails(posts[endIndex]);
                                          },
                                          child: Text(
                                            truncateText(
                                                posts[endIndex].title, 10),
                                          ),
                                        ), // Adjust the length as needed
                                        subtitle: Text(
                                          posts[startIndex].files.isNotEmpty
                                              ? truncateText(
                                                  posts[endIndex].description,
                                                  10)
                                              : "",
                                        ),
                                      ),
                                      posts[endIndex].files.isNotEmpty
                                          ? AddFileWidget(
                                              files: posts[endIndex]
                                                  .files
                                                  .map((e) => File(e))
                                                  .toList())
                                          : InkWell(
                                              onTap: () {
                                                _viewPostDetails(
                                                    posts[endIndex]);
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(10.0),
                                                child: Text(truncateText(
                                                    posts[endIndex].description,
                                                    300)),
                                              ),
                                            )
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
