import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:trops_app/api/category.dart';
import 'package:trops_app/api/advert.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/models/TropsCategory.dart';
import 'package:trops_app/ui/search.dart';
import 'package:trops_app/widgets/advertTile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trops_app/widgets/monetization.dart';
import 'package:trops_app/widgets/trops_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Advert> _adverts = new List<Advert>();
  List<TropsCategory> _categories = new List<TropsCategory>();
  bool _loadingCategories = true;
  bool _loadingAdverts = true;

  @override
  void initState(){
    super.initState();
    loadCategories();
  }

  loadCategories() async {
    setState(() {
      _loadingCategories = true;
    });
    getCategories().then( (List<TropsCategory> res) {
      setState(() {
        _categories = res;
        _loadingCategories = false;
        loadAdverts();
      });
    });
  }

  loadAdverts() async {
    setState(() {
      _loadingAdverts = true;
    });
    getAllAdverts().then( (List<Advert> res) {
      setState(() {
        _adverts = res;
        _loadingAdverts = false;
      });
    });
  }

  Widget _getListViewWidget(){

    var list = ListView.builder(
      itemCount: _adverts.length + 1,
      padding: EdgeInsets.only(top: 5.0),
      itemBuilder: (context, index) {
        if (index == 0){
          return MonetizedTile();
        }
        return AdvertTile(
          advert: _adverts[index-1],
        );
      },
    );

    if (_loadingAdverts){
      return SpinKitDoubleBounce(
        color: Colors.blueAccent,
        size: 50,
      );
    } else if (_adverts.length == 0){
      return Center(child: Text("Aucune annonce"));
    } else {
      return list;
    }
  }

  Widget _getListCategories(){

    ListView _listCategories = ListView.separated(
      separatorBuilder: (context,index) => SizedBox(width: 10),
      scrollDirection: Axis.horizontal,
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        return _categoryItemWidget(index);
      }
    );

    if (_loadingCategories){
      return SpinKitDoubleBounce(
        color: Colors.blueAccent,
        size: 50,
      );
    } else {
      return Padding(
        padding: EdgeInsets.only(left: 10, right: 10),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overscroll) {
            overscroll.disallowGlow();
            return false;
          },
          child : _listCategories,
        ),
      );
    }
  }

  Widget _categoryItemWidget(index) {

    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SearchResultPage(preSelectedCategories: [_categories[index].id],),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                height:108,
                width: 192,
                child: Image.network(_categories[index].thumbnail)
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 50),
              child: Material(
                elevation: 10,
                color: Colors.transparent,
                child: Text(
                    _categories[index].title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    )
                )
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: 5),
              child: Material(
                  elevation: 10,
                  color: Colors.transparent,
                  child: Text(
                      _categories[index].description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Colors.white,
                      )
                  )
              ),
            )
          ],
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    Widget searchBar = Padding(
      padding: EdgeInsets.only(top: 10, left: 10,right: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, "/search");
        },
        child: Hero(
          tag: 'heroSearchBar',
          child: Material(
            borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
            elevation: 2.0,
            child: Container(
              height: 45.0,
              margin: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.search,
                    color: Theme.of(context).accentColor,
                  ),

                  Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image(
                            image: AssetImage("assets/trops_logo_866.png"),
                            height: 28,
                          ),
                          Text(
                              "  TROPS",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.black45,
                                fontWeight: FontWeight.bold)
                          )
                        ],
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 40),
                  )

                  /*Expanded(
                child: TextField(
                  maxLines: 1,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.search,
                        color: Theme.of(context).accentColor,
                      ),
                      border: InputBorder.none),
                  onTap: ()  => Navigator.pushNamed(context, "/search"),
                  readOnly: true,
                ),
              ),*/
                ],
              ),
            ),
          ),
        ),
      )
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: TropsScaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              searchBar,
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Catégories',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 20,
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child:  _getListCategories(),
              ),
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  'Dernières annonces',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontSize: 20,
                  ),
                ),
              ),
              Flexible(
                child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: () {
                    loadAdverts();
                    _refreshController.refreshCompleted();
                  },
                  child: _getListViewWidget(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
