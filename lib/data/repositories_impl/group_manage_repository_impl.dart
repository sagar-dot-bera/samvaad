import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_contacts/properties/group.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/domain/repositories/group_manager_repository.dart';

class GroupManagerRepositoryImpl extends GroupManagerRepository {
  FetchUserDataFromFirebase fetchUserDataFromFirebase =
      FetchUserDataFromFirebase(firebaseFirestore: FirebaseFirestore.instance);

  @override
  Future<void> createGroup(Group newGroup) async {
    //await fetchUserDataFromFirebase.addGroup(newGroup);
  }
}
