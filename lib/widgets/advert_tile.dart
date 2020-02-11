import 'package:flutter/material.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/ui/detailedAdvert.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AdvertTile extends StatelessWidget {

  final Advert advert;

  const AdvertTile({
    Key key,
    @required this.advert
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder : (context) => DetailedAdvertPage(advert : this.advert))) ,
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
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: CachedNetworkImage(
                    imageUrl: this.advert.getFirstImage(),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                    fit: BoxFit.cover,
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
                                this.advert.getTitle(),
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
                              this.advert.getPrice().toString() + "€",
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
                          this.advert.getDescription(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
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