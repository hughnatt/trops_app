import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/ui/adminAdvertView.dart';

class DetailedAdvertPage extends StatelessWidget {

  final Advert advert;

  DetailedAdvertPage({Key key, @required this.advert}) : super(key: key);

  List<Widget> getImagesWidget(){

    List<String> images = this.advert.getAllImages();
    List<Widget> imagesWidget = new List<Widget>();

    if(images != null){
      images.forEach((item) {
        imagesWidget.add(
          Container(
            child: CachedNetworkImage(
              imageUrl: item,
              fit: BoxFit.cover,
            ),
          )
        );
      });
      return imagesWidget;
    }
    else {
      return [Image.asset("assets/default_image.jpeg", fit: BoxFit.cover,)];
    }

  }

  Widget trailingIcon(BuildContext context){

    if(User.current != null && User.current.getEmail() == advert.getOwner()){
      return IconButton(icon: Icon(Icons.mode_edit),onPressed: () => Navigator.push(context, MaterialPageRoute(builder : (context) => AdminAdvertView(advert : this.advert))),);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).accentColor;
    const double edgeAllPadding = 32;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Détails de l'annonce", style: TextStyle(
          fontSize: 25.0,
          ),
        ),
        actions: <Widget>[
          trailingIcon(context),
        ],

      ),
      body: SafeArea(
        child:  SingleChildScrollView(
          child:
          Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,
                  child: Hero(
                    tag: 'heroAdvertImage_${advert.getId()}',
                    child:Carousel(
                      images: getImagesWidget(),
                      autoplay: false,
                      dotSize: 4,
                      dotBgColor: Colors.grey[800].withOpacity(0),
                    ),
                  ),
              ),
              Column(
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
                            style: TextStyle(
                              fontSize: 20.0,
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
                            fontSize: 20.0,
                              color: Colors.orange
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          this.advert.getOwner(),
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          this.advert.getCategory(),
                          style: TextStyle(
                            fontSize: 13.0,
                            color: Colors.black54,
                          ),
                        ),
                      )
                    ],
                  ),
                  Center(
                    child: Container(
                      height: 2.0,
                      width: MediaQuery.of(context).size.width * 0.80,
                      color: Colors.lightBlue,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      this.advert.getDescription(),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.smartphone),
            title: Text('Appeler'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            title: Text('Réserver'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Message'),
          ),
        ],
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.black54,
      ),
    );
  }
}