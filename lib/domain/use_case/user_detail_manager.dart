//use  case for fetching user details who know current user
// and adding new contact to user
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:samvaad/core/services/fetch_files.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/data/datasources/remote/upload_profile_data_to_firebase.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/domain/repositories/manage_user_repository.dart';
import 'package:samvaad/domain/entities/group.dart' as app_group;

class ManageUserUseCase {
  //reference to repostiory
  FetchUserDataFromFirebase fetchUserDataFromFirebase =
      FetchUserDataFromFirebase(firebaseFirestore: FirebaseFirestore.instance);
  ManageUserRepository manageNewUserRepository;
  HandelProfileDataToFirebase handelProfileDataToFirebase =
      HandelProfileDataToFirebase(
          firestore: FirebaseFirestore.instance,
          firebaseStorage: FirebaseStorage.instance);
  ManageUserUseCase({required this.manageNewUserRepository});

  //method to fetch list of user who know current user from database
  Future<List<User>> fetchUserWhoKnowCurrentUser(
      List<Contact> currentUserContacts) async {
    return await manageNewUserRepository
        .getUserWhoKnowCurrentUser(currentUserContacts);
  }

  Stream<List<Participant>> execFetchParticipants() {
    return manageNewUserRepository.getParticipants();
  }

  Future<User> callToGetUsers(String phoneNo) async {
    return await manageNewUserRepository.getParticipantUser(phoneNo);
  }

  Future<void> exeAddNewGroup(app_group.Group newGroup) async {
    await manageNewUserRepository.addGroup(newGroup);
  }

  Stream<List<Object>> fetchParticipantAndGroupe() {
    return manageNewUserRepository.getParticipantAndGroup();
  }

  Stream<List<User>> fetchUserWhoKnowCurrentUserRealTime(
      List<Contact> currentUserContacts) {
    return manageNewUserRepository
        .getUserWhoKnowCurrentUserRealTime(currentUserContacts);
  }

  Future<void> addMember(List<app_group.GroupMember> member, String id) async {
    await manageNewUserRepository.addGroupMember(member, id);
  }

  Future<void> updateGroupNameUseCase(String name, String id) async {
    await manageNewUserRepository.updateGroupName(name, id);
  }

  Future<void> updateGroupUpdateProfilePic(
      String profilePhotoUrl, String id) async {
    await manageNewUserRepository.updateGroupProfileImage(profilePhotoUrl, id);
  }

  Future<String> uploadUserProfileImage(
      File imageFile, String whereInStorage) async {
    return await handelProfileDataToFirebase.uploadUserProfileImage(
        imageFile, whereInStorage);
  }

  Future<void> addMemberToGroup(
      List<app_group.GroupMember> groupMember, String id) async {
    await fetchUserDataFromFirebase.addGroupMemeber(groupMember, id);
  }

  Future<void> removeGroupMember(
      List<app_group.GroupMember> groupMember, String id) async {
    await fetchUserDataFromFirebase.removeMemberFromGroup(groupMember, id);
  }

  Future<void> makeAdmin(
      List<app_group.GroupMember> groupMember, String id) async {
    await fetchUserDataFromFirebase.makeNewAdmin(groupMember, id);
  }

  Future<void> forwardMessage(
      Map<String, List<Message>> messages, List<String> ids) async {
    await fetchUserDataFromFirebase.forwardMessage(messages, ids);
  }

  Future<User?> searchUser(String query) async {
    return await fetchUserDataFromFirebase.deepSearch(query);
  }

  Future<void> deleteUser(String number) async {
    await fetchUserDataFromFirebase.deleteUser(number);
  }

  Future<void> muteUser(String number, bool newValue) async {
    await fetchUserDataFromFirebase.toggelMuteNoitifcation(number, newValue);
  }

  Future<bool> checkMuteNotification(String number) async {
    return await fetchUserDataFromFirebase.checkIfUserIsMute(number);
  }
}
