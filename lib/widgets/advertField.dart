import 'package:flutter/material.dart';
import 'package:trops_app/models/Advert.dart';

class AdvertField extends StatelessWidget {

  final int nbLines;
  final String label;
  final IconData icon;
  final TextEditingController controller;

  const AdvertField({
    Key key,
    @required this.nbLines,
    @required this.label,
    @required this.icon,
    @required this.controller
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top: 25,right: 25, left:10, bottom: 20.0),
        child: TextField(
            maxLines: nbLines,
            controller: controller,
            decoration: InputDecoration(
              icon: Icon(icon),
              hintText: label,
              border: InputBorder.none,
            )
        )
    );
  }

}