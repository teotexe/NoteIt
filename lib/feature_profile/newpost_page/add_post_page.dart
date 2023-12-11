import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:NoteIt/feature_profile/newpost_page/file_widget.dart';
import 'package:NoteIt/feature_profile/profile_page/profile_page.dart';
import 'package:NoteIt/entities/post.dart';
import 'package:NoteIt/core/constants/constants.dart';
import 'package:NoteIt/main.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';
import '../../config/theme/app_theme.dart';

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  String _title = '';
  String _body = '';
  List<File> _files = [];

  @override
  Widget build(BuildContext context) {
    ThemeData combinedTheme = Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color.fromARGB(255, 134, 11, 11)),
        toolbarHeight: 100,
      ),
      scaffoldBackgroundColor: Colors.white,

      // Merge AppTheme properties
      primaryColor: AppTheme.myCustomColor,
      primaryColorDark: AppTheme.myCustomColor,
      hintColor: AppTheme.myCustomColor,
    );

    return Theme(
      data: combinedTheme,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                addFile();
              },
              icon: Transform.translate(
                offset: Offset(-20.0, 0.0),
                child: Transform.rotate(
                  angle: 30 * 3.14159265359 / 180,
                  child: const Icon(Icons.attach_file),
                ),
              ),
              iconSize: 62,
            ),
          ],
          title: Text('Add Post'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  style: const TextStyle(fontSize: 48),
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
                  maxLines: null,
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
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                AddFileWidget(files: _files),
                ElevatedButton(
                  onPressed: () {
                    if (_title.isEmpty && _body.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please fill in at least one field'),
                        ),
                      );
                      return;
                    }
                    PostEntity post = PostEntity(
                      username: username,
                      title: _title,
                      description: _body,
                      files: _files.map((file) => file.path).toList(),
                    );
                    isarService.addPost(post);
                    Navigator.pop(context);
                  },
                  child: const Text('Aggiungi'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future addFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _files.addAll(result.paths.map((path) => File(path!)));
      });
    } else {
      // User canceled the picker
    }
  }
}
