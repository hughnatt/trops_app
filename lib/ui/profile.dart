import 'package:flutter/material.dart';
import 'package:trops_app/api/auth.dart';
import 'package:trops_app/models/User.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trops_app/widgets/trops_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final User user;
  const ProfilePage({Key key, @required this.user}) : super(key : key);

  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{

  @override
  void initState() {
    super.initState();
    // Make sure we have an user logged in
    // If not, redirect to authentication screen
    if (User.current == null){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        Navigator.of(context).pushNamed("/auth");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TropsScaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon : Icon(FontAwesomeIcons.cogs),
                        onPressed: null,
                      ),
                      Material(
                        elevation: 4.0,
                        shape: CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        color: Colors.transparent,
                        child: Ink.image(
                          image: NetworkImage("https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Opera_House_and_ferry._Sydney.jpg/220px-Opera_House_and_ferry._Sydney.jpg"),
                          fit: BoxFit.cover,
                          width: 120.0,
                          height: 120.0,
                          child: InkWell(
                            onTap: () {},
                          ),
                        ),
                      ),
                      IconButton(
                        icon : Icon(FontAwesomeIcons.signOutAlt),
                        onPressed: () => _logout()
                      ),
                    ],
                  ),
                ),

                Text(
                    widget.user.getName(),
                    textAlign: TextAlign.center,
                    textScaleFactor: 2.0,
                    style: TextStyle(fontWeight: FontWeight.bold)
                ),
                Text(
                  widget.user.getEmail(),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.only(top : 20.0),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mes locations",
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.5,
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: Center(child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Opera_House_and_ferry._Sydney.jpg/220px-Opera_House_and_ferry._Sydney.jpg")),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Mes annonces",
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.5,
                  ),
                ),
                SizedBox(
                  height: 300,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: 15,
                    itemBuilder: (BuildContext context, int index) => Card(
                      child: Center(child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/c/c0/Opera_House_and_ferry._Sydney.jpg/220px-Opera_House_and_ferry._Sydney.jpg")),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
    );
  }

  void _logout() {
    print("Logging out");
    signOff(User.current);
    User.current = null;
    Navigator.pop(context);
    Navigator.pushNamed(context, "/auth");
  }
}