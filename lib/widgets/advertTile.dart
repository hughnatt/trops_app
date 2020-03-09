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

  num prettyPrintPrice(){
    if(this.advert.getPrice()%1 == 0){
      return this.advert.getPrice().toInt();
    }
    else{
      return this.advert.getPrice();
    }
  }

  Widget _getImageWidget(){

    if(this.advert.getFirstImage() != null){

      return CachedNetworkImage(
        imageUrl: this.advert.getFirstImage(),
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
    }
    else {
      return Image.asset("assets/default_image.jpeg", fit: BoxFit.cover,);
    }

  }

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
                child: Container(
                  height: 100,
                  width: 100,
                  child: Hero(
                    tag: 'heroAdvertImage_${advert.getId()}',
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
                              prettyPrintPrice().toString() + "€/j",
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
                          maxLines: 2,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.only(right: 10.0),
                            child: Text(
                              this.advert.getCategory(),
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