import 'package:trops_app/core/entity/user.dart';

abstract class UserRepository {
  Future<User> getUser(String uid);
  Future<void> modifyPassword(String password);
  Future<void> modifyUser(String field, String value);
}






