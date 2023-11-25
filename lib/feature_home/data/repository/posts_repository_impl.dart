import 'package:noteit/core/resources/data_state.dart';
import 'package:noteit/feature_home/domain/entities/post.dart';
import 'package:noteit/feature_home/domain/repository/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  @override
  Future<Resource<List<PostEntity>>> getPosts() {
    // TODO: implement getPosts
    throw UnimplementedError();
  }
}
