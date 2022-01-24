import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fers/database/user_api.dart';
import 'package:fers/database/userlocaldata.dart';
import 'package:fers/models/appuser.dart';
import 'package:fers/models/sosrequest.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ContainerWidget extends StatefulWidget {
  const ContainerWidget({Key? key}) : super(key: key);

  @override
  _ContainerWidgetState createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  @override
  LocationUser _currentLocation = UserLocalData.getLocation;
  bool _sossent = false;
  Widget build(BuildContext context) {
    // Figma Flutter Generator ContainerWidget - RECTANGLE

    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height / 34,
          ),
          Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color.fromRGBO(120, 109, 245, 1),
                    Color.fromRGBO(166, 158, 255, 1),
                  ],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(50.0),
                  bottomRight: Radius.circular(50.0),
                )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(
                        Icons.dehaze_sharp,
                        color: Colors.white,
                      ),
                      onPressed: () => {},
                    ),
                    const Text(
                      'FERS',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          letterSpacing:
                              0 /*percentages not used in flutter. defaulting to zero*/,
                          fontWeight: FontWeight.normal,
                          height: 1),
                    ),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: Color.fromRGBO(196, 196, 196, 1),
                        image: DecorationImage(
                          image: AssetImage('assets/Profile.png'),
                          fit: BoxFit.fitWidth,
                        ),
                        borderRadius:
                            BorderRadius.all(Radius.elliptical(25, 25)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 18),
                ),
                Text(
                  'Hello ' + UserLocalData.getName,
                  style: const TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 1),
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                GestureDetector(
                  onDoubleTap: () {
                    sendsos();
                  },
                  child: SizedBox(
                      width: 400,
                      height: 400,
                      child: Container(
                        margin: EdgeInsets.all(100.0),
                        decoration: BoxDecoration(
                            color: _sossent
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            shape: BoxShape.circle),
                      )),
                ),
              ],
            ),
          ),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width / 10),
                  child: const Text(
                    'My Service',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color.fromRGBO(0, 0, 0, 1),
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      height: 1,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 12),
                  child: const Text(
                    'View All',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.red,
                        fontFamily: 'SF Pro Text',
                        fontSize: 12,
                        letterSpacing: 0,
                        fontWeight: FontWeight.normal,
                        height: 1),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void sendsos() async {
    if (!_sossent) {
      AppUser? user = await UserAPI().allDriversnearby(_currentLocation);
      sosrequest sos = sosrequest(
          userUid: UserLocalData.getUID, driverUid: user!.uid, status: 1);

      await FirebaseFirestore.instance
          .collection('request')
          .doc(UserLocalData.getUID + "-" + user.uid)
          .set(sos.toJson());
      setState(() {
        _sossent = true;
      });
    }
  }

  void updatelocation() async {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      LocationUser loc =
          LocationUser(lat: position.latitude, long: position.longitude);
      setState(() {
        _currentLocation = loc;
      });
    });

    await FirebaseFirestore.instance
        .collection('users')
        .doc(UserLocalData.getUID)
        .update({'location': _currentLocation});
  }
}
