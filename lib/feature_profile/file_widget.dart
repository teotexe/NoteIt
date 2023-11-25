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
  final File file;

  AddFileWidget({required this.file});

  bool isImage(File file) {
    try {
      // Attempt to decode the file as an image
      final image = img.decodeImage(file.readAsBytesSync());
      return image != null; // Check if decoding was successful
    } catch (e) {
      // Decoding failed, not an image
      return false;
    }
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FullScreenImage(file: file),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isImage(file)
        ? GestureDetector(
            onTap: () => _showFullScreenImage(context),
            child: Image.file(
              file,
              height: 200.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
        : Container(
            height: 200.0,
            width: double.infinity,
            color: Colors.grey[300],
            child: Center(
              child: Text(
                file.path.split('/').last,
                style: TextStyle(fontSize: 16.0),
              ),
              // Download icon
            ),
          );
  }
}

class FullScreenImage extends StatelessWidget {
  final File file;

  FullScreenImage({required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: PhotoViewGallery(
            pageController: PageController(),
            scrollPhysics: BouncingScrollPhysics(),
            backgroundDecoration: BoxDecoration(
              color: Colors.black,
            ),
            pageOptions: [
              PhotoViewGalleryPageOptions(
                imageProvider: FileImage(file),
                minScale: PhotoViewComputedScale.contained,
                maxScale: PhotoViewComputedScale.covered * 2,
              ),
            ],
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
