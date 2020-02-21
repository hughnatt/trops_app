import 'package:flutter/material.dart';
import 'package:trops_app/api/data.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/models/User.dart';
import 'package:http/http.dart' as Http;

class AdminAvertView extends StatelessWidget {

  final Advert advert;

  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController priceController;

  AdminAvertView({Key key, @required this.advert}) : super(key: key);

  Future<void> _deleteFromDB(BuildContext context) async {

    Http.Response res = await deleteAdvert(advert.getId(), User.current.getToken());

    if(res.statusCode == 202){
      Navigator.pop(context);
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text("Suppression réussie"),
          )
      );
    } else {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text("Echec"),
            children: <Widget>[
              Text("La suppression a échoué, veuillez réessayer plus tard."),

            ],
          )
      );
    }

  }

  Future<void> onDeletePressed(BuildContext context){
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Supprimer l'annonce"),
        content: Text("Etes-vous sur de vouloir supprimer l'annonce ?"),
        actions: <Widget>[
          FlatButton(
            child: Text("Supprimer"),
            onPressed: () => Navigator.pop(context, 'delete'),
          ),
          FlatButton(
            child: Text("Annuler"),
            onPressed: () => Navigator.pop(context, 'cancel'),
          )
        ],
      ),
    ).then((returnval){
      if(returnval == 'delete'){
        print("delete");
        _deleteFromDB(context);
      }
    });

  }

  Future<void> onSavePressed(BuildContext context) async {

    String title = titleController.text;
    String description = descriptionController.text;
    String price = priceController.text;


    Http.Response res = await modifyAdvert(title,int.parse(price),description,advert.getCategory(),advert.getOwner(),DateTime.now(),DateTime.now(),advert.getId(), User.current.getToken());

    if(res.statusCode==200){
      return
    }

  }

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
              FlatButton.icon(onPressed: () => onSavePressed(context), icon: Icon(Icons.save), label: Text("Enregister")),

              FlatButton.icon(onPressed: () => onDeletePressed(context), icon: Icon(Icons.delete, color: Colors.red,), label: Text("Supprimer")),
            ],
          ),
        ),
      ),
    );
  }

  //TODO: Dispose
}