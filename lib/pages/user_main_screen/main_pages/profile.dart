import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.purple,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 200,
              height: 200,
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(196, 196, 196, 1),
                  image: DecorationImage(
                    image: AssetImage('assets/Profile.png'),
                    fit: BoxFit.fitWidth,
                  ),
                  shape: BoxShape.circle),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          const Center(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
              ),
              title: Text("Hashir"),
            ),
          ),
          const Center(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.card_travel,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
              ),
              title: Text("33100-000000-0"),
            ),
          ),
          const Center(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.phone,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
              ),
              title: Text("+92-300-8997899"),
            ),
          ),
          const Center(
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
              ),
              title: Text("Faisalabad"),
            ),
          ),
        ],
      ),
    );
  }
}
