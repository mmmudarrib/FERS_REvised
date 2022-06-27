import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fers/database/user_api.dart';
import 'package:fers/models/appuser.dart';
import 'package:fers/pages/driver_main_pages/driver_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:url_launcher/url_launcher.dart';

class DriverMap extends StatefulWidget {
  final String user;
  const DriverMap(this.user, {Key? key}) : super(key: key);
  @override
  _DriverMapState createState() => _DriverMapState();
}

class _DriverMapState extends State<DriverMap> {
  late BitmapDescriptor customIcon;

  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  late AppUser user;
  bool loading = true;
  bool _added = false;
  final loc.Location _location = loc.Location();
  loc.LocationData locationData = loc.LocationData.fromMap(
      {'latitude': 31.60136584024547, 'longitude': 73.03538797427933});
  bool init = false;
  @override
  void initState() {
    super.initState();
    getinfo();
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(16, 16)), 'assets/car-icon.png')
        .then((d) {
      setState(() {
        init = true;
      });
      customIcon = d;
    });
    _location.onLocationChanged.listen((loc.LocationData loc) {
      if (_added) {
        setState(() {
          locationData = loc;
        });
        mymap(loc);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text(""),
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.purple,
          leading: Image.asset('assets/splash.png'),
        ),
        body: init
            ? Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    markers: {
                      Marker(
                          position: LatLng(
                            locationData.latitude!,
                            locationData.longitude!,
                          ),
                          markerId: const MarkerId('eae'),
                          icon: customIcon),
                      Marker(
                          position:
                              LatLng(user.location.lat, user.location.long),
                          markerId: const MarkerId('id'),
                          icon: customIcon),
                    },
                    initialCameraPosition: CameraPosition(
                        target: LatLng(
                          locationData.latitude!,
                          locationData.longitude!,
                        ),
                        zoom: 14.47),
                    onMapCreated: (GoogleMapController controller) async {
                      setState(() {
                        _controller = controller;
                        _added = true;
                      });
                    },
                  ),
                  Positioned(
                    bottom: 30,
                    left: 30,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50))),
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.80,
                      child: Center(
                        child: ListTile(
                          leading: const CircleAvatar(
                            radius: 30,
                            backgroundImage: AssetImage('assets/Profile.png'),
                          ),
                          title: Text(user.firstName + " " + user.lastName),
                          subtitle: TextButton(
                            child: const Text("Reached?"),
                            onPressed: () async {
                              QuerySnapshot<Map<String, dynamic>>
                                  querySnapshot = await FirebaseFirestore
                                      .instance
                                      .collection('request')
                                      .where('user_uid', isEqualTo: user.uid)
                                      .where('status', isEqualTo: 1)
                                      .get();
                              await FirebaseFirestore.instance
                                  .collection('request')
                                  .doc(querySnapshot.docs.first.id)
                                  .update({'status': 2}) // <-- Updated data
                                  .then((_) => Navigator.of(context)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              const DriverDashboard())))
                                  .catchError(
                                      (error) => print('Failed: $error'));
                            },
                            // style: ButtonStyle(backgroundColor: Colors.blue),
                          ),
                          trailing: InkWell(
                            child: const Icon(Icons.navigation),
                            onTap: () {
                              openmap();
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            : const CircularProgressIndicator(),
      );
    }
  }

  Future<void> mymap(loc.LocationData locationData) async {
    await _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(locationData.latitude!, locationData.longitude!),
            zoom: 14.47)));
  }

  Future<void> openmap() async {
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

  Future<void> getinfo() async {
    AppUser userw = await UserAPI().getInfo(uid: widget.user);
    setState(() {
      user = userw;
      loading = false;
    });
  }
}
