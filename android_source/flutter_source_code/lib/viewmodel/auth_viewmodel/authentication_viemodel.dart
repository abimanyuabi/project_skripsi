import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_source_code/utility/enums.dart';

class AuthViewmodel with ChangeNotifier {
  AuthStatus authStatus = AuthStatus.standby;
  String failReason = "-";
  final FirebaseAuth firebaseAuthObject = FirebaseAuth.instance;
  User? get currentUser => firebaseAuthObject.currentUser;
  Stream<User?> get authStateChange => firebaseAuthObject.authStateChanges();

  Future<void> authLogin(
      {required String email, required String password}) async {
    authStatus = AuthStatus.loading;
    notifyListeners();
    try {
      await firebaseAuthObject.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      authStatus = AuthStatus.success;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      //fail
      authStatus = AuthStatus.failed;
      failReason = e.message.toString();
      notifyListeners();
    }
    notifyListeners();
    if (firebaseAuthObject.currentUser != null) {
      const secureStorageObject = FlutterSecureStorage();
      User currUser = firebaseAuthObject.currentUser!;
      await secureStorageObject.write(
          key: "curr_user_email", value: currUser.email);
      await secureStorageObject.write(
          key: "curr_user_pass", value: password.trim());
      await secureStorageObject.write(
          key: "curr_user_uid", value: currUser.uid);
    }
    notifyListeners();
  }

  Future<void> authRegister(
      {required String email, required String password}) async {
    authStatus = AuthStatus.loading;
    notifyListeners();
    try {
      await firebaseAuthObject.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      authStatus = AuthStatus.success;
      notifyListeners();
    } catch (e) {
      failReason = e.toString();
      authStatus = AuthStatus.failed;
      notifyListeners();
    }
  }

  Future<void> authLogout() async {
    authStatus = AuthStatus.loading;
    notifyListeners();
    const secureStorageObject = FlutterSecureStorage();
    try {
      await firebaseAuthObject.signOut();
      authStatus = AuthStatus.success;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      //fail
      failReason = e.toString();
    }
    if (firebaseAuthObject.currentUser == null) {
      await secureStorageObject.delete(key: "curr_user_email");
      await secureStorageObject.delete(key: "curr_user_pass");
      authStatus = AuthStatus.logout;
    }
    notifyListeners();
  }

  void resetConnectionMessege() {
    authStatus = AuthStatus.standby;
    failReason = '-';
    notifyListeners();
  }

  Future<String> getCurrUser() async {
    const flutterSecureStorageObject = FlutterSecureStorage();
    String activeEmail =
        await flutterSecureStorageObject.read(key: "curr_user_email") ?? "-";
    return activeEmail;
  }
}
