import 'dart:typed_data';
import 'package:isar/isar.dart';
import 'package:NoteIt/entities/post.dart';
part 'post.g.dart';

@collection
class PostEntity {
  Id id = Isar.autoIncrement;
  late String username;
  late String title;
  late String description;
  late List<String> files;

  PostEntity(
      {required this.title,
      required this.description,
      required this.files,
      required this.username});
}
