import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fers/models/sosrequest.dart';
import 'package:fers/widgets/custom_toast.dart';
import 'package:geolocator/geolocator.dart';
import '../models/appuser.dart';

class UserAPI {
  static const String _collection = 'users';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  Future<AppUser> getInfo({required String uid}) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _instance.collection(_collection).doc(uid).get();
    return AppUser.fromDocument(doc);
  }

  Future<bool> addUser(AppUser appUser) async {
    await _instance
        .collection(_collection)
        .doc(appUser.uid)
        .set(appUser.toMap())
        .catchError((Object e) {
      CustomToast.errorToast(message: e.toString());
      return false;
    });
    return true;
  }

  Future<AppUser?> allDriversnearby(LocationUser locationUser) async {
    AppUser? _user;
    double min = double.maxFinite;
    final QuerySnapshot<Map<String, dynamic>> doc = await _instance
        .collection(_collection)
        .where('isDriver', isEqualTo: true)
        .get();
    for (DocumentSnapshot<Map<String, dynamic>> element in doc.docs) {
      final AppUser _temp = AppUser.fromDocument(element);
      double dis = Geolocator.distanceBetween(_temp.location.lat,
          _temp.location.long, locationUser.long, locationUser.long);
      if (dis <= min) {
        min = dis;
        _user = _temp;
      }
    }
    return _user;
  }

  Future<List<Sosrequest>> getsosrequests(String useruid) async {
    List<Sosrequest> requests = <Sosrequest>[];
    final QuerySnapshot<Map<String, dynamic>> doc = await _instance
        .collection('request')
        .where('user_uid', isEqualTo: useruid)
        .get();
    for (DocumentSnapshot<Map<String, dynamic>> element in doc.docs) {
      final Sosrequest _temp = Sosrequest.fromJson(element.data()!);
      requests.add(_temp);
    }
    return requests;
  }
}
