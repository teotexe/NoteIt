import 'dart:io';

class PostModel {
  final String? title;
  final String? description;
  final List<File>? _files = [];

  PostModel({this.title, this.description, List<File>? files}) {
    if (files != null) {
      _files!.addAll(files);
    }
  }
}
