import 'package:noteit/core/resource.dart';
import 'package:noteit/feature_notes/domain/model/post.dart';
import 'package:noteit/feature_notes/domain/repository/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {

  @override
  Future<Resource<List<PostModel>>> getPosts() {
    // TODO: implement getPosts
    throw UnimplementedError();
  }

}