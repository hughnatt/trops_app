import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/api/data.dart';
import 'package:trops_app/models/User.dart';
import 'package:trops_app/models/TropsCategory.dart';
import 'package:trops_app/widgets/autocompleteSearch.dart';
import 'package:trops_app/widgets/availabilityList.dart';
import 'package:trops_app/widgets/imageSelector.dart';
import 'package:trops_app/widgets/trops_bottom_bar.dart';
import 'package:trops_app/widgets/advertField.dart';
import 'package:trops_app/widgets/categorySelector.dart';


class CreateAdvertPage extends StatefulWidget  {

  @override
  _CreateAdvertPage createState() => _CreateAdvertPage();
}

enum ResultType {success, failure, denied} //enum for the different case of the creation of an advert

class _CreateAdvertPage extends State<CreateAdvertPage> with SingleTickerProviderStateMixin {

  TextEditingController _titleController = TextEditingController(); //controller to get the text form the title field
  TextEditingController _descriptionController = TextEditingController(); //controller to get the text form the description field
  TextEditingController _priceController = TextEditingController(); //controller to get the text form the price field

  Autocomplete locationSearchBar = Autocomplete();
  CategorySelector _categorySelector;
  bool _loadingCategory;
  AvailabilityList _availabilityList = AvailabilityList(availability: []);
  Icon _fabIcon;

  bool _isUploadProcessing; //bool that indicate if the a upload task is running to disable the upload button
  bool _hasAcceptedEULA;
  bool _isPriceValid;


  GlobalKey<ImageSelectorState> _imageSelector = GlobalKey<ImageSelectorState>(); //GlobalKey to access the imageSelector state

  TabController _tabController;
  List<Widget> _kPanes;

  @override
  void initState(){
    super.initState();

    _fabIcon = Icon(Icons.navigate_next);

    _tabController = TabController(vsync: this, length: 6);
    _tabController.addListener((){
      setState(() {
          _fabIcon = (_tabController.index == _kPanes.length-1) ? Icon(Icons.check_circle) : Icon(Icons.navigate_next);
      });
    });


    _loadingCategory = true;
    getCategories().then( (List<TropsCategory> res) {
      setState(() {
        _loadingCategory = false;
        _categorySelector = CategorySelector(categories: res);
      });
    });

    _isUploadProcessing = false;
    _hasAcceptedEULA = false;
    _isPriceValid = true;
  }

  @override
  void dispose(){
    super.dispose();
    _tabController.dispose();
  }

  Widget _buildTitleDescPane() {
    return SingleChildScrollView(
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
          ]
      ),
    );
  }

  Widget _buildCategoryPane(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(25.0),
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
                Padding(padding: EdgeInsets.only(top: 10)),
                _loadingCategory ? SpinKitDoubleBounce(size: 25, color: Colors.lightBlueAccent) : _categorySelector,
              ],
            )
          ),
        ),
      ),
    );
  }

  Widget _buildLocationPane(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(25),
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
    );
  }

  Widget _buildAvailabilityPane(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(25.0),
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
                _availabilityList,
              ],
            )
          )
        )
      ),
    );
  }

  Widget _buildPhotoPane(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(25.0),
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
              ImageSelector(key:_imageSelector)
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildValidationPane(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(top: 25.0, left:25.0, right: 25.0, bottom: 10.0),
        child: Column(
          children: <Widget>[
            Row(
                children: <Widget>[
                  Checkbox(
                    value: _hasAcceptedEULA,
                    onChanged: (newValue){
                      setState(() {
                        _hasAcceptedEULA = newValue;
                      });
                    },
                  ),
                  Flexible(
                      child : Text("J'accepte les conditions générales de l'application TROPS")
                  )
                ]
            ),
            MaterialButton(
              color: Colors.green,
              onPressed: _isUploadProcessing ? null : _uploadAdvert,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: (_isUploadProcessing) ? CircularProgressIndicator( valueColor: AlwaysStoppedAnimation<Color>(Colors.black))
                                           : Text("Créer l'annonce",style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold,color: Colors.white))
            ),
          ],
        ),
      ),
    );
  }

  String _selectedCategory(){
    if (_loadingCategory){
      return null;
    } else {
      return _categorySelector.selectedCategory();
    }
  }

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

  bool _checkFields(){
    return (
        _titleController.text.isNotEmpty &&
        _priceController.text.isNotEmpty &&
        _isPriceValid &&
        _selectedCategory() != null &&
        locationSearchBar.getSelectedLocation() != null
    ); //check if all REQUIRED field have a value
  }

  void _uploadAdvert() async {

    FocusScope.of(context).unfocus();

    if(!_checkFields()) { //if the user have correctly completed the form
      _showUploadResult(context, ResultType.denied); // we warn him that he can't create the advert
      return;
    }

    if (!_hasAcceptedEULA){
      return;
    }

    setState(() {
      _isUploadProcessing = true; //We transform the button into loading circle (the button is disabled)
    });

    try {
      var response = await uploadAdvertApi(
          User.current.getToken(),
          _titleController.text,
          double.parse(_priceController.text),
          _descriptionController.text,
          _selectedCategory(),
          User.current.getEmail(),
          _imageSelector.currentState.getAllPaths(),
          _availabilityList.availability,
          locationSearchBar.getSelectedLocation()); // we try to contact the API to add the advert

      if (response.statusCode != 201){ //if the response is not 201, the advert wasn't created for some reasons
        _showUploadResult(context,ResultType.failure); //we warn the user that the process failed
      }
      else{ // the response is 201, the creation was a sucess
        _showUploadResult(context,ResultType.success); // we warn him that it's a success
      }
    } catch (error){
      print(error);
      _showUploadResult(context,ResultType.failure);
    } finally {
      setState(() {
        _isUploadProcessing = false; //the button is show again (before pop context)
      });
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

    _kPanes = <Widget>[
      _buildTitleDescPane(),
      _buildCategoryPane(),
      _buildLocationPane(),
      _buildAvailabilityPane(),
      _buildPhotoPane(),
      _buildValidationPane(),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Création d'une annonce", style: TextStyle(fontSize: 25.0)),
      ),
      bottomNavigationBar: TropsBottomAppBar(),
      floatingActionButton: Visibility(
        visible: _dockedFabVisibility(context),
        child:FloatingActionButton(
          backgroundColor: Colors.green,
          child: _fabIcon,
          onPressed: (){
            setState(() {
              if (!_tabController.indexIsChanging){
                if (_tabController.index < _kPanes.length-1){
                  _tabController.animateTo(_tabController.index+1);
                } else {
                  _uploadAdvert();
                }
              }
            });
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      body: /*GestureDetector(
        onTap: (){
          FocusScope.of(context).requestFocus(new FocusNode());
        },*/
     Padding(
        padding: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              TabPageSelector(
                controller: _tabController,
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _kPanes,
                )
              )
            ]
          ),
        )
    );
  }

  static _dockedFabVisibility(context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      return false;
    } else {
      return true;
    }
  }
}



