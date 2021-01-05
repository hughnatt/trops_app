import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trops_app/core/data/advert_repository.dart';
import 'package:trops_app/core/data/category_repository.dart';
import 'package:trops_app/core/data/favorite_repository.dart';
import 'package:trops_app/core/data/location_repository.dart';
import 'package:trops_app/core/data/session_repository.dart';
import 'package:trops_app/core/data/user_repository.dart';
import 'package:trops_app/core/entity/advert.dart';
import 'package:trops_app/ui/adminAdvertView.dart';
import 'package:trops_app/ui/detailedAdvert.dart';

class SlidingCard extends StatelessWidget {

  final Advert advert;
  final bool proprietary;
  final AdvertRepository advertRepository;
  final CategoryRepository categoryRepository;
  final LocationRepository locationRepository;
  final SessionRepository sessionRepository;
  final FavoriteRepository favoriteRepository;
  final UserRepository userRepository;

  const SlidingCard({
    Key key,
    @required this.advert,
    @required this.proprietary,
    @required this.advertRepository,
    @required this.categoryRepository,
    @required this.locationRepository,
    @required this.sessionRepository,
    @required this.favoriteRepository,
    @required this.userRepository
  }) : super(key: key);

  void openPage(BuildContext context){
    if(proprietary){
      Navigator.push(context, MaterialPageRoute(
        builder : (context) => AdminAdvertView(
          advert : advert,
          advertRepository: advertRepository,
          categoryRepository: categoryRepository,
          locationRepository: locationRepository,
        ))
      );
    } else {
      Navigator.push(context, MaterialPageRoute(
        builder : (context) => DetailedAdvertPage(
          advert : advert,
          sessionRepository: sessionRepository,
          advertRepository: advertRepository,
          categoryRepository: categoryRepository,
          favoriteRepository: favoriteRepository,
          userRepository: userRepository,
          locationRepository: locationRepository,
        ))
      );
    }
  }


  Widget _getImageWidget(BuildContext context){

    if(this.advert.photos.first != null){

      return CachedNetworkImage(
        imageUrl: advert.photos.first,
        fit: BoxFit.cover,
        height: 150,
        width: MediaQuery.of(context).size.width * 0.8,
        placeholder: (context, url) => Center(
          child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.broken_image),
      );
    }
    else {
      return Image.asset("assets/default_image.jpeg", fit: BoxFit.cover,);
    }

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openPage(context) ,
      child: Card(
        margin: EdgeInsets.all(10.0),
        elevation: 2.0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
              child: _getImageWidget(context),
            ),
            Container(
              child: Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.only(left: 10.0, top: 10.0),
                            child: Text(
                              advert.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(right: 10.0, top: 10.0),
                          child: Text(
                            "${advert.price} + €",
                            maxLines: 1,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.orange
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        advert.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            advert.category,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(
                              fontSize: 13.0,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}