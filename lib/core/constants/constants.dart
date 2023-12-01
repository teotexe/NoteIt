import 'package:isar/isar.dart';
import 'package:noteit/local/isar_service.dart';
import '../../entities/post.dart';
import '../../entities/user.dart';

final IsarService isarService = IsarService();

late Future<List<PostEntity>> postsFuture;

// Credentials
String username = '';
String password = '';
String profilePicture = '';

// List of all credentials
List<UserEntity> credentialsList = [];
