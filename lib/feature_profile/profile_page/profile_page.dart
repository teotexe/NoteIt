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
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: InkWell(
                      onTap: _changeProfilePicture,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            child: profilePicture.isNotEmpty
                                ? CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        FileImage(File(profilePicture)),
                                  )
                                : CircleAvatar(
                                    radius: 50, child: Icon(Icons.person)),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                          Text(
                            '${username}',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.02,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        int startIndex = index * 3;
                        int endIndex = startIndex + 2;

                        // Ensure endIndex does not exceed the length of the posts list
                        if (endIndex >= posts.length) {
                          endIndex = posts.length - 1;
                        }

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(
                            endIndex - startIndex + 1,
                            (i) {
                              int postIndex = startIndex + i;
                              return InkWell(
                                onTap: () {
                                  _viewPostDetails(posts[postIndex]);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      if (posts[postIndex].files.isNotEmpty)
                                        Image.file(
                                          File(posts[postIndex].files.first),
                                          fit: BoxFit.cover,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                        ),
                                      ListTile(
                                        title: Text(
                                          truncateText(
                                              posts[postIndex].title, 10),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Text(
                                          posts[postIndex]
                                                  .description
                                                  .isNotEmpty
                                              ? truncateText(
                                                  posts[postIndex].description,
                                                  10)
                                              : "",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                      childCount: (posts.length / 3).ceil(),
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
