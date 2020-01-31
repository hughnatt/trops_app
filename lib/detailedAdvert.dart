import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';

class DetailedAdvertPage extends StatefulWidget {

  @override
  _DetailedAdvertPage createState() => _DetailedAdvertPage();
}

class _DetailedAdvertPage extends State<DetailedAdvertPage> {



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
                    'NAME OF THE PRODUCT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Text(
                  'NAME OF THE SELLER',
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
        "Per hoc minui studium suum existimans Paulus,"
        "ut erat in conplicandis negotiis artifex dirus,"
        "unde ei Catenae inditum est cognomentum, "
        "vicarium ipsum eos quibus praeerat adhuc defensantem "
        "ad sortem periculorum communium traxit. et instabat ut eum "
        "quoque cum tribunis et aliis pluribus ad comitatum imperatoris vinctum perduceret: "
        "quo percitus ille exitio urgente abrupto ferro eundem adoritur Paulum. ",
        softWrap: true,
      ),
    );
    return Scaffold(
      body: Column(
          //mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
                height: 250.0,
                width: MediaQuery.of(context).size.width,
                child: Carousel(
                  images: [
                    NetworkImage('https://img.phonandroid.com/2019/12/leboncoin-arnaque-sms.jpg'),
                    NetworkImage('https://img.phonandroid.com/2019/12/leboncoin-arnaque-sms.jpg'),
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