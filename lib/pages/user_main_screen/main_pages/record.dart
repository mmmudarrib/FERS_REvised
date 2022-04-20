import 'package:fers/database/user_api.dart';
import 'package:fers/database/userlocaldata.dart';
import 'package:fers/models/sosrequest.dart';
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
            child: FutureBuilder<List<Sosrequest>>(
                future: UserAPI().getsosrequests(UserLocalData.getUID),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return const Center(
                      child: Text("No Requests Found"),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 6,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(
                              Icons.emergency,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.red,
                          ),
                          title: Text('Request no ${index + 1}'),
                          subtitle: Text(
                              "Date: ${snapshot.data![index].date} \n Lat:${snapshot.data![index].lat},long:${snapshot.data![index].long} \n Responded by: Hashir"),
                          trailing: const Icon(
                            Icons.map,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    );
                  }
                })));
  }
}
