import 'package:flutter/material.dart';
import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class AddFileWidget extends StatelessWidget {
  final List<String> files;

  AddFileWidget({required this.files});

  void _showFullScreenImage(BuildContext context, String file, int index) {
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
        height: 200.0,
        aspectRatio: 2.0,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
      ),
      items: files
          .map(
            (file) => GestureDetector(
              onTap: () =>
                  _showFullScreenImage(context, file, files.indexOf(file)),
              child: FutureBuilder<bool>(
                future: isImage(file),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data!) {
                    return Image.file(
                      File(file), // Convert file path to File object
                      fit: BoxFit.cover,
                    );
                  } else {
                    return Container(
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          file.split('/').last, // Extract file name from path
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          )
          .toList(),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final List<String> allFiles;
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
                imageProvider: FileImage(
                    File(currentFile)), // Convert file path to File object
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

Future<bool> isImage(String file) async {
  try {
    final bytes =
        await File(file).readAsBytes(); // Convert file path to File object
    final image = await decodeImageFromList(bytes);
    return image != null;
  } catch (e) {
    return false;
  }
}
