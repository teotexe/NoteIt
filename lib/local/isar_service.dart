import 'dart:io';
import 'package:isar/isar.dart';
import 'package:NoteIt/core/constants/constants.dart';
import 'package:NoteIt/entities/post.dart';
import 'package:path_provider/path_provider.dart';
import '../entities/user.dart';

class IsarService {
  late Future<Isar> isar;

  IsarService() {
    isar = openDB();
  }

  static Future<Isar> openDB() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open([PostEntitySchema, UserEntitySchema], directory: dir.path);
  }

  Future<void> cleanDB() async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.postEntitys.where().deleteAll();
      await isar.userEntitys.where().deleteAll();
    });
  }

  Future<UserEntity?> getUser() async {
    final isar = await this.isar;
    UserEntity? user = await isar.userEntitys
        .where()
        .filter()
        .usernameEqualTo(username)
        .passwordEqualTo(password)
        .findFirst();
    return user;
  }

  Future<void> addPost(PostEntity post) async {
    final isar = await this.isar;

    UserEntity? user = await getUser();

    if (user != null) {
      await isar.writeTxn(() async {
        await isar.postEntitys.put(post);
        user.posts.add(post);
        await isar.userEntitys.put(user);
      });
    }
  }

  Future<void> deletePost(int Id) async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.postEntitys.delete(Id);
    });
  }

  Future<List<PostEntity>> getUserPosts() async {
    final isar = await this.isar;
    UserEntity? user = await getUser();

    if (user != null) {
      return isar.postEntitys
          .where()
          .filter()
          .usernameEqualTo(username)
          .findAll();
    } else {
      return isar.postEntitys.where().findAll();
    }
  }

  // Get all posts
  Future<List<PostEntity>> getAllPosts() async {
    final isar = await this.isar;
    return isar.postEntitys.where().findAll();
  }

  // Save credentials
  Future<void> saveCredentials(UserEntity credentials) async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      credentials.posts = IsarLinks<PostEntity>();
      await isar.userEntitys.put(credentials);
    });
  }

  // Delete credentials
  Future<void> deleteCredentials(int Id) async {
    final isar = await this.isar;
    // Remove all posts from user
    UserEntity? user = await getUser();
    if (user != null) {
      await isar.writeTxn(() async {
        await isar.postEntitys
            .where()
            .filter()
            .usernameEqualTo(username)
            .deleteAll();
      });

      await isar.writeTxn(() async {
        await isar.userEntitys.delete(Id);
      });
    }
  }

  // Get credentials
  Future<UserEntity?> getCredentials(int Id) async {
    final isar = await this.isar;
    return isar.userEntitys.get(Id);
  }

  // Get All credentials
  Future<List<UserEntity>> getAllCredentials() async {
    final isar = await this.isar;
    return isar.userEntitys.where().findAll();
  }

  // Update credentials
  Future<void> updateCredentials(UserEntity credentials) async {
    final isar = await this.isar;
    await isar.writeTxn(() async {
      await isar.userEntitys.put(credentials);
    });
  }

  // Update profile photo
  Future<void> updateProfilePhoto(File newPhoto) async {
    final isar = await this.isar;
    UserEntity? user = await getUser();

    if (user != null) {
      await isar.writeTxn(() async {
        // Save the new profile photo path or URL to the user entity
        user.profilePicture =
            newPhoto.path; // Replace with the appropriate field in UserEntity

        await isar.userEntitys.put(user);
      });
    }
  }

  // Verify credentials
  Future<bool> verifyCredentials(String username, String password) async {
    final isar = await this.isar;
    List<UserEntity> credentialsList = await isar.userEntitys
        .where()
        .filter()
        .usernameEqualTo(username)
        .passwordEqualTo(password)
        .findAll();
    return credentialsList.isNotEmpty;
  }
}
