class sosrequest {
  String? userUid;
  String? driverUid;
  int? status;

  sosrequest({this.userUid, this.driverUid, this.status});

  sosrequest.fromJson(Map<String, dynamic> json) {
    userUid = json['user_uid'];
    driverUid = json['driver_uid'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_uid'] = this.userUid;
    data['driver_uid'] = this.driverUid;
    data['status'] = this.status;
    return data;
  }
}
