import 'package:flutter/material.dart';
import 'package:trops_app/api/data.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/models/User.dart';
import 'package:http/http.dart' as Http;
import 'package:carousel_pro/carousel_pro.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:trops_app/models/DateRange.dart';

class AdminAdvertView extends StatefulWidget {
  final Advert advert;

  const AdminAdvertView({Key key, @required this.advert}) : super(key : key);

  @override
  _AdminAdvertViewState createState() {
    return _AdminAdvertViewState(advert: advert);
  }
}

class _AdminAdvertViewState extends State<AdminAdvertView> {

  final Advert advert;

  TextEditingController titleController;
  TextEditingController descriptionController;
  TextEditingController priceController;

  //List<DateRange> availability = List<DateRange>();

  _AdminAdvertViewState({Key key, @required this.advert,}) ;

  @override
  void initState(){
    super.initState();
    titleController = TextEditingController(text: advert.getTitle());
    descriptionController = TextEditingController(text: advert.getDescription());
    priceController = TextEditingController(text: advert.getPrice().toString());
  }

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


  Future<void> _deleteFromDB(BuildContext context) async {

    Http.Response res = await deleteAdvert(advert.getId(), User.current.getToken());

    if(res.statusCode == 202){
      Navigator.pop(context);
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text("Suppression réussie"),
            children: <Widget>[
              Container(
                child: Text(""),
              ),
            ],
          )
      );
    } else {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text("Echec"),
            children: <Widget>[
              Container(
                child: Text("La suppression a échoué, veuillez réessayer plus tard."),
              ),

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

    Http.Response res = await modifyAdvert(title,double.parse(price),description,advert.getCategory(),advert.getOwner(),DateTime.now(),DateTime.now(),advert.getId(), User.current.getToken());

    if(res.statusCode==200){
      Navigator.pop(context);
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text("Succès"),
            children: <Widget>[
              Text("L'annonce a été modifiée avec succès."),

            ],
          )
      );
    } else {
      return showDialog<String>(
          context: context,
          builder: (BuildContext context) => SimpleDialog(
            title: Text("Echec"),
            children: <Widget>[
              Text("L'annonce n'a pas pu être modifiée, veuillez réessayez plus tard."),

            ],
          )
      );
    }

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Modification de l'annonce"),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[

              GestureDetector(
                onTap: null,//open editing images
                child: SizedBox(
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
              ),


              
              Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  //textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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

  @override
  void dispose(){
    titleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    super.dispose();
  }

}