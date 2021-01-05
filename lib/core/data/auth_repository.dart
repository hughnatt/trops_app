import 'package:trops_app/core/entity/auth_result.dart';

abstract class AuthRepository {
  Future<AuthResult> register(String name, String email, String password, String phone);
  Future<AuthResult> login(String email, String password);
  Future<void> signOff();
  Future<AuthResult> getSession(String token);
  Future<AuthResult> socialLoginWithGoogle(String googleToken);
}