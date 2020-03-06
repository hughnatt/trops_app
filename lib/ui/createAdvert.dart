import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/api/data.dart';
import 'package:trops_app/models/DateRange.dart';
import 'package:trops_app/api/image.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/models/TropsCategory.dart';
import 'package:trops_app/widgets/autocompleteSearch.dart';
import 'package:trops_app/widgets/imageSelector.dart';
import 'package:trops_app/widgets/trops_bottom_bar.dart';
import 'package:trops_app/utils/imagesManager.dart';
import 'package:trops_app/widgets/advertField.dart';
import 'package:intl/intl.dart';
import 'package:trops_app/widgets/categorySelector.dart';


String _selectedCategoryID;
class CreateAdvertPage extends StatefulWidget {

  @override
  _CreateAdvertPage createState() => _CreateAdvertPage();
}

enum ResultType {success, failure, denied} //enum for the different case of the creation of an advert

class _CreateAdvertPage extends State<CreateAdvertPage> {

  List<DateRange> _availability = new List<DateRange>();
  TextEditingController _titleController = TextEditingController(); //controller to get the text form the title field
  TextEditingController _descriptionController = TextEditingController(); //controller to get the text form the description field
  TextEditingController _priceController = TextEditingController(); //controller to get the text form the price field

  List<TropsCategory> _categories = new List<TropsCategory>();
  Autocomplete locationSearchBar = Autocomplete();
  CategorySelector _categorySelector;

  bool _isUploadProcessing; //bool that indicate if the a upload task is running to disable the upload button

  GlobalKey<ImageSelectorState> _myWidgetState = GlobalKey<ImageSelectorState>(); //GlobalKey to access the imageSelector state

  @override
  void initState(){
    super.initState();
    loadCategories();
    setState(() {
      _availability.add(DateRange(DateTime.now(), DateTime.now()));
      _isUploadProcessing = false;
      _categorySelector = CategorySelector(categories: _categories,);
    });
  }

  loadCategories() async {

    getCategories().then( (List<TropsCategory> res) {
      setState(() {
        _categories = res;
      });
    });
  }

  bool _isPriceValid = true;
  
  Widget _buildValuePicker() {
    return Container(
      padding: EdgeInsets.only(top: 20,right: 25,left:10,bottom:20),
      child:
      TextField(
        keyboardType: TextInputType.number,
        controller: _priceController,
        inputFormatters: [BlacklistingTextInputFormatter(RegExp("[ ]?[,]?[-]?")),],
        onChanged: (String text) {
          try{
            if(_priceController.text != ""){
              double.parse(_priceController.text);
              setState(() {
                _isPriceValid = true;
              });
            }
          }
          catch(err){
            setState(() {
              _isPriceValid = false;
            });
          }
        },
        decoration: InputDecoration(
          icon: Icon(Icons.euro_symbol),
          hintText: 'Coût de location (par jour)',
          border: InputBorder.none,
          errorText: _isPriceValid ? null : "Format incorrect"
        ),
      ),
    );
  }

  Widget _buildValidationButton(){
    return Container(
      padding: EdgeInsets.only(left:25.0, right: 25.0, bottom: 10.0),
      child: MaterialButton(
        color: Colors.green,
        onPressed: _isUploadProcessing ? null : _uploadAdvert,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: _buildButtonState(),
      ),
    );
  }

  Widget _buildButtonState(){
    if(!_isUploadProcessing){
      return Text("Créer l'annonce",style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white));
    }
    else{
      return CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Colors.black));
    }
  }

  ///
  ///
  ///
  Future<Null> _selectDate(BuildContext context, int index, bool start) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: start ? DateTime.now() : _availability[index].start,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked.isAfter(DateTime.now())){
      if (start){
        setState(() {
          _availability[index].start = picked;
          if (picked.isAfter(_availability[index].end)){
            _availability[index].end = picked;
          }
        });
      } else {
        setState(() {
          _availability[index].end = picked;
          if (picked.isBefore(_availability[index].start)){
            _availability[index].start = picked;
          }
        });
      }
    }
  }

  Widget _buildAvailabilityList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _availability.length,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            Text(
                "DU  ",
              style: TextStyle(
                  fontWeight: FontWeight.bold
              ),
            ),
            OutlineButton(
              child: Text(
                  DateFormat('dd/MM/yy').format(_availability[index].start)
              ),
              onPressed: () {
                _selectDate(context,index,true);
              },
              textColor: Colors.blueAccent,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            Text(
              "  AU  ",
              style: TextStyle(
                fontWeight: FontWeight.bold
              ),
            ),
            OutlineButton(
              child: Text(
                  DateFormat('dd/MM/yy').format(_availability[index].end)
              ),
              onPressed: () {
                _selectDate(context,index,false);
              },
              textColor: Colors.blueAccent,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.red,
              highlightColor: Colors.deepOrangeAccent,
              onPressed: (_availability.length <= 1) ? null : () {
                {
                  setState(() {
                    _availability.removeAt(index);
                  });
                }
              },
            ),
          ],
        );
      }
    );
  }

  void unfocus(){
    FocusScope.of(context).unfocus(); //make all the textfield loose focus
  }


  bool _checkFields(){
    return (_titleController.text.isNotEmpty && _priceController.text.isNotEmpty && _categorySelector.selectedCategory() != null && locationSearchBar.getSelectedLocation() != null); //check if all REQUIRED field have a value
  }


  void _uploadAdvert() async {

    this.unfocus();

    //List<String> splitedPaths = this._imagesManager.getAllFilePath();


    if(_checkFields() && _isPriceValid){ //if the user have correctly completed the form

      setState(() {
        _isUploadProcessing = true; //We transform the button into loading circle (the button is disabled)
      });

      //var response = await uploadAdvertApi(_titleController.text, double.parse(_priceController.text), _descriptionController.text, _selectedCategoryID, User.current.getEmail(),splitedPaths, _availability, locationSearchBar.getSelectedLocation()); // we try to contact the APi to add the advert
      var response = await uploadAdvertApi(User.current.getToken(),_titleController.text, double.parse(_priceController.text), _descriptionController.text, _selectedCategoryID, User.current.getEmail(),_myWidgetState.currentState.getAllPaths(), _availability, locationSearchBar.getSelectedLocation()); // we try to contact the APi to add the advert

      setState(() {
        _isUploadProcessing = false; //the button is show again (before pop context)
      });

      if (response.statusCode != 201){ //if the response is not 201, the advert wasn't created for some reasons
        _showUploadResult(context,ResultType.failure); //we warn the user that the process failed
      }
      else{ // the response is 201, the creation was a sucess
        _showUploadResult(context,ResultType.success); // we warn him that it's a success
      }
    }
    else{ // the user doesn't correctly complete the form
      _showUploadResult(context, ResultType.denied); // we warn him that he can't create the advert
    }

  }

  Future<void> _showUploadResult(BuildContext context, ResultType result) { //one function to show an alertdialog depending of the advert state when user clicked on create
    String title;
    String content;
    int popCount;

    int count = 0;
    Color color;

    switch(result){
      case ResultType.success:
        {
          title = "Opération terminée";
          content = "Votre annonce a été créée avec succès";
          popCount = 2;
          color = Colors.greenAccent;
          break;
        }
      case ResultType.failure:
        {
          title = "Opération échouée";
          content = "Malheureusement, votre annonce n'a pas pu être créée";
          popCount = 1;
          color = Colors.redAccent;
          break;
        }
      case ResultType.denied:
        {
          title = "Pas si vite !";
          content = "Vérifiez que les champs obligatoires soient remplis (Titre, Prix, Catégorie, Dates)";
          popCount = 1;
          color = Colors.redAccent;
          break;
        }

    }
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return WillPopScope(
            onWillPop: () {},
            child : AlertDialog(
              title: new Text(title),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children : <Widget>[
                  Expanded(
                    child:  new Text(
                      content,
                      style: TextStyle(
                        color: color,
                      ),
                    ),
                  )
                ],
              ),
              actions: <Widget>[
                // usually buttons at the bottom of the dialog
                new FlatButton(
                  child: new Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).popUntil((_) => count++ >= popCount);
                  },
                ),
              ],
            ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Création d'une annonce", style: TextStyle(
          fontSize: 25.0,
        ),
        ),
      ),
      body: GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(25.0),
                  child: Material(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Column(
                      children: <Widget>[
                        AdvertField(nbLines: 1,label:"Nom du produit",icon: Icons.title,controller: _titleController),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        _buildValuePicker(),
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left:25.0, right: 25.0, bottom: 25.0),
                  child: Material(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    //child: AdvertField(nbLines: 3,label: "Description",icon: Icons.description,controller: _descriptionController),
                    child: Container(
                      padding: EdgeInsets.only(top: 25,right: 25, left:10, bottom: 20.0),
                      child: TextField(
                        controller: _descriptionController,
                        maxLines: null,
                        maxLength: 1000,
                        decoration: InputDecoration(
                          icon: Icon(Icons.description),
                          hintText: "Description",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(left:25.0, right: 25.0, bottom: 25.0),
                  child: Material(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                                "Catégorie",
                                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
                            ),
                            CategorySelector(categories: _categories),
                          ],
                        )
                    ),
                  ),
                ),

                Container(
                    padding: EdgeInsets.only(left:25.0, right: 25.0, bottom: 25.0),
                    child: Material(
                        elevation: 2.0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: Container(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                Text(
                                    "Disponibilités",
                                    style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)
                                ),
                                _buildAvailabilityList(),
                                Padding(
                                  padding: EdgeInsets.only(top: 10),
                                ),
                                RaisedButton.icon(
                                  label: Text("Ajouter une période"),
                                  icon: Icon(Icons.add),
                                  textColor: Colors.blueAccent,
                                  color: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _availability.add(DateRange(DateTime.now(), DateTime.now()));
                                    });
                                  },
                                ),
                              ],
                            )
                        )
                    )
                ),

                Container(
                  padding: EdgeInsets.only(top: 20.0, left:25.0, right: 25.0, bottom: 10.0),
                  child: Material(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Adresse du bien", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10.0),
                          child: locationSearchBar,
                        )
                      ],
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.only(top: 20.0, left:25.0, right: 25.0, bottom: 10.0),
                  child: Material(
                    elevation: 2.0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(10.0),
                          child: Text("Photos", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
                        ),
                        ImageSelector(key:_myWidgetState)
                      ],
                    ),
                  ),
                ),

                Container(
                    padding: EdgeInsets.only(top:25,bottom:25),
                    child: _buildValidationButton()
                ),
              ],
            ),
          ),
        )
      ),
      bottomNavigationBar: TropsBottomAppBar(),
    );
  }


}



