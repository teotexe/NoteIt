import 'package:isar/isar.dart';
import 'package:noteit/entities/post.dart';
import 'package:path_provider/path_provider.dart';
import '../entities/credentials.dart';

class IsarService {
  late Future<Isar> isar;

  IsarService() {
    isar = openDB();
  }

  static Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open([PostEntitySchema, CredentialsSchema],
        directory: dir.path);
  }

  Future<void> cleanDB() async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.postEntitys.where().deleteAll();
      await isar.credentials.where().deleteAll();
    });
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

  // Save credentials
  Future<void> saveCredentials(Credentials credentials) async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.credentials.put(credentials);
    });
  }

  // Delete credentials
  Future<void> deleteCredentials(int Id) async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.credentials.delete(Id);
    });
  }

  // Get credentials
  Future<Credentials?> getCredentials(int Id) async {
    final isar = await this.isar;
    return isar.credentials.get(Id);
  }

  // Get All credentials
  Future<List<Credentials>> getAllCredentials() async {
    final isar = await this.isar;
    return isar.credentials.where().findAll();
  }
}
