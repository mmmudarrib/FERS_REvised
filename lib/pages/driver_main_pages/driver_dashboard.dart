import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fers/database/auth_methods.dart';
import 'package:fers/database/userlocaldata.dart';
import 'package:fers/models/appuser.dart';
import 'package:fers/models/sosrequest.dart';
import 'package:fers/pages/auth/login.dart';
import 'package:fers/pages/driver_main_pages/driver_map_page.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
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
        appBar: AppBar(
          title: const Text(
            'Driver Dashboard',
          ),
          actions: [
            InkWell(
              child: const Icon(Icons.logout),
              onTap: () {
                AuthMethods().signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const LoginScreen()));
              },
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "SOS Request",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('request')
                      .where('status', isEqualTo: 1)
                      .where('driver_uid', isEqualTo: UserLocalData.getUID)
                      .snapshots(),
                  builder: (context, snapshots) {
                    if (!snapshots.hasData || snapshots.data!.docs.isEmpty) {
                      return const Center(
                        child: Text(
                          'No Requests available',
                        ),
                      );
                    } else {
                      return ListView.separated(
                          itemBuilder: (context, index) {
                            Sosrequest sosrequest = Sosrequest.fromJson(
                                snapshots.data!.docs[index].data());
                            return ListTile(
                              title: const Text("Request"),
                              leading: const Icon(
                                Icons.emergency,
                                color: Colors.red,
                              ),
                              trailing: InkWell(
                                child: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              DriverMap(sosrequest.userUid)));
                                },
                              ),
                            );
                          },
                          separatorBuilder: (context, index) =>
                              const Divider(color: Colors.black),
                          itemCount: snapshots.data!.docs.length);
                    }
                  },
                ),
              ),
            ),
          ],
        ));
  }

  Future<void> _getLocation() async {
    Location location = Location();
    LocationData _locationData;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    setState(() {
      _currentLocation = LocationUser(
          lat: _locationData.latitude!, long: _locationData.longitude!);
    });
  }

  void updatelocation() async {
    await _getLocation();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(UserLocalData.getUID)
        .update({'location': _currentLocation.toJson()});
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
}
