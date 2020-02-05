import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:trops_app/models/advert.dart';

class DetailedAdvertPage extends StatelessWidget {

  final Advert advert;

  DetailedAdvertPage({Key key, @required this.advert}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).accentColor;
    const double edgeAllPadding = 32;

    Widget titleSection = Container(
      padding: const EdgeInsets.all(edgeAllPadding),
      child: Row(
        children: [
          Expanded(
            /*1*/
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*2*/
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    advert.getTitle(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  advert.getPrice().toString(),
                  style: TextStyle(
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    Widget buttonSection = Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonColumn(color, Icons.call, 'CONTACT'),
          _buildButtonColumn(color, Icons.message, 'MESSAGE'),
          _buildButtonColumn(color, Icons.ac_unit, 'LOL'),
        ],
      ),
    );
    Widget textSection = Container(
      padding: const EdgeInsets.all(edgeAllPadding),
      child: Text(
        advert.getDescription(),
        softWrap: true,
      ),
    );

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child:  SingleChildScrollView(
          child:
          Column(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                  height: 250.0,
                  width: MediaQuery.of(context).size.width,
                  child: Carousel(
                    images: [
                      NetworkImage(advert.getImage()),
                      NetworkImage('https://flutterappdev.com/wp-content/uploads/2019/01/Screen-Shot-2019-01-25-at-12.54.42-PM.png'),
                    ],
                    autoplay: false,
                    dotSize: 4,
                    dotBgColor: Colors.grey[800].withOpacity(0),
                  )
              ),
              titleSection,
              textSection,
              buttonSection,
            ],
          ),
        ),
      ),
    );
  }


  Column _buildButtonColumn(Color color, IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: color),
        Container(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: color,
            ),
          ),
        ),
      ],
    );
  }
}