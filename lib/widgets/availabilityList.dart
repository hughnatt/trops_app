import 'package:flutter/cupertino.dart';
import 'package:trops_app/models/DateRange.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class AvailabilityList extends StatefulWidget {
  final List<DateRange> availability;

  AvailabilityList({@required this.availability,Key key}) : super(key : key);


  _AvailabilityList createState() => _AvailabilityList();

}

class _AvailabilityList extends State<AvailabilityList> {

  //List<DateRange> availability;

  @override
  void initState(){
    super.initState();
    setState(() {
      if(widget.availability.length == 0){
        widget.availability.add(DateRange(DateTime.now(), DateTime.now()));
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
    ListView.builder(
    shrinkWrap: true,
        itemCount: widget.availability.length,
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
                    DateFormat('dd/MM/yy').format(widget.availability[index].start)
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
                    DateFormat('dd/MM/yy').format(widget.availability[index].end)
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
                onPressed: (widget.availability.length <= 1) ? null : () {
                  {
                    setState(() {
                      widget.availability.removeAt(index);
                    });
                  }
                },
              ),
            ],
          );
        }
    ),

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
              widget.availability.add(DateRange(DateTime.now(), DateTime.now()));
            });
          },
        ),
      ],
    );
  }

  Future<Null> _selectDate(BuildContext context, int index, bool start) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: start ? DateTime.now() : widget.availability[index].start,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked.isAfter(DateTime.now())){
      if (start){
        setState(() {
          widget.availability[index].start = picked;
          if (picked.isAfter(widget.availability[index].end)){
            widget.availability[index].end = picked;
          }
        });
      } else {
        setState(() {
          widget.availability[index].end = picked;
          if (picked.isBefore(widget.availability[index].start)){
            widget.availability[index].start = picked;
          }
        });
      }
    }
  }


}