import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseService {
  static const String databaseUrl =
      'https://prod-firebase-rtdb.firebaseio.com/';

  // Create a DatabaseReference using the non-default database URL
  final DatabaseReference _databaseReference = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: databaseUrl,
  ).ref();

  Future<List<String>> fetchItems(String listName) async {
    try {
      final DataSnapshot snapshot =
          await _databaseReference.child(listName).child('emails').get();

      if (snapshot.exists) {
        List<dynamic> itemsList = snapshot.value as List<dynamic>;
        // Filter out null values and cast to List<String>
        List<String> items =
            itemsList.where((item) => item != null).cast<String>().toList();
        return items;
      } else {
        return [];
      }
    } catch (error) {
      print('Error fetching data from $listName: $error');
      throw Exception('Error fetching data from $listName: $error');
    }
  }

  Future<void> addItemToList(String listName, String item) async {
    try {
      final DatabaseReference listRef = _databaseReference.child(listName);
      final DataSnapshot indexSnapshot = await listRef.child('index').get();

      if (indexSnapshot.exists) {
        int currentIndex = indexSnapshot.value as int;
        await listRef.child('emails/$currentIndex').set(item);
        await listRef.child('index').set(currentIndex + 1);
      } else {
        throw Exception('Index does not exist');
      }
    } catch (error) {
      print('Error adding item to list $listName: $error');
      throw Exception('Error adding item to list $listName: $error');
    }
  }

  Future<void> deleteItemFromList(String listName, String item) async {
    try {
      final DatabaseReference listRef =
          _databaseReference.child(listName).child('emails');
      final DataSnapshot snapshot = await listRef.get();

      if (snapshot.exists) {
        Map<dynamic, dynamic> itemsMap =
            snapshot.value as Map<dynamic, dynamic>;
        String? keyToDelete;
        itemsMap.forEach((key, value) {
          if (value == item) {
            keyToDelete = key;
          }
        });

        if (keyToDelete != null) {
          await listRef.child(keyToDelete!).remove();
        } else {
          throw Exception('Item not found');
        }
      } else {
        throw Exception('Items list does not exist');
      }
    } catch (error) {
      print('Error deleting item from list $listName: $error');
      throw Exception('Error deleting item from list $listName: $error');
    }
  }
}
