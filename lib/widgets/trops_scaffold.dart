import 'package:flutter/material.dart';
import 'package:trops_app/widgets/trops_bottom_bar.dart';
import 'package:trops_app/widgets/trops_fab.dart';

class TropsScaffold extends StatelessWidget {

  final Widget body;
  Widget appBar;

  TropsScaffold({Key key, @required this.body, this.appBar}) : super(key : key);

  final Drawer drawer;
  final Key scaffoldKey;

  TropsScaffold({Key key, this.scaffoldKey, @required this.body, this.drawer}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this.appBar,
      key: this.scaffoldKey,
      body: this.body,
      drawer: this.drawer,
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