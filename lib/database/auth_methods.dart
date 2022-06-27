import 'package:fers/widgets/custom_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'user_api.dart';
import 'userlocaldata.dart';
import '../models/appuser.dart';

class AuthMethods {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static User? get getCurrentUser => _auth.currentUser;
  Future<User?> signupWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth
          .createUserWithEmailAndPassword(
        email: email.toLowerCase().trim(),
        password: password.trim(),
      )
          .catchError((Object obj) {
        CustomToast.errorToast(message: obj.toString());
      });
      final User? user = result.user;
      assert(user != null);
      return user;
    } catch (signUpError) {
      CustomToast.errorToast(message: signUpError.toString());
      return null;
    }
  }

  Future<User?> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential result = await _auth
          .signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      )
          .catchError((Object obj) {
        CustomToast.errorToast(message: obj.toString());
      });
      final User? user = result.user;
      final AppUser appUser = await UserAPI().getInfo(uid: user!.uid);
      UserLocalData().storeAppUserData(appUser: appUser);
      return user;
    } catch (signUpError) {
      CustomToast.errorToast(message: signUpError.toString());
      return null;
    }
  }

  Future<bool> forgetPassword(String email) async {
    try {
      _auth.sendPasswordResetEmail(email: email.trim());
      return true;
    } catch (error) {
      CustomToast.errorToast(message: error.toString());
    }
    return false;
  }

  Future<bool> deleteUser(String pass) async {
    try {
      await _auth
          .signInWithEmailAndPassword(
        email: UserLocalData.getEmail,
        password: pass,
      )
          .catchError((Object obj) {
        CustomToast.errorToast(message: obj.toString());
        return false;
      });
      await UserAPI().deleteUser();
      await _auth.currentUser?.delete();
      await signOut();
      return true;
    } catch (error) {
      CustomToast.errorToast(message: error.toString());
    }
    return false;
  }

  Future<void> signOut() async {
    UserLocalData.signout();
    await _auth.signOut();
  }
}
