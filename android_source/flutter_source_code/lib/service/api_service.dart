import 'package:firebase_database/firebase_database.dart';

Future<DataSnapshot> fetchSensorData(
    {required DatabaseReference firebaseRTDB, required String path}) async {
  return await firebaseRTDB.child(path).once().then((snapshot) {
    return snapshot.snapshot;
  });
}
