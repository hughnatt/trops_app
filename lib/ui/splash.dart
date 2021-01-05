

import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:trops_app/core/data/advert_repository.dart';
import 'package:trops_app/core/data/category_repository.dart';
import 'package:trops_app/core/data/favorite_repository.dart';
import 'package:trops_app/core/data/location_repository.dart';
import 'package:trops_app/core/data/search_repository.dart';
import 'package:trops_app/core/data/session_repository.dart';
import 'package:trops_app/core/data/user_repository.dart';
import 'package:trops_app/ui/home.dart';

class SplashPage extends StatefulWidget {

  final SessionRepository sessionRepository;
  final CategoryRepository categoryRepository;
  final AdvertRepository advertRepository;
  final SearchRepository searchRepository;
  final FavoriteRepository favoriteRepository;
  final UserRepository userRepository;
  final LocationRepository locationRepository;

  const SplashPage({
    Key key,
    @required this.sessionRepository,
    @required this.categoryRepository,
    @required this.advertRepository,
    @required this.searchRepository,
    @required this.favoriteRepository,
    @required this.userRepository,
    @required this.locationRepository
  });

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage>{

  @override
  void initState() {
    super.initState();
    widget.sessionRepository.restoreCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: HomePage(
        categoryRepository: widget.categoryRepository,
        advertRepository: widget.advertRepository,
        sessionRepository: widget.sessionRepository,
        searchRepository: widget.searchRepository,
        favoriteRepository: widget.favoriteRepository,
        userRepository: widget.userRepository,
        locationRepository: widget.locationRepository,
      ),
      image: Image(
        image: AssetImage("assets/trops_logo_866.png"),
      ),
      photoSize: 80,
      loaderColor: Colors.blueAccent,
    );
  }
}