import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:noteit/config/theme/app_theme.dart';
import 'package:noteit/entities/post.dart';
import 'package:noteit/core/constants/constants.dart';
import 'package:noteit/main.dart';
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
      postsFuture = isarService.getPosts();
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

  @override
  void initState() {
    super.initState();
    postsFuture = isarService.getPosts();
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
                    child: InkWell(
                      onTap: _changeProfilePicture,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(File(profilePicture)),
                          ),
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
