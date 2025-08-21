import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/properties/group.dart';
import 'package:samvaad/core/utils/user_records.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/domain/repositories/manage_user_repository.dart';
import 'package:samvaad/domain/entities/group.dart' as app_group;

class ManageUserRepositoryImpl extends ManageUserRepository {
  //call to fetch user who know current user data from database
  FetchUserDataFromFirebase fetchUserDataFromFirebase;

  ManageUserRepositoryImpl({required this.fetchUserDataFromFirebase});

  @override
  Future<List<User>> getUserWhoKnowCurrentUser(
      List<Contact> currentUserContacts) async {
    return await fetchUserDataFromFirebase.getUsers(currentUserContacts);
  }

  @override
  Stream<List<Participant>> getParticipants() {
    return fetchUserDataFromFirebase.fetchParticipants();
  }

  @override
  Future<void> addGroup(app_group.Group newGroup) async {
    await fetchUserDataFromFirebase.addGroup(newGroup);
  }

  @override
  Stream<List<Object>> getParticipantAndGroup() {
    return fetchUserDataFromFirebase.getGroupAndParticipant();
  }

  @override
  Future<User> getParticipantUser(String phoneNo) async {
    return await fetchUserDataFromFirebase.getSingleUser(phoneNo);
  }

  @override
  Stream<List<User>> getUserWhoKnowCurrentUserRealTime(
      List<Contact> currentUserContacts) {
    return fetchUserDataFromFirebase
        .getUsersWhoKnowCurrentUser(currentUserContacts);
  }

  @override
  Future<void> addGroupMember(
      List<app_group.GroupMember> member, String id) async {
    await fetchUserDataFromFirebase.addGroupMemeber(member, id);
  }

  @override
  Future<void> updateGroupName(String name, String chatId) async {
    await fetchUserDataFromFirebase.updateGroupName(name, chatId);
  }

  @override
  Future<void> updateGroupProfileImage(String profileUrl, String chatId) async {
    await fetchUserDataFromFirebase.updateGroupProfileUrl(profileUrl, chatId);
  }

  @override
  Future<void> makeNewAdmin(
      List<app_group.GroupMember> member, String id) async {
    await fetchUserDataFromFirebase.makeNewAdmin(member, id);
  }

  @override
  Future<void> removeMemberFromGroup(
      List<app_group.GroupMember> member, String id) async {
    await fetchUserDataFromFirebase.removeMemberFromGroup(member, id);
  }

  @override
  Future<void> forwardMessage(Message message, List<String> chatIds) async {}

  @override
  Future<void> searchUser(String id) async {}
}
