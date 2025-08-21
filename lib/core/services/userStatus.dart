import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';

class UserStatusService {
  FetchUserDataFromFirebase fetchUserDataFromFirebase =
      FetchUserDataFromFirebase(firebaseFirestore: FirebaseFirestore.instance);
  Future<void> exeSetOnline() async {
    await fetchUserDataFromFirebase.setOnline();
  }

  Future<void> exeSetOffline() async {
    await fetchUserDataFromFirebase.setOffline();
  }
}
