import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fers/database/user_api.dart';
import 'package:fers/database/userlocaldata.dart';
import 'package:fers/models/appuser.dart';
import 'package:fers/models/sosrequest.dart';
import 'package:fers/pages/user_main_screen/main_pages/map_page.dart';
import 'package:fers/widgets/custom_toast.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ContainerWidget extends StatefulWidget {
  const ContainerWidget({Key? key}) : super(key: key);

  @override
  _ContainerWidgetState createState() => _ContainerWidgetState();
}

class _ContainerWidgetState extends State<ContainerWidget> {
  LocationUser _currentLocation = UserLocalData.getLocation;
  @override
  void initState() {
    _currentLocation = UserLocalData.getLocation;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
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
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: MediaQuery.of(context).size.height / 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(),
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
                  onTap: () {
                    showConfirmationDialog(context);
                  },
                  child: SizedBox(
                    width: 400,
                    height: 400,
                    child: Container(
                      margin: const EdgeInsets.all(100.0),
                      decoration: const BoxDecoration(
                          color: Colors.redAccent, shape: BoxShape.circle),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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

  showConfirmationDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return CustomDialog(
          currentLocation: _currentLocation,
        );
      },
    );
  }
}

class CustomDialog extends StatefulWidget {
  final LocationUser currentLocation;
  const CustomDialog({Key? key, required this.currentLocation})
      : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  bool _sossent = false;
  int mag = 0;
  final List<bool> _isChecked = [false, false, false];
  bool canUpload = false;
  final List<String> _texts = ["Ambulance", "Police", "Fire Brigade"];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Magnitude'),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 5,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(8.0),
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _texts.length,
                      itemBuilder: (_, index) {
                        return CheckboxListTile(
                          title: Text(_texts[index]),
                          value: _isChecked[index],
                          onChanged: (val) {
                            setState(() {
                              _isChecked[index] = val!;
                              canUpload = val;
                              for (var item in _isChecked) {
                                if (item == true) {
                                  canUpload = true;
                                }
                              }
                            });
                          },
                        );
                      },
                    ),
                  ]),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: TextButton(
              onPressed: () async {
                if (canUpload) {
                  await sendsos();
                } else {
                  CustomToast.errorToast(message: "Select a Magnitude First");
                }
              },
              child: Text('Request Service',
                  style:
                      TextStyle(color: canUpload ? Colors.blue : Colors.grey)),
            )),
        SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ))
      ],
    );
  }

  Future<void> sendsos() async {
    if (!_sossent) {
      AppUser? user = await UserAPI().allDriversnearby(widget.currentLocation);
      Sosrequest sos = Sosrequest(
          userUid: UserLocalData.getUID,
          driverUid: user!.uid,
          status: 1,
          magnitude: 1);

      await FirebaseFirestore.instance
          .collection('request')
          .doc(UserLocalData.getUID + "-" + user.uid)
          .set(sos.toJson());
      setState(() {
        _sossent = true;
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => MyMap(user.uid)));
    }
  }
}
