import 'package:trops_app/core/entity/auth_result.dart';
import 'package:trops_app/data/mapper/user_mapper.dart';

class AuthResultMapper {
  AuthResult map(Map json) {
    return AuthResult(
      user: UserMapper().map(json['user'], parseFavorites: true),
      token: _parseToken(json),
      isAuthenticated: true,
      error: null,
    );
  }

  static String _parseToken(Map json) {
    return json['token'];
  }
}