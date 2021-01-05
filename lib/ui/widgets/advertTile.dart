import 'package:flutter/material.dart';
import 'package:trops_app/core/data/advert_repository.dart';
import 'package:trops_app/core/data/category_repository.dart';
import 'package:trops_app/core/data/favorite_repository.dart';
import 'package:trops_app/core/data/location_repository.dart';
import 'package:trops_app/core/data/session_repository.dart';
import 'package:trops_app/core/data/user_repository.dart';
import 'package:trops_app/core/entity/advert.dart';
import 'package:trops_app/ui/detailedAdvert.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdvertTile extends StatelessWidget {

  final Advert advert;
  final CategoryRepository categoryRepository;
  final FavoriteRepository favoriteRepository;
  final LocationRepository locationRepository;
  final AdvertRepository advertRepository;
  final SessionRepository sessionRepository;
  final UserRepository userRepository;

  const AdvertTile({
    Key key,
    @required this.advert,
    @required this.categoryRepository,
    @required this.favoriteRepository,
    @required this.locationRepository,
    @required this.advertRepository,
    @required this.sessionRepository,
    @required this.userRepository
  }) : super(key: key);

  Widget _getImageWidget(){
    if (advert.photos.first != null) {
      return CachedNetworkImage(
        imageUrl: advert.photos.first,
        placeholder: (context, url) => Center(
          child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.broken_image),
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset("assets/default_image.jpeg", fit: BoxFit.cover,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder : (context) => DetailedAdvertPage(
          advert : this.advert,
          categoryRepository: categoryRepository,
          favoriteRepository: favoriteRepository,
          locationRepository: locationRepository,
          advertRepository: advertRepository,
          sessionRepository: sessionRepository,
          userRepository: userRepository,
        )
      )) ,
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: Material(
          borderRadius: BorderRadius.circular(10.0),
          elevation: 2.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10.0), bottomLeft: Radius.circular(10.0)),
                child: Container(
                  height: 100,
                  width: 100,
                  child: Hero(
                    tag: 'heroAdvertImage_${advert.id}',
                    child: _getImageWidget()
                  ),
                ),
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
                              "${advert.price} €/j",
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
      ),
    );
  }

}