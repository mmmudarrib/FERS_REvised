class Sosrequest {
  late String userUid;
  late String driverUid;
  late int status;
  late int magnitude;
  late String date;
  late double lat;
  late double long;

  Sosrequest(
      {required this.userUid,
      required this.driverUid,
      required this.status,
      required this.magnitude,
      required this.date,
      required this.lat,
      required this.long});

  Sosrequest.fromJson(Map<String, dynamic> json) {
    userUid = json['user_uid'];
    driverUid = json['driver_uid'];
    status = json['status'];
    magnitude = json['magnitude'];
    lat = json['lat'];
    long = json['long'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_uid'] = userUid;
    data['driver_uid'] = driverUid;
    data['status'] = status;
    data['magnitude'] = magnitude;
    data['lat'] = lat;
    data['long'] = long;
    data['date'] = date;
    return data;
  }
}
