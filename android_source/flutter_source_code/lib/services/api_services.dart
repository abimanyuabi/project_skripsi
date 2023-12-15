import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_source_code/utility/enums.dart';

Future<AuthStatus> registerEmailPassword(
    {required String email,
    required String password,
    required FirebaseAuth firebaseAuthObject}) async {
  try {
    await firebaseAuthObject.createUserWithEmailAndPassword(
        email: email.trim(), password: password.trim());
    return AuthStatus.success;
  } catch (e) {
    return AuthStatus.failed;
  }
}

Future<AuthStatus> signOut({required FirebaseAuth firebaseAuthObject}) async {
  try {
    await firebaseAuthObject.signOut();
    return AuthStatus.success;
  } catch (e) {
    return AuthStatus.failed;
  }
}
