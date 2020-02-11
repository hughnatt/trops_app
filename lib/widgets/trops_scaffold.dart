import 'package:flutter/material.dart';
import 'package:trops_app/ui/common/trops_bottom_bar.dart';
import 'package:trops_app/ui/common/trops_fab.dart';

class TropsScaffold extends StatelessWidget {

  final Widget body;

  TropsScaffold({Key key, @required this.body}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: this.body,
      bottomNavigationBar: TropsBottomAppBar(),
      floatingActionButton: Visibility(
          visible: _dockedFabVisibility(context),
          child: TropsFloatingActionButton()
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  static _dockedFabVisibility(context) {
    if (MediaQuery.of(context).viewInsets.bottom != 0) {
      return false;
    } else {
      return true;
    }
  }
}