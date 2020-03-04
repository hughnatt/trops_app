import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:trops_app/api/location.dart';
import 'package:trops_app/models/Location.dart';

class Autocomplete extends StatelessWidget {

  final TextEditingController _typeAheadController = TextEditingController();
  Location _selectedLocation;

  Location getSelectedLocation(){
    return this._selectedLocation;
  }

  @override
  Widget build(BuildContext context) {

    return TypeAheadField(
      noItemsFoundBuilder: (context) {
        return ListTile(
          title: Text("Aucune suggestion"),
          leading: Icon(Icons.error_outline),
        );
      },
      autoFlipDirection: true,
      textFieldConfiguration: TextFieldConfiguration(
          controller: this._typeAheadController,
          decoration: InputDecoration(
            hintText: 'Adresse',
            border: InputBorder.none,
          )
      ),
      itemBuilder: (context, suggestion) {
        return ListTile(
          leading: Icon(Icons.gps_fixed),
          title: Text(suggestion.getLabel()),
        );
      },
      suggestionsCallback: (text) async {
        return await query(text);
      },
      onSuggestionSelected: (suggestion) {
        this._typeAheadController.text = suggestion.getLabel();
        this._selectedLocation = suggestion;
      },
    );
  }
}