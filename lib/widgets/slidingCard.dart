import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
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


  Widget _getImageWidget(BuildContext context){

    if(this.advert.getFirstImage() != null){

      return CachedNetworkImage(
        imageUrl: advert.getFirstImage(),
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