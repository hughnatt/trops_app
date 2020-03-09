import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/ui/adminAdvertView.dart';
import 'package:trops_app/ui/detailedAdvert.dart';

class SlidingCard extends StatelessWidget {

  final Advert advert;

  final bool proprietary;

  const SlidingCard({
    Key key,
    @required this.advert,
    @required this.proprietary,
  }) : super(key: key);

  void openPage(BuildContext context){
    if(proprietary){
      Navigator.push(context, MaterialPageRoute(builder : (context) => AdminAdvertView(advert : this.advert)));
    } else {
      Navigator.push(context, MaterialPageRoute(builder : (context) => DetailedAdvertPage(advert : this.advert)));
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
              child: CachedNetworkImage(
                imageUrl: advert.getFirstImage(),
                height: 150,
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
                              advert.getTitle(),
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
                            advert.getPrice().toString() + "€",
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
                        advert.getDescription(),
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
                            advert.getCategory(),
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