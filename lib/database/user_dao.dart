import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/user.dart';

class UserDao {
  static CollectionReference<User> getUserCollection() {
    var db = FirebaseFirestore.instance;
    var userCollection = db.collection(User.collectionName).withConverter(
        fromFirestore: (snapshot, option) =>
            User.fromFireStore(snapshot.data()),
        toFirestore: (user, option) => user.toFireStore());
    return userCollection;
  }

  static Future<void> addUser(User user) async {
    var userCollection = getUserCollection();
    var doc = userCollection.doc(user.id);
    return await doc.set(user);
  }

  static Future<User?> getUser(String? userID) async {
    var collection = getUserCollection();
    var userSnapshot = collection.doc(userID);
    var data = await userSnapshot.get();
    return data.data();
  }
}
