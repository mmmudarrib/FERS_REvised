import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fers/widgets/custom_toast.dart';
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
      // ignore: invalid_return_type_for_catch_error
      return false;
    });
    return true;
  }
}
