import 'package:noteit/core/resources/data_state.dart';
import 'package:noteit/feature_home/domain/entities/post.dart';

abstract class PostsRepository{
  Future<Resource<List<PostEntity>>> getPosts();
}