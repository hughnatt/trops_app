import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trops_app/core/data/advert_repository.dart';
import 'package:trops_app/core/data/category_repository.dart';
import 'package:trops_app/core/data/favorite_repository.dart';
import 'package:trops_app/core/data/location_repository.dart';
import 'package:trops_app/core/data/session_repository.dart';
import 'package:trops_app/core/data/user_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:trops_app/core/entity/advert.dart';
import 'package:trops_app/core/entity/date_range.dart';
import 'package:trops_app/core/entity/user.dart';
import 'package:trops_app/ui/adminAdvertView.dart';


class DetailedAdvertPage extends StatefulWidget {

  final Advert advert;
  final UserRepository userRepository;
  final FavoriteRepository favoriteRepository;
  final SessionRepository sessionRepository;
  final AdvertRepository advertRepository;
  final CategoryRepository categoryRepository;
  final LocationRepository locationRepository;

  const DetailedAdvertPage({
    Key key,
    @required this.advert,
    @required this.userRepository,
    @required this.favoriteRepository,
    @required this.sessionRepository,
    @required this.advertRepository,
    @required this.categoryRepository,
    @required this.locationRepository
  }) : super(key: key);

  @override
  _DetailedAdvertPageState createState() => _DetailedAdvertPageState();
}

class _DetailedAdvertPageState extends State<DetailedAdvertPage> {

  int _index = 0;
  User _owner;

  @override
  void initState() {
    super.initState();
    widget.userRepository.getUser(widget.advert.owner).then((User user) {
      setState(() {
        this._owner = user;
      });
    });
  }

  List<Widget> getImagesWidget(){

    List<String> images = widget.advert.photos;
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


  /*void _updateFavoritesProcess(String advertId, favoritesEnum operation) async {
    updateFavorites(advertId,operation).then((listFavorites) {
      setState(() {
        Session.currentUser.setFavorites(listFavorites);
      });
    }).catchError((onError){
      _showErrorAlert(context,"Impossible de terminer l'opération" + onError.toString());
    });
  }*/

  void _addFavoriteProcess(String advertId) async {
    widget.favoriteRepository.addFavorite(advertId).then((listFavorite) {
      setState(() {
        widget.sessionRepository.currentUser().setFavorites(listFavorite);
      });
    }).catchError((onError){
      _showErrorAlert(context,"Impossible d'ajouter l'annonce aux favoris ");
    });
  }

  void _deleteFavoriteProcess(String advertId) async {
    widget.favoriteRepository.deleteFavorite(advertId).then((listFavorite) {
      setState(() {
        widget.sessionRepository.currentUser().setFavorites(listFavorite);
      });
    }).catchError((onError){
      _showErrorAlert(context,"Impossible de supprimer l'annonce des favoris ");
    });
  }



  Widget trailingIcon(BuildContext context){
    User currentUser = widget.sessionRepository.currentUser();
    if (currentUser != null) {
      if (currentUser.id == widget.advert.owner){
        return IconButton(
          icon: Icon(Icons.mode_edit),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder : (context) => AdminAdvertView(
                advert : widget.advert,
                advertRepository: widget.advertRepository,
                categoryRepository: widget.categoryRepository,
                locationRepository: widget.locationRepository,
              ))
          )
        );
      } else {
        if (currentUser.id != widget.advert.owner && currentUser.isInFavorites(widget.advert.id)) { //&& isInUserFavorite(widget.advert.getId())
          return IconButton(icon: Icon(Icons.star), onPressed: () => _deleteFavoriteProcess(widget.advert.id)); //display a star if the current advert is in the user's favorites
        } else {
          return IconButton(icon: Icon(Icons.star_border), onPressed: () => _addFavoriteProcess(widget.advert.id)); //display a empty star if the current advert is not in the user's favorites
        }
      }
    } else {
      return IconButton(icon: Icon(null),onPressed: () => null);
    }
  }

  _showAvailibityCalendar(BuildContext context){

    List<DateRange> allAvailibility = widget.advert.availability;

     showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
              title: Text("Disponibilités"),
              content: ListView.builder(
                  shrinkWrap: true,
                  itemCount: allAvailibility.length,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    String textContent = "Du " + DateFormat('dd/MM/yy').format(allAvailibility[index].start) + " au " + DateFormat('dd/MM/yy').format(allAvailibility[index].end);
                    return Wrap(
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: <Widget>[
                        Text(
                          textContent,
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    );
                  }
              ),
          );
        },
     );
  }

  _showErrorAlert(BuildContext context, String text){
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text("Erreur"),
          content: Text(text),
          actions: <Widget>[
            MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Annuler"),
            )
          ],
        )
    );
  }

  _onCalendarTapped(BuildContext context){
    _showAvailibityCalendar(context);
  }

  _onPhoneTapped(BuildContext context) async {
    try{
      var url = "tel:"+_owner.phoneNumber.toString();
      if(await canLaunch(url)){
        await launch(url);
      }
    }
    catch(err){
      _showErrorAlert(context, "Impossible d'ouvrir le téléphone");
    }
  }

  Widget _buildAdvert(){
    return Column(
      //mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          height: 250.0,
          width: MediaQuery.of(context).size.width,
          child: Hero(
            tag: 'heroAdvertImage_${widget.advert.id}',
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
                      widget.advert.title,
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
                    "${widget.advert.price} €",
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
                    this._owner.name,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.black54,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    widget.advert.category,
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
                widget.advert.description,
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPage(){
    if(_owner == null){
      return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    else {
      return _buildAdvert();
    }
  }

  @override
  Widget build(BuildContext context) {
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
          child: _buildPage(),
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
            title: Text('Disponibilités'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text('Message'),
          ),
        ],
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.black54,
        onTap: (int index) {
          switch(index) {
            case 0:
              if (_owner.phoneNumber != null) {
                _onPhoneTapped(context);
              } else {
                _showErrorAlert(context, "Aucun numéro de téléphone renseigné");
              }
              break;
            case 1:
              _onCalendarTapped(context);
              break;
            case 2:
              break;
          }
        },
        currentIndex: _index,
      ),
    );
  }
}