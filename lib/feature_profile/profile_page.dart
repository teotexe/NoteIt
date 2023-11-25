import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:noteit/entities/post.dart';
import 'package:noteit/main.dart';
import 'add_post_page.dart';
import 'profile_file.dart';

late Future<List<PostEntity>> postsFuture;

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    postsFuture = isarService.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
      ),
      body: FutureBuilder<List<PostEntity>>(
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
                // Top part for profile name and photo
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        // Add profile photo logic here
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.04),
                      Text(
                        'Profile Name',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
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
                              width: MediaQuery.of(context).size.width *
                                  0.5, // Set fixed size to half the screen width
                              child: Column(
                                children: [
                                  ListTile(
                                    title: Text(posts[startIndex].title),
                                    subtitle:
                                        Text(posts[startIndex].description),
                                  ),
                                  posts[startIndex].files.isNotEmpty
                                      ? CarouselSlider(
                                          items: posts[startIndex]
                                              .files
                                              .map((file) {
                                            return AddFileWidget(
                                                file: File(file));
                                          }).toList(),
                                          options: CarouselOptions(
                                            viewportFraction: 0.5,
                                            enableInfiniteScroll: false,
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          if (endIndex < posts.length)
                            Expanded(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(posts[endIndex].title),
                                      subtitle:
                                          Text(posts[endIndex].description),
                                    ),
                                    posts[endIndex].files.isNotEmpty
                                        ? CarouselSlider(
                                            items: posts[endIndex]
                                                .files
                                                .map((file) {
                                              return AddFileWidget(
                                                  file: File(file));
                                            }).toList(),
                                            options: CarouselOptions(
                                              viewportFraction: 0.5,
                                              enableInfiniteScroll: false,
                                            ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPost()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
