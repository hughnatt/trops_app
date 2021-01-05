import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trops_app/core/data/advert_repository.dart';
import 'package:trops_app/core/data/category_repository.dart';
import 'package:trops_app/core/data/favorite_repository.dart';
import 'package:trops_app/core/data/location_repository.dart';
import 'package:trops_app/core/data/session_repository.dart';
import 'package:trops_app/core/data/user_repository.dart';
import 'package:trops_app/core/entity/advert.dart';
import 'package:trops_app/core/entity/user.dart';
import 'package:trops_app/core/interactor/auth_interactor.dart';

import 'menu_profile.dart';
import 'widgets/slidingCard.dart';
import 'widgets/trops_scaffold.dart';

class ProfilePage extends StatefulWidget {

  final AuthInteractor authInteractor;
  final SessionRepository sessionRepository;
  final AdvertRepository advertRepository;
  final FavoriteRepository favoriteRepository;
  final UserRepository userRepository;
  final CategoryRepository categoryRepository;
  final LocationRepository locationRepository;

  const ProfilePage({
    Key key,
    @required this.authInteractor,
    @required this.sessionRepository,
    @required this.advertRepository,
    @required this.categoryRepository,
    @required this.favoriteRepository,
    @required this.userRepository,
    @required this.locationRepository
  }) : super(key : key);

  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{

  PageController pageController;
  List<Advert> _adverts = new List<Advert>();
  List<Advert> _advertsFavorites = new List<Advert>();
  User _user;

  @override
  void initState() {
    super.initState();
    // Make sure we have an user logged in
    // If not, redirect to authentication screen
    if (!widget.sessionRepository.isAuthenticated()) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        Navigator.of(context).pushNamed("/auth");
      });
    }
    pageController = PageController(viewportFraction: 0.8);
    widget.advertRepository.getAdvertsByUser(widget.sessionRepository.currentUser()).then((adverts) {
      setState(() {
        _adverts = adverts;
      });
    });

    widget.sessionRepository.currentUser().favorites.forEach((advertId) {
      widget.advertRepository.getAdvertsById(advertId).then((advertResult) {
        setState(() {
          _advertsFavorites.add(advertResult);
        });
      });
    });


    _user = widget.sessionRepository.currentUser();
  }

  Widget _buildFavoriteContent(int index){
    if (_advertsFavorites[index] != null) {
      return SlidingCard(
        advert:_advertsFavorites[index] ,
        proprietary: false,
        sessionRepository: widget.sessionRepository,
        locationRepository: widget.locationRepository,
        categoryRepository: widget.categoryRepository,
        userRepository: widget.userRepository,
        favoriteRepository: widget.favoriteRepository,
        advertRepository: widget.advertRepository,
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  @override
  Widget build(BuildContext context) {
    return TropsScaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Profile", style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.cog,
                color: Colors.white,
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(
                builder : (context) => MenuProfile(
                  userRepository: widget.userRepository,
                  sessionRepository: widget.sessionRepository,
                )
              )),
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.white,
              ),
              onPressed: () => _logout(),
            )
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                          _user.name,
                          textAlign: TextAlign.center,
                          textScaleFactor: 2.0,
                          style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        _user.email,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text("Mes favoris", style: TextStyle(fontSize: 18),),
                    ),
                    SizedBox(
                      height: 275,
                      child: PageView.builder(itemBuilder: (BuildContext context, int index) {
                        return _buildFavoriteContent(index);
                        },
                        itemCount: _advertsFavorites.length,
                        controller: pageController,
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text("Mes annonces", style: TextStyle(fontSize: 18),),
                    ),
                    SizedBox(
                      height: 275,
                      child: PageView.builder(itemBuilder: (BuildContext context, int index) {
                        return SlidingCard(
                          advert: _adverts[index],
                          proprietary: true,
                          advertRepository: widget.advertRepository,
                          favoriteRepository: widget.favoriteRepository,
                          userRepository: widget.userRepository,
                          sessionRepository: widget.sessionRepository,
                          categoryRepository: widget.categoryRepository,
                          locationRepository: widget.locationRepository,
                      );},
                        itemCount: _adverts.length,
                        controller: pageController,
                      )

                      /*PageView(
                        controller: pageController,
                        children: <Widget>[
                          SlidingCard(),
                          SlidingCard()
                        ],
                      ),*/
                    ),
                  ],
                ),
              ),
            ),
        ), sessionRepository: widget.sessionRepository,
    );
  }

  void _logout() {
    widget.authInteractor.signOff();
    Navigator.pop(context);
    Navigator.pushNamed(context, "/auth", arguments: "/home");
  }
}