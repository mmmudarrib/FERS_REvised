import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  AppUser({
    required this.uid,
    required this.first_name,
    required this.last_name,
    required this.email,
    this.isDriver = false,
    this.status = true,
    this.timestamp,
    this.imageURL = '',
  });
  final String uid;
  final String first_name;
  final String last_name;
  final String email;
  final bool? status;
  final bool? isDriver;
  final String? imageURL;
  final String? timestamp;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'firstname': first_name.trim(),
      'lastname': last_name.trim(),
      'name': first_name.trim(),
      'email': email.trim(),
      'isDriver': isDriver ?? false,
      'status': status ?? true,
      'imageURL': imageURL ?? '',
      'timestamp': timestamp ?? DateTime.now(),
    };
  }

  // ignore: sort_constructors_first
  factory AppUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return AppUser(
      uid: doc.data()!['uid'].toString(),
      first_name: doc.data()!['firstname'].toString(),
      last_name: doc.data()!['lastname'].toString(),
      email: doc.data()!['email'].toString(),
      isDriver: doc.data()!['isDriver'] ?? false,
      status: doc.data()!['status'] ?? true,
      imageURL: doc.data()!['imageURL'] ?? '',
      timestamp: doc.data()!['timestamp'].toString(),
    );
  }
}
