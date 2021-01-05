import 'package:google_sign_in/google_sign_in.dart';
import 'package:trops_app/core/data/advert_repository.dart';
import 'package:trops_app/core/data/auth_repository.dart';
import 'package:trops_app/core/data/category_repository.dart';
import 'package:trops_app/core/data/favorite_repository.dart';
import 'package:trops_app/core/data/location_repository.dart';
import 'package:trops_app/core/data/search_repository.dart';
import 'package:trops_app/core/data/session_repository.dart';
import 'package:trops_app/core/data/user_repository.dart';
import 'package:trops_app/core/interactor/auth_interactor.dart';
import 'package:trops_app/data/http_session.dart';
import 'package:trops_app/data/impl/advert_repository_impl.dart';
import 'package:trops_app/data/impl/auth_repository_impl.dart';
import 'package:trops_app/data/impl/category_repository_impl.dart';
import 'package:trops_app/data/impl/favorite_repository_impl.dart';
import 'package:trops_app/data/impl/location_repository_impl.dart';
import 'package:trops_app/data/impl/search_repository_impl.dart';
import 'package:trops_app/data/impl/session_repository_impl.dart';
import 'package:trops_app/data/impl/user_repository_impl.dart';

class DependencyManager {

  static DependencyManager shared = DependencyManager();

  static HttpSession _httpSession = HttpSession();
  static GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );
  static AdvertRepository _advertRepository = AdvertRepositoryImpl(httpSession: _httpSession, categoryRepository: _categoryRepository);
  static FavoriteRepository _favoriteRepository = FavoriteRepositoryImpl(httpSession: _httpSession);
  static UserRepository _userRepository = UserRepositoryImpl(httpSession: _httpSession);
  static AuthRepository _authRepository = AuthRepositoryImpl(httpSession: _httpSession);
  static SearchRepository _searchRepository = SearchRepositoryImpl(httpSession: _httpSession, categoryRepository: _categoryRepository);
  static SessionRepository _sessionRepository = SessionRepositoryImpl(authRepository: _authRepository);
  static LocationRepository _locationRepository = LocationRepositoryImpl();
  static CategoryRepository _categoryRepository = CategoryRepositoryImpl();

  static AuthInteractor _authInteractor = AuthInteractorImpl(
      sessionRepository: _sessionRepository,
      authRepository: _authRepository,
      googleSignIn: _googleSignIn
  );

  DependencyManager() {
    _httpSession.setTokenProvider(tokenProvider: _sessionRepository);
  }

  // INTERACTORS

  AuthInteractor authInteractor() {
    return _authInteractor;
  }

  // REPOSITORIES

  AdvertRepository advertRepository() {
    return _advertRepository;
  }

  FavoriteRepository favoriteRepository() {
    return _favoriteRepository;
  }

  UserRepository userRepository() {
    return _userRepository;
  }

  LocationRepository locationRepository() {
    return _locationRepository;
  }

  CategoryRepository categoryRepository() {
    return _categoryRepository;
  }

  SearchRepository searchRepository() {
    return _searchRepository;
  }

  SessionRepository sessionRepository() {
    return _sessionRepository;
  }
}