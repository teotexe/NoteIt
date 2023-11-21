import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:noteit/feature_profile/presentation/items/add_file_item.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:file_picker/file_picker.dart';

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
    return Theme(
        data: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            elevation: 0,
            iconTheme: IconThemeData(color: Color.fromARGB(255, 134, 11, 11)),
            toolbarHeight: 100,
          ),
          scaffoldBackgroundColor: Colors.white,
        ),
        child: Scaffold(
          appBar: AppBar(
            actions: [
              IconButton(
                onPressed: () {
                  addFile();
                },
                icon: Transform.translate(
                  offset: Offset(-20.0,
                      0.0), // Adjust the offset to move the icon horizontally
                  child: Transform.rotate(
                    angle: 30 *
                        3.14159265359 /
                        180, // Rotate the icon by 45 degrees (in radians)
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
                // Leave some space (Proportional to screen size)
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                _files.isNotEmpty
                    ? CarouselSlider(
                        items: _files.map((file) {
                          return AddFileWidget(file: file);
                        }).toList(),
                        options: CarouselOptions(
                          height: 200.0,
                          enlargeCenterPage: true,
                          enableInfiniteScroll: false,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ));
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
