import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  final DatabaseReference databaseReference;

  DatabaseService({required String databaseUrl})
      : databaseReference = FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: databaseUrl,
        ).ref();

  Future<void> createRecord(String child, String name, String pass) async {
    await databaseReference.child(child).set({
      'name': name,
      'password': pass,
    });
  }

  Future<DataSnapshot> readData(String child) async {
    DatabaseEvent event = await databaseReference.child(child).once();
    DataSnapshot snapshot = event.snapshot;
    return snapshot;
  }

  Future<void> addValueToArray(String child, String value) async {
    DatabaseReference newChildRef = databaseReference.child(child).push();
    await newChildRef.set(value);
  }
}
