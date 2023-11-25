import 'dart:io';

class PostEntity {
  final String? title;
  final String? description;
  final List<File>? _files = [];

  PostEntity({this.title, this.description, List<File>? files}) {
    if (files != null) {
      _files!.addAll(files);
    }
  }
}
