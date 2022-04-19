import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fers/database/user_api.dart';
import 'package:fers/database/userlocaldata.dart';
import 'package:fers/models/appuser.dart';
import 'package:fers/models/sosrequest.dart';
import 'package:fers/pages/driver_main_pages/driver_map_page.dart';
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
  @override
  void initState() {
    super.initState();
    updatelocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Driver Dashboard')),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "SOS Request",
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: FutureBuilder<Sosrequest?>(
                    future: getrequests(),
                    builder: (BuildContext context,
                        AsyncSnapshot<Sosrequest?> snapshot) {
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
                                int x = snapshot.data!.status;
                                return Column(
                                  children: [
                                    Center(
                                      child: Image.asset("assets/car-icon.png"),
                                    ),
                                    FlatButton(
                                        color: Colors.red,
                                        minWidth: 100,
                                        onPressed: () async {
                                          AppUser user = await UserAPI()
                                              .getInfo(
                                                  uid: snapshot.data!.userUid);
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder:
                                                      (BuildContext context) =>
                                                          DriverMap(user)));
                                        },
                                        child: const Text("Respond"))
                                  ],
                                );
                              } else {
                                return const SizedBox();
                              }
                            }
                          }
                      }
                      return const SizedBox();
                    }),
              ),
            ),
          ],
        ));
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

  Future<Sosrequest?> getrequests() async {
    Sosrequest? _req;
    final QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('request')
        .where('status', isNotEqualTo: 0)
        .get();
    for (DocumentSnapshot<Map<String, dynamic>> element in doc.docs) {
      final Sosrequest _temp = Sosrequest.fromJson(element.data()!);
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
