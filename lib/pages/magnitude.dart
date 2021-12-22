import 'package:flutter/material.dart';

class Magnitude extends StatefulWidget {
  const Magnitude({Key? key}) : super(key: key);

  @override
  _MagnitudeState createState() => _MagnitudeState();
}

class _MagnitudeState extends State<Magnitude> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 20),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.purple,
                      ),
                      onPressed: () => {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        right: MediaQuery.of(context).size.width / 14),
                    child: Container(
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
                  ),
                ],
              ),
            ),
            const Text(
              'Magnitude',
              style: TextStyle(
                  color: Color.fromRGBO(24, 24, 41, 1),
                  fontFamily: 'Abel',
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  height: -1),
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 15),
              child: Container(
                height: MediaQuery.of(context).size.height / 2,
                width: MediaQuery.of(context).size.width / 1.1,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromRGBO(120, 109, 245, 1),
                      Color.fromRGBO(166, 158, 255, 1),
                    ],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50.0),
                    topRight: Radius.circular(50.0),
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: MediaQuery.of(context).size.width/1.3),
              child: TextButton.icon(
                onPressed: null,
                icon: const Icon(
                  Icons.arrow_forward,
                  size: 50,
                ),
                label: const Text(' '),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
