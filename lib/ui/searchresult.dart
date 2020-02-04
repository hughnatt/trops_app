import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SearchResultPage extends StatelessWidget {

  SearchResultPage({Key key, this.title}) : super(key: key);

  final String title;
  String search = 'hello';

  Widget _showResult () {
    return GridView.count(
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Card(
          color: Colors.red,
          child: Container(
            child: Text(search),
          ),
        ),
        Card(
          color: Colors.red,
          child: Container(
            child: Text(search),
          ),
        ),
        Card(
          color: Colors.red,
          child: Container(
            child: Text(search),
          ),
        ),
      ],
    );
  }

  Widget _searchBar(){
    return Container(
      padding: new EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
      margin: const EdgeInsets.only(),
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
                        ),
                        border: InputBorder.none),
                    onSubmitted: onSubmitted,
                    onChanged: onSubmitted,
                  ))
            ],
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body:  Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[

              SizedBox(height: 20.0),

              _searchBar(),

              Expanded(
                child: _showResult(),
              ),

            ],
        ),

    );
  }

  onSubmitted(query) async {
    print(query);
    search = query;
  }
}