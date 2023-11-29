import 'package:isar/isar.dart';
import 'package:noteit/local/isar_service.dart';
import '../../entities/credentials.dart';

final IsarService isarService = IsarService();

// Credentials
String username = '';
String password = '';

// List of all credentials
List<Credentials> credentialsList = [];
