import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image/image.dart' as img;

class AddFileWidget extends StatelessWidget {
  final List<File> files;

  AddFileWidget({required this.files});

  void _showFullScreenImage(BuildContext context, File file, int index) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            FullScreenImage(allFiles: files, initialIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider.builder(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.2,
        aspectRatio: 1.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
      itemCount: files.length,
      itemBuilder: (BuildContext context, int index, _) {
        final file = files[index];
        return GestureDetector(
          onTap: () => _showFullScreenImage(context, file, index),
          child: FutureBuilder<bool>(
            future: isImage(file),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data!) {
                return Image.file(
                  file,
                  fit: BoxFit.cover,
                );
              } else {
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Text(
                      file.path.split('/').last,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final List<File> allFiles;
  final int initialIndex;

  FullScreenImage({required this.allFiles, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: PhotoViewGallery.builder(
            itemCount: allFiles.length,
            builder: (context, index) {
              final currentFile = allFiles[index];
              return PhotoViewGalleryPageOptions(
                imageProvider: FileImage(currentFile),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              );
            },
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            pageController: PageController(initialPage: initialIndex),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back),
      ),
    );
  }
}

Future<bool> isImage(File file) async {
  try {
    final image = img.decodeImage(await file.readAsBytes());
    return image != null;
  } catch (e) {
    return false;
  }
}
