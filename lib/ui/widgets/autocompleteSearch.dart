import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:trops_app/core/data/location_repository.dart';
import 'package:trops_app/core/entity/location.dart';

class Autocomplete extends StatefulWidget {

  final LocationRepository locationRepository;

  const Autocomplete({
    Key key,
    @required this.locationRepository
  }) : super(key: key);

  @override
  AutocompleteState createState() => AutocompleteState();
}

class AutocompleteState extends State<Autocomplete> with AutomaticKeepAliveClientMixin<Autocomplete>{

  final TextEditingController _typeAheadController = TextEditingController();
  Location _selectedLocation;

  Location getSelectedLocation() {
    return _selectedLocation;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return TypeAheadField(
      noItemsFoundBuilder: (context) {
        return ListTile(
          title: Text("Aucune suggestion"),
        );
      },
      autoFlipDirection: true,
      textFieldConfiguration: TextFieldConfiguration(
          controller: this._typeAheadController,
          decoration: InputDecoration(
            hintText: 'Adresse',
            icon: Icon(Icons.gps_fixed),
            border: InputBorder.none,
          )
      ),
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion.getLabel()),
        );
      },
      suggestionsCallback: (text) async {
        return await widget.locationRepository.query(text);
      },
      onSuggestionSelected: (suggestion) {
        this._typeAheadController.text = suggestion.getLabel();
        this._selectedLocation = suggestion;
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}