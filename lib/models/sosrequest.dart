class Sosrequest {
  late String userUid;
  late String driverUid;
  late int status;
  late int magnitude;

  Sosrequest(
      {required this.userUid,
      required this.driverUid,
      required this.status,
      required this.magnitude});

  Sosrequest.fromJson(Map<String, dynamic> json) {
    userUid = json['user_uid'];
    driverUid = json['driver_uid'];
    status = json['status'];
    magnitude = json['magnitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_uid'] = userUid;
    data['driver_uid'] = driverUid;
    data['status'] = status;
    data['magnitude'] = magnitude;
    return data;
  }
}
