import 'package:flutter/material.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Records",
            style: TextStyle(color: Colors.white),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.purple,
          elevation: 0,
        ),
        body: SafeArea(
            child: ListView.builder(
          itemCount: 15,
          itemBuilder: (context, index) => const Card(
            elevation: 6,
            margin: EdgeInsets.all(10),
            child: ListTile(
              leading: CircleAvatar(
                child: Icon(
                  Icons.emergency,
                  color: Colors.white,
                ),
                backgroundColor: Colors.red,
              ),
              title: Text("Ambulance Request"),
              subtitle: Text(
                  "Date:2nd July 2022 \n Location:Faisalabad\n Responded by: Hashir"),
              trailing: Icon(
                Icons.map,
                color: Colors.green,
              ),
            ),
          ),
        )));
  }
}
