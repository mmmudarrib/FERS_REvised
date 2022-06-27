import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.city,
    this.phone,
    this.isDriver = false,
    this.status = true,
    this.timestamp,
    required this.location,
  });
  final String uid;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? city;
  final bool? status;
  final bool? isDriver;
  final String? timestamp;
  final LocationUser location;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'firstname': firstName.trim(),
      'lastname': lastName.trim(),
      'email': email.trim(),
      'isDriver': isDriver ?? false,
      'status': status ?? true,
      'phone': phone ?? '',
      'city': city ?? '',
      'location': location.toJson(),
      'timestamp': timestamp ?? DateTime.now(),
    };
  }

  // ignore: sort_constructors_first
  factory AppUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return AppUser(
      uid: doc.data()!['uid'].toString(),
      firstName: doc.data()!['firstname'].toString(),
      lastName: doc.data()!['lastname'].toString(),
      email: doc.data()!['email'].toString(),
      isDriver: doc.data()!['isDriver'] ?? false,
      status: doc.data()!['status'] ?? true,
      city: doc.data()!['city'] ?? '',
      phone: doc.data()!['phone'] ?? '',
      location: (doc['location'] != null
          ? LocationUser.fromJson(doc['location'])
          : null)!,
      timestamp: doc.data()!['timestamp'].toString(),
    );
  }
}

class LocationUser {
  LocationUser({required this.lat, required this.long});
  LocationUser.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }
  double lat = 0.00;
  double long = 0.00;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = lat;
    data['long'] = long;
    return data;
  }
}
