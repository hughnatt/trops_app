import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trops_app/api/data.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/ui/common/trops_bottom_bar.dart';
import 'package:trops_app/ui/common/trops_fab.dart';
import 'package:trops_app/widgets/advert_tile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Advert> _adverts = new List<Advert>();
  List<String> _categories = [
    "Ski",
    "Surf",
    "Foot",
    "Rugby",
    "Tennis",
    "Basket",
    "Volley",
    "Hand",
    "Badminton",
    "Pétanque",
    "Danse"
  ];

  @override
  void initState(){
    super.initState();
    loadAdverts();
  }

  loadAdverts() async {

    getAllAdverts().then( (List<Advert> res) {
      setState(() {
        _adverts = res;
      });
    });

  }

  Widget _getListViewWidget(){
    var list = ListView.builder(
      itemCount: _adverts.length,
      padding: EdgeInsets.only(top: 5.0),
      itemBuilder: (context, index) {
        return AdvertTile(
          advert: _adverts[index],
        );
      },
    );

    return list;

  }

  Widget _getListCategories(){

    ListView _listCategories = ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        return _categoryItemWidget(index);
      }
    );

    return Container(
      child: _listCategories,
    );
  }

  Widget _categoryItemWidget(index) {

    return Center(
      child: Padding(
        padding: EdgeInsets.only(left: 10),
        child: RaisedButton(
          onPressed: () {},
          color: Colors.blue,
          textColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          child: Text(_categories[index]),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {

    Widget searchBar = Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 0),
      child: new Material(
        borderRadius: const BorderRadius.all(const Radius.circular(25.0)),
        elevation: 2.0,
        child: new Container(
          height: 45.0,
          margin: new EdgeInsets.only(left: 16.0, right: 16.0),
          child: new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                    maxLines: 1,
                    decoration: new InputDecoration(
                        icon: Icon(
                          Icons.search,
                          color: Theme.of(context).accentColor,
                        ),
                        border: InputBorder.none),
                    onTap: ()  => Navigator.pushNamed(context, "/search"),
                    readOnly: true,
                  )
              )
            ],
          ),
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            searchBar,
            SizedBox(
              height: 50,
              child: _getListCategories(),
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


      bottomNavigationBar: TropsBottomAppBar(),
      floatingActionButton: TropsFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
