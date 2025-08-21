import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/domain/entities/group.dart' as app_group;

abstract class ManageUserRepository {
  Future<List<User>> getUserWhoKnowCurrentUser(
      List<Contact> currentUserContacts);

  Stream<List<Participant>> getParticipants();
  Future<User> getParticipantUser(String phoneNo);
  Future<void> addGroup(app_group.Group newGroup);

  Stream<List<Object>> getParticipantAndGroup();
  Stream<List<User>> getUserWhoKnowCurrentUserRealTime(
      List<Contact> currentUserContacts);

  Future<void> addGroupMember(List<app_group.GroupMember> member, String id);
  Future<void> updateGroupName(String name, String chatId);
  Future<void> updateGroupProfileImage(String profileUrl, String chatId);
  Future<void> makeNewAdmin(List<app_group.GroupMember> member, String id);
  Future<void> removeMemberFromGroup(
      List<app_group.GroupMember> member, String id);

  Future<void> searchUser(String id);
}
