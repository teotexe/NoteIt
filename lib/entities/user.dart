import 'package:isar/isar.dart';
import 'package:noteit/entities/post.dart';
part 'user.g.dart';

@collection
class UserEntity {
  Id id = Isar.autoIncrement;
  String username = '';
  String password = '';
  String profilePicture = '';

  // Link to a list of posts
  IsarLinks<PostEntity> posts = IsarLinks<PostEntity>();

  UserEntity(this.username, this.password, this.profilePicture)
      : posts = IsarLinks<PostEntity>();
}
