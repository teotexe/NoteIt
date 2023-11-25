import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image/image.dart' as img;
import 'package:carousel_slider/carousel_slider.dart';

class HomeFileWidget extends StatelessWidget {
  final File file;

  HomeFileWidget({required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      width: double.infinity,
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
