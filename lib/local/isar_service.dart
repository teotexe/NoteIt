import 'package:isar/isar.dart';
import 'package:noteit/entities/post.dart';
import 'package:path_provider/path_provider.dart';

class IsarService {
  late Future<Isar> isar;

  IsarService() {
    isar = openDB();
  }

  static Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open([PostEntitySchema], directory: dir.path);
  }

  Future<void> addPost(PostEntity post) async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.postEntitys.put(post);
    });
  }

  Future<List<PostEntity>> getPosts() async {
    final isar = await this.isar;
    return isar.postEntitys.where().findAll();
  }

  Stream<List<PostEntity>> getPostsStream() {
    final isar = this.isar;
    return isar.asStream().map((isar) {
      return isar.postEntitys.where().findAllSync();
    });
  }

  Future<void> deletePost(PostEntity post) async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.postEntitys.delete(post.id);
    });
  }

  Future<void> updatePost(PostEntity post) async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.postEntitys.put(post);
    });
  }

  Future<void> deleteAllPosts() async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.postEntitys.where().deleteAll();
    });
  }
}
