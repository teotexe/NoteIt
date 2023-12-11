import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:carousel_slider/carousel_slider.dart';

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
    return CarouselSlider(
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height * 0.2,
        aspectRatio: 1.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
      items: files
          .map(
            (file) => isImage(file)
                ? GestureDetector(
                    onTap: () => _showFullScreenImage(
                        context, file, files.indexOf(file)),
                    child: Image.file(
                      file,
                      fit: BoxFit.cover,
                    ),
                  )
                : GestureDetector(
                    onTap: () => _showFullScreenImage(
                        context, file, files.indexOf(file)),
                    child: Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          file.path.split('/').last,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ),
                  ),
          )
          .toList(),
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

              if (isImage(currentFile)) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: FileImage(currentFile),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              } else {
                // Handle non-image files by returning a placeholder
                return PhotoViewGalleryPageOptions.customChild(
                  child: Container(
                    color: Colors.grey[300],
                    child: Center(
                      child: Text(
                        currentFile.path.split('/').last,
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                );
              }
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

bool isImage(File file) {
  try {
    final image = img.decodeImage(file.readAsBytesSync());
    return image != null;
  } catch (e) {
    return false;
  }
}
