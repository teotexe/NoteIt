import 'package:noteit/core/resource.dart';
import 'package:noteit/feature_notes/domain/model/post.dart';

abstract class PostsRepository{
  Future<Resource<List<PostModel>>> getPosts();
}