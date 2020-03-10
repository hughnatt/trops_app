import 'package:flutter/material.dart';
import 'package:trops_app/models/TropsCategory.dart';



class CategorySelector extends StatefulWidget {

  final List<TropsCategory> categories;

  String _selectedCategoryID;

  CategorySelector({Key key, this.categories}) : super(key: key);

  @override
  _CategorySelectorState createState() => _CategorySelectorState();

  String selectedCategory(){
    return _selectedCategoryID;
  }
}

class _CategorySelectorState extends State<CategorySelector>{


  Widget _buildTiles(TropsCategory root){
    if (root.subcategories.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(left:20, right: 5),
        child: Row(
          children: <Widget>[
            Text(root.title),
            Spacer(),
            Radio<String>(
              value: root.id,
              groupValue: widget._selectedCategoryID,
              onChanged: (String value){
                setState(() {
                  widget._selectedCategoryID = value;
                });
              },
            )
          ],
        ),
      );
    } else {
      return ExpansionTile(
        key: PageStorageKey<TropsCategory>(root),
        title: Row(
          children: <Widget>[
            Text(
              root.title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16
              ),
            ),
          ],
        ),
        children: root.subcategories.map(_buildTiles).toList(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) =>_buildTiles(widget.categories[index]),
      itemCount: widget.categories.length,
    );
  }
}