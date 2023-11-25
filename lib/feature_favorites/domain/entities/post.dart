import 'dart:io';

class PostEntity {
  late final String? title;
  late final String? description;
  final List<File>? _files = [];

  PostEntity({this.title, this.description, List<File>? files}) {
    if (files != null) {
      _files!.addAll(files);
    }
  }
}
