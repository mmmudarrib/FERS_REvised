import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fers/database/user_api.dart';
import 'package:fers/database/userlocaldata.dart';
import 'package:fers/models/appuser.dart';
import 'package:fers/models/sosrequest.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class DriverDashboard extends StatefulWidget {
  const DriverDashboard({Key? key}) : super(key: key);

  @override
  _DriverDashboardState createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  bool online = false;
  LocationUser _currentLocation = UserLocalData.getLocation;
  late Position _currentPosition;
  @override
  void initState() {
    super.initState();
    updatelocation();
  }

  @override
  Widget build(BuildContext context) {
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
                    bool x;
                    if (online) {
                      x = false;
                    } else {
                      x = true;
                    }
                    setState(() {
                      online = x;
                    });
                    updatelocation();
                  },
                  child: SizedBox(
                      width: 400,
                      height: 400,
                      child: Container(
                        margin: const EdgeInsets.all(100.0),
                        decoration: BoxDecoration(
                            color:
                                online ? Colors.greenAccent : Colors.redAccent,
                            shape: BoxShape.circle),
                      )),
                ),
              ],
            ),
          ),
          FutureBuilder<sosrequest?>(
              future: getrequests(),
              builder:
                  (BuildContext context, AsyncSnapshot<sosrequest?> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return const SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: CircularProgressIndicator.adaptive(),
                    );
                  default:
                    if ((snapshot.hasError)) {
                      return _errorWidget();
                    } else {
                      if (snapshot.hasData) {
                        if (snapshot.data != null) {
                          int x = snapshot.data!.status!;
                          return ListTile(
                            title: const Text("SOS REQUEST"),
                            trailing: TextButton(
                              child: (x == 1)
                                  ? const Text("Pick Up")
                                  : const Text("Drop off"),
                              onPressed: () async {
                                AppUser user = await UserAPI()
                                    .getInfo(uid: snapshot.data!.userUid!);
                                await openmap(user);
                              },
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }
                    }
                }
                return const SizedBox();
              }),
        ],
      ),
    );
  }

  void updatelocation() async {
    if (online) {
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

  Future<sosrequest?> getrequests() async {
    sosrequest? _req;
    double min = -100000;
    final QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('request')
        .where('status', isNotEqualTo: 0)
        .get();
    for (DocumentSnapshot<Map<String, dynamic>> element in doc.docs) {
      final sosrequest _temp = sosrequest.fromJson(element.data()!);
      _req = _temp;
    }
    return _req;
  }

  Future<void> openmap(AppUser user) async {
    var latitude = user.location.lat;
    var longitude = user.location.long;
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    bool x = await canLaunch(googleUrl);
    if (!x) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  SizedBox _errorWidget() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Column(
          children: const <Widget>[
            Icon(Icons.info, color: Colors.grey),
            Text(
              'Facing some issues',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
