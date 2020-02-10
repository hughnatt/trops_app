import 'package:flutter/material.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/ui/detailedAdvert.dart';

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
                child: FadeInImage.assetNetwork(
                  placeholder: "assets/Rolling-1s-200px.gif",
                  image: this.advert.getImage(),
                  height: 100,
                  width: 100,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      this.advert.getTitle(),
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      this.advert.getPrice().toString() + "€",
                      maxLines: 1,
                      style: TextStyle(
                        color: Colors.orange
                      ),
                    ),
                    Text(
                      this.advert.getDescription(),
                      maxLines: 3,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}