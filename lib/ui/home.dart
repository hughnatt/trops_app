import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trops_app/api/data.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/widgets/advertTile.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trops_app/widgets/trops_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({ Key key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Advert> _adverts = new List<Advert>();
  List<String> _categories = new List<String>();

  @override
  void initState(){
    super.initState();
    loadAdverts();
    loadCategories();
  }

  loadCategories() async {

    getCategories().then( (List<String> res) {
      setState(() {
        _categories = res;
      });
    });
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

    Widget searchBar =
    Container(
      padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 0),
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
                Expanded(
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
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );

    return WillPopScope(
        onWillPop: () async => false,
        child: TropsScaffold(
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
        )
    );

  }
}
