import 'package:trops_app/core/entity/user.dart';
import 'package:trops_app/data/token_provider.dart';

abstract class SessionRepository extends TokenProvider {
  void restoreCurrentUser();
  void saveToken(String token);
  void forgetToken();
  User currentUser();
  void setCurrentUser(User user);
  bool isAuthenticated();
  void setAuthenticated(bool isAuthenticated);
}