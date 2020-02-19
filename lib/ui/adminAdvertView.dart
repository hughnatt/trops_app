import 'package:flutter/material.dart';
import 'package:trops_app/models/Advert.dart';

class AdminAvertView extends StatelessWidget {

  final Advert advert;

  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController priceController;

  AdminAvertView({Key key, @required this.advert}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    titleController  = TextEditingController(text: advert.getTitle());
    descriptionController = TextEditingController(text: advert.getDescription());
    priceController = TextEditingController(text: advert.getPrice().toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("Modification de l'annonce"),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              //Display carousel image
              
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: advert.getTitle(),
                  ),
                  controller: titleController,
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  maxLines: 3,
                  style: TextStyle(fontSize: 18,),
                  controller: descriptionController,
                ),
              ),

              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  style: TextStyle(fontSize: 18,),
                  keyboardType: TextInputType.number,
                  controller: priceController,
                ),
              ),

            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomAppBar(
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton.icon(onPressed: null, icon: Icon(Icons.save), label: Text("Enregister")),

              FlatButton.icon(onPressed: null, icon: Icon(Icons.delete, color: Colors.red,), label: Text("Supprimer")),
            ],
          ),
        ),
      ),
    );
  }
}