import 'package:flutter/material.dart';
import 'package:trops_app/api/auth.dart';
import 'package:trops_app/models/User.dart';
import 'package:flutter/scheduler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trops_app/utils/session.dart';
import 'package:trops_app/widgets/slidingCard.dart';
import 'package:trops_app/widgets/trops_scaffold.dart';
import 'package:trops_app/api/advert.dart';
import 'package:trops_app/models/Advert.dart';
import 'package:trops_app/models/Location.dart';
import 'package:trops_app/ui/menu_profile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key : key);

  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage>{

  PageController pageController;

  List<Advert> _adverts = new List<Advert>();

  User _user;

  @override
  void initState() {
    super.initState();

    // Make sure we have an user logged in
    // If not, redirect to authentication screen
    if (!Session.isAuthenticated){
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pop(context);
        Navigator.of(context).pushNamed("/auth");
      });
    }

    pageController = PageController(viewportFraction: 0.8);


    getAdvertsByUser(Session.currentUser).then((res) {
      setState(() {
        _adverts = res;
      });
    });

    _user = Session.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return TropsScaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Profile", style: TextStyle(
              fontSize: 25.0,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                FontAwesomeIcons.cog,
                color: Colors.white,
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder : (context) => MenuProfile())),
            ),
            IconButton(
              icon: Icon(
                FontAwesomeIcons.signOutAlt,
                color: Colors.white,
              ),
              onPressed: () => _logout(),
            )
          ],
        ),
        body: SafeArea(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(
                          _user.getName(),
                          textAlign: TextAlign.center,
                          textScaleFactor: 2.0,
                          style: TextStyle(fontWeight: FontWeight.bold)
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 10.0),
                      child: Text(
                        _user.getEmail(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      height: 2,
                      width: MediaQuery.of(context).size.width * 0.8,
                      color: Colors.blue,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text("Réservations en cours", style: TextStyle(fontSize: 18),),
                    ),
                    SizedBox(
                      height: 275,
                      child: PageView(
                        controller: pageController,
                        children: <Widget>[
                          SlidingCard(advert: Advert(null,"Titre 1",10,"Je suis une Description",["http://weirdotoys.com/WeirdoToys-V2/wp-content/uploads/2008/11/hulkball-prev-692x386.jpg"],"ariane@ancrenaz.fr","Sports Nautiques",[],Location("","","",[0.0,0.0])),proprietary: false,),
                          SlidingCard(advert: Advert(null,"Titre 1",10,"Je suis une Description",["http://weirdotoys.com/WeirdoToys-V2/wp-content/uploads/2008/11/hulkball-prev-692x386.jpg"],"ariane@ancrenaz.fr","Sports Nautiques",[],Location("","","",[0.0,0.0])),proprietary: false)
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0),
                      child: Text("Mes annonces", style: TextStyle(fontSize: 18),),
                    ),
                    SizedBox(
                      height: 275,
                      child: PageView.builder(itemBuilder: (BuildContext context, int index) {return SlidingCard(
                        advert: _adverts[index],
                        proprietary: true,
                      );},
                        itemCount: _adverts.length,
                        controller: pageController,
                      )

                      /*PageView(
                        controller: pageController,
                        children: <Widget>[
                          SlidingCard(),
                          SlidingCard()
                        ],
                      ),*/
                    ),
                  ],
                ),
              ),
            ),
        )
    );
  }

  void _logout() {
    signOff();
    Navigator.pop(context);
    Navigator.pushNamed(context, "/auth", arguments: "home");
  }
}