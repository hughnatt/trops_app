import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trops_app/core/data/auth_repository.dart';
import 'package:trops_app/core/data/session_repository.dart';
import 'package:trops_app/core/entity/auth_result.dart';

abstract class AuthInteractor {
  Future<void> register(String name, String email, String password, String phone);
  Future<void> login(String email, String password);
  Future<void> signOff();
  Future<void> googleLogin();
}

class AuthInteractorImpl implements AuthInteractor {

  SessionRepository _sessionRepository;
  AuthRepository _authRepository;
  GoogleSignIn _googleSignIn;

  AuthInteractorImpl({
    @required AuthRepository authRepository,
    @required SessionRepository sessionRepository,
    @required GoogleSignIn googleSignIn
  }) {
    _authRepository = authRepository;
    _sessionRepository = sessionRepository;
    _googleSignIn = googleSignIn;
  }

  @override
  Future<void> register(String name, String email, String password, String phone) async {
    try {
      AuthResult authResult = await _authRepository.register(name, email, password, phone);
      _sessionRepository.setCurrentUser(authResult.user);
      _sessionRepository.saveToken(authResult.token);
      _sessionRepository.setAuthenticated(authResult.isAuthenticated);
      return;
    } catch (Exception) {
      // TODO: Handle exception
      rethrow;
    }
  }

  @override
  Future<void> login(String email, String password) async {
    try {
      AuthResult authResult = await _authRepository.login(email, password);
      _sessionRepository.setCurrentUser(authResult.user);
      _sessionRepository.saveToken(authResult.token);
      _sessionRepository.setAuthenticated(authResult.isAuthenticated);
    } catch (Exception) {

    }
    return null;
  }

  @override
  Future<void> signOff() async {
    try {
      await _googleSignIn.signOut();
      await _authRepository.signOff();
    } catch (Exception) {

    } finally {
      _sessionRepository.forgetToken();
      _sessionRepository.setAuthenticated(false);
      _sessionRepository.setCurrentUser(null);
    }
    return;
  }

  Future<void> googleLogin() async {
    GoogleSignInAuthentication googleSignInAuthentication;
    try {
      await _googleSignIn.signIn();
      googleSignInAuthentication = await _googleSignIn.currentUser.authentication;
      AuthResult authResult = await _authRepository.socialLoginWithGoogle(googleSignInAuthentication.idToken);
      _sessionRepository.setCurrentUser(authResult.user);
      _sessionRepository.saveToken(authResult.token);
      _sessionRepository.setAuthenticated(authResult.isAuthenticated);
    } catch(error) {
      rethrow;
    }
  }
}