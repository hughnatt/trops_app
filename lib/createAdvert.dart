import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/box.dart';

class CreateAdvertPage extends StatefulWidget {

  @override
  _CreateAdvertPage createState() => _CreateAdvertPage();
}

class _CreateAdvertPage extends State<CreateAdvertPage> {


  Widget _buildMultilineTextField(int nbLines, String label) {
    return TextField(
      maxLines: nbLines,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        counterText: ' ',
        labelText: label,
        hintText: 'Type something...',
        border: OutlineInputBorder(),
      ),
      onChanged: (text) => setState(() {}),
    );
  }

  Widget _buildPictureGrild(){
    return GridView.count(
      crossAxisCount: 2,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      children: List.generate(3, (index) {
        return Center(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1.0),
            ),
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Picture ' + (index+1).toString(),
              style: Theme.of(context).textTheme.headline,
            ),
          ),
        );
      }),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Advert')
    ),
      body: SafeArea (
        child :
        Card(
            elevation: 20.0,
            margin: EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
            child: ListView(
              padding: EdgeInsets.all(8.0),
              children: <Widget>[
                _buildMultilineTextField(1,'Product name'),
                _buildMultilineTextField(3,'Product description'),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: new BorderRadius.only(
                                  topLeft:  const  Radius.circular(5),
                                  topRight: const  Radius.circular(5),
                                  bottomLeft: const  Radius.circular(5),
                                  bottomRight: const  Radius.circular(5),
                    )
                  ),
                  child: _buildPictureGrild(),
                ),

              ],
            )
            )
      ),
    );



  }
}