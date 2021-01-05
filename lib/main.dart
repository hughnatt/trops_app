import 'package:flutter/material.dart';
import 'package:trops_app/core/data/advert_repository.dart';
import 'package:trops_app/core/data/category_repository.dart';
import 'package:trops_app/core/data/favorite_repository.dart';
import 'package:trops_app/core/data/location_repository.dart';
import 'package:trops_app/core/data/search_repository.dart';
import 'package:trops_app/core/data/session_repository.dart';
import 'package:trops_app/core/data/user_repository.dart';
import 'package:trops_app/core/interactor/auth_interactor.dart';
import 'package:trops_app/ui/auth.dart';
import 'package:trops_app/ui/createAdvert.dart';
import 'package:trops_app/ui/profile.dart';
import 'package:trops_app/ui/search.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:trops_app/ui/splash.dart';
import 'package:trops_app/utils/DependencyManager.dart';
import 'ui/home.dart';

void main() {
  runApp(TropsApp(
    locationRepository: DependencyManager.shared.locationRepository(),
    advertRepository: DependencyManager.shared.advertRepository(),
    sessionRepository: DependencyManager.shared.sessionRepository(),
    categoryRepository: DependencyManager.shared.categoryRepository(),
    searchRepository: DependencyManager.shared.searchRepository(),
    favoriteRepository: DependencyManager.shared.favoriteRepository(),
    userRepository: DependencyManager.shared.userRepository(),
    authInteractor: DependencyManager.shared.authInteractor(),
  ));
}

class TropsApp extends StatelessWidget {

  final LocationRepository locationRepository;
  final UserRepository userRepository;
  final FavoriteRepository favoriteRepository;
  final SearchRepository searchRepository;
  final AdvertRepository advertRepository;
  final CategoryRepository categoryRepository;
  final SessionRepository sessionRepository;
  final AuthInteractor authInteractor;

  const TropsApp({
    Key key,
    @required this.locationRepository,
    @required this.userRepository,
    @required this.favoriteRepository,
    @required this.searchRepository,
    @required this.advertRepository,
    @required this.categoryRepository,
    @required this.sessionRepository,
    @required this.authInteractor
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "TROPS",
      initialRoute: "/splash",
      routes: {
        '/' : (context) => HomePage(
          locationRepository: locationRepository,
          userRepository: userRepository,
          favoriteRepository: favoriteRepository,
          searchRepository: searchRepository,
          advertRepository: advertRepository,
          categoryRepository: categoryRepository,
          sessionRepository: sessionRepository,
        ),
        '/splash' : (context) => SplashPage(
          categoryRepository: categoryRepository,
          sessionRepository: sessionRepository,
          advertRepository: advertRepository,
          searchRepository: searchRepository,
          favoriteRepository: favoriteRepository,
          userRepository: userRepository,
          locationRepository: locationRepository,
        ),
        '/search' : (context) => SearchResultPage(
          userRepository: userRepository,
          locationRepository: locationRepository,
          favoriteRepository: favoriteRepository,
          searchRepository: searchRepository,
          advertRepository: advertRepository,
          sessionRepository: sessionRepository,
          categoryRepository: categoryRepository,
        ),
        '/auth' : (context) => AuthPage(
          sessionRepository: sessionRepository,
          authInteractor: authInteractor,
        ),
        '/profile' : (context) => ProfilePage(
          categoryRepository: categoryRepository,
          sessionRepository: sessionRepository,
          advertRepository: advertRepository,
          favoriteRepository: favoriteRepository,
          locationRepository: locationRepository,
          userRepository: userRepository,
          authInteractor: authInteractor,
        ),
        '/home' : (context) => HomePage(
          locationRepository: locationRepository,
          userRepository: userRepository,
          favoriteRepository: favoriteRepository,
          advertRepository: advertRepository,
          sessionRepository: sessionRepository,
          categoryRepository: categoryRepository,
          searchRepository: searchRepository,
        ),
        '/create' : (context) => CreateAdvertPage(
          categoryRepository: categoryRepository,
          sessionRepository: sessionRepository,
          advertRepository: advertRepository,
          locationRepository: locationRepository,
        )
      },
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate
      ],
      supportedLocales: [
        const Locale('fr')
      ],
    );
  }
}