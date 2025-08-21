import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/domain/entities/group.dart';
import 'package:samvaad/domain/repositories/manage_user_repository.dart';
import 'package:samvaad/domain/use_case/user_detail_manager.dart';

class MessageManagerUserCase extends ManageUserUseCase {
  ManageUserRepository manageNewUserRepository;
  FetchUserDataFromFirebase fetchUserDataFromFirebase =
      FetchUserDataFromFirebase(firebaseFirestore: FirebaseFirestore.instance);

  MessageManagerUserCase({required this.manageNewUserRepository})
      : super(manageNewUserRepository: manageNewUserRepository);

  Future<void> blockUserUseCase(String id) async {
    await fetchUserDataFromFirebase.addToBlock(id);
  }

  Future<void> removeFromBlockUseCase(String id) async {
    await fetchUserDataFromFirebase.removeFromBlock(id);
  }

  Future<void> deleteChatUseCase(String id, String type) async {
    await fetchUserDataFromFirebase.deleteChat(id, type);
  }

  Future<void> exitGroupUseCase(String id) async {
    await fetchUserDataFromFirebase.exitGroup(id);
  }
}
