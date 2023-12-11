import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:NoteIt/config/theme/app_theme.dart';
import 'package:NoteIt/entities/post.dart';
import 'package:NoteIt/core/constants/constants.dart';
import 'package:NoteIt/feature_profile/profile_page/view_post.dart';
import 'package:NoteIt/main.dart';
import '../../entities/user.dart';
import '../../feature_login/login_page.dart';
import '../newpost_page/add_post_page.dart';
import 'profile_file.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> _refresh() async {
    setState(() {
      userPostsFuture = isarService.getUserPosts();
    });
  }

  void _changeProfilePicture() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
    );

    if (result != null) {
      File file = File(result.files.single.path!);

      // Update credentials
      UserEntity credentials = UserEntity(username, password, file.path);
      await isarService.saveCredentials(credentials);

      setState(() {
        profilePicture = file.path;
      });
    }
  }

  void _viewPostDetails(PostEntity post) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewPostPage(post: post),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    userPostsFuture = isarService.getUserPosts();
  }

  void _logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
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
      appBar: AppBar(
        title: const Text('Profile Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: _logout,
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.getTheme().primaryColor,
        onRefresh: _refresh,
        child: FutureBuilder<List<PostEntity>>(
          future: userPostsFuture,
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
                    child: InkWell(
                      onTap: _changeProfilePicture,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          profilePicture.isNotEmpty
                              ? CircleAvatar(
                                  radius: 50,
                                  backgroundImage:
                                      FileImage(File(profilePicture)),
                                )
                              : CircleAvatar(
                                  radius: 50, child: Icon(Icons.person)),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Text(
                            '${username}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
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
                                width:
                                    MediaQuery.of(context).size.width * 0.5 - 4,
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                child: Column(
                                  children: [
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
