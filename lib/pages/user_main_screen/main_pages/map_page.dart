import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fers/models/appuser.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;

class MyMap extends StatefulWidget {
  final AppUser userid;
  const MyMap(this.userid, {Key? key}) : super(key: key);
  @override
  _MyMapState createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  late BitmapDescriptor customIcon;

  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  late AppUser user;
  @override
  void initState() {
    super.initState();
    user = widget.userid;
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(size: Size(16, 16)), 'assets/car-icon.png')
        .then((d) {
      customIcon = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help is on the way "),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.purple,
        leading: Image.asset('assets/splash.png'),
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (_added) {
                mymap(snapshot);
              }
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              user = widget.userid;

              return GoogleMap(
                mapType: MapType.normal,
                markers: {
                  Marker(
                      position: LatLng(user.location.lat, user.location.long),
                      markerId: const MarkerId('id'),
                      icon: customIcon),
                },
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      user.location.lat,
                      user.location.long,
                    ),
                    zoom: 14.47),
                onMapCreated: (GoogleMapController controller) async {
                  setState(() {
                    _controller = controller;
                    _added = true;
                  });
                },
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 30,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(),
                  borderRadius: const BorderRadius.all(Radius.circular(50))),
              height: 100,
              width: MediaQuery.of(context).size.width * 0.80,
              child: Center(
                child: ListTile(
                  leading: const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/Profile.png'),
                  ),
                  title: Text(user.firstName + " " + user.lastName),
                  subtitle: const Text("Arriving in 10 mins \n15 Kms away "),
                  trailing: const Icon(Icons.phone),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> mymap(
      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) async {
    user = widget.userid;
    await _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(user.location.lat, user.location.long),
            zoom: 14.47)));
  }
}
