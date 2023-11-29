import 'package:isar/isar.dart';
part 'credentials.g.dart';

@collection
class Credentials {
  Id id = Isar.autoIncrement;
  String username = '';
  String password = '';

  Credentials(this.username, this.password);
}
