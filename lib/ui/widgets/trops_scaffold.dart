import 'package:flutter/material.dart';
import 'package:trops_app/core/data/session_repository.dart';
import 'package:trops_app/ui/widgets/trops_bottom_bar.dart';
import 'package:trops_app/ui/widgets/trops_fab.dart';

class TropsScaffold extends StatelessWidget {

  final Widget body;
  final Drawer drawer;
  final Key scaffoldKey;
  final Widget appBar;
  final SessionRepository sessionRepository;

  const TropsScaffold({
    Key key,
    this.scaffoldKey,
    @required this.sessionRepository,
    this.body,
    this.drawer,
    this.appBar
  }) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: this.appBar,
      key: this.scaffoldKey,
      body: this.body,
      drawer: this.drawer,
      bottomNavigationBar: TropsBottomAppBar(sessionRepository: sessionRepository,),
      floatingActionButton: Visibility(
          visible: _dockedFabVisibility(context),
          child: TropsFloatingActionButton(sessionRepository: sessionRepository,)
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