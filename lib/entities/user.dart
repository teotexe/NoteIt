import 'dart:io';
import 'package:isar/isar.dart';
import 'post.dart';

class UserEntity {
  Id id = Isar.autoIncrement;
  late String username;
}
