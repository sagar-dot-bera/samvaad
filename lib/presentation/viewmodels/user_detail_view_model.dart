import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:nanoid/nanoid.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/file_handler.dart';
import 'package:samvaad/core/utils/user_details_helper.dart';
import 'package:samvaad/core/utils/user_setting.dart';
import 'package:samvaad/data/datasources/remote/fetch_user_data_from_firebase.dart';
import 'package:samvaad/data/repositories_impl/manage_user_repository_impl.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/user.dart';
import 'package:samvaad/domain/entities/group.dart' as app_group;
import 'package:samvaad/domain/use_case/user_detail_manager.dart';
import 'package:samvaad/domain/use_case/message_manager_user_case.dart';

class UserDetailsViewModel extends ChangeNotifier {
  final String logtag = "ManageNewUserViewModel"; // used for loggind
  ManageUserUseCase manageNewUserUseCase = MessageManagerUserCase(
      manageNewUserRepository: ManageUserRepositoryImpl(
          fetchUserDataFromFirebase: FetchUserDataFromFirebase(
              firebaseFirestore: FirebaseFirestore.instance)));
  List<User> userWhoKnowCurrentUser =
      []; //list of user who know current user from current users contect list
  List<Contact> currentUserContacts =
      CurrentUser.instance.currentUserContacts ??
          []; //a list of contacts of current user
  List<Participant> _participantOfCurrentUser =
      []; //list of participant of user of current users
  List<User> detailsOfParticipants = []; //details of participant's
  FileHandler fileHandler = FileHandler();
  List<app_group.Group> _groupesOfCurrentUser = [];
  List<Object> participantAndGroups = [];
  List<app_group.Group> get groupesOfCurrentUser => _groupesOfCurrentUser;
  List<Participant> get participantOfCurrentUser => _participantOfCurrentUser;
  UserDetailsViewModel._private();
  bool isParticipantAndGroupDataLoading = true;
  bool isUserDetailLoading = false;

  List<User> _filteredUser = [];
  List<app_group.Group> _filteredGroup = [];

  List<User> get filteredUser => _filteredUser;
  List<app_group.Group> get filteredGroup => _filteredGroup;
  List<Object> _commonFilterList = [];
  List<Object> get commonFliterList => _commonFilterList;
  app_group.Group? _groupInfoInView;
  User? userInfoInView;

  List<String> selectedGroupMember = List.empty(growable: true);

  app_group.Group? get groupInfoInView => _groupInfoInView ?? null;
  set setGroupInfo(app_group.Group group) {
    _groupInfoInView = group;
  }

  void addFilteredUser(List<User> users) {
    if (users.isNotEmpty) {
      log("added new data to filter user list ${users.length}");
      _filteredUser = users;
      _commonFilterList = [..._filteredGroup, ..._filteredUser];
      notifyListeners();
    }
  }

  void addFilteredGroup(List<app_group.Group> groups) {
    if (groups.isNotEmpty) {
      log("added new data to filter group list ${groups.length}");
      _filteredGroup = groups;
      _commonFilterList = [..._filteredGroup, ..._filteredUser];
      notifyListeners();
    }
  }

  void clearFilterList() {
    _filteredUser.clear();
    _filteredGroup.clear();
    _commonFilterList.clear();
    notifyListeners();
  }

  set participantAndGroupSetter(List<Object> data) {
    if (data.isNotEmpty) {
      log("new data add to participant and group list");
      participantAndGroups = data;
      isParticipantAndGroupDataLoading = false;
      participantAndGropSeparator(participantAndGroups);
      notifyListeners();
    }
  }

  set userWhoKnowCurrentUserSetter(List<User> users) {
    if (users.isNotEmpty) {
      log("user data added to viewmodel");
      userWhoKnowCurrentUser = users;
      isUserDetailLoading = false;

      notifyListeners();
    }
  }

  void setContacts(List<Contact> contacts) {
    currentUserContacts = contacts;
    notifyListeners();
  }

  static final instance = UserDetailsViewModel._private();

  factory UserDetailsViewModel() {
    return instance;
  }

  Future<void> setUserWhoknowCurrentUser(
      List<Contact> currentUserContacts) async {
    try {
      List<User> tempListOfUser = await manageNewUserUseCase
          .fetchUserWhoKnowCurrentUser(currentUserContacts);

      if (tempListOfUser.isNotEmpty) {
        userWhoKnowCurrentUser = tempListOfUser;
        notifyListeners();
      } else {
        userWhoKnowCurrentUser = [];
        notifyListeners();
      }
    } on Exception catch (ex) {
      log(ex.toString());
    }
  }

  void setParticipantDetails(List<Participant> participantDetails) {
    if (participantDetails.isNotEmpty) {
      participantOfCurrentUser.addAll(participantDetails);
    }
  }

  List<app_group.GroupMember> createGroupMemebers(List<User> members) {
    return members.map((e) {
      if (e.phoneNo == CurrentUser.instance.currentUser!.phoneNo) {
        return app_group.GroupMember(memberId: e.phoneNo, isAdmin: true);
      } else {
        return app_group.GroupMember(memberId: e.phoneNo, isAdmin: false);
      }
    }).toList();
  }

  Future<void> getParticipantUserDetails() async {
    for (var element in participantAndGroups) {
      if (element is Participant) {
        if (userWhoKnowCurrentUser
                .indexWhere((e) => e.phoneNo == element.withUser) ==
            -1) {
          User tempUser =
              await manageNewUserUseCase.callToGetUsers(element.withUser!);
          log("user detail fetched with user id ${tempUser.phoneNo}");
          detailsOfParticipants.add(tempUser);
          log("added to details of participant list ${detailsOfParticipants.length}");
        } else {
          detailsOfParticipants.add(userWhoKnowCurrentUser[
              userWhoKnowCurrentUser
                  .indexWhere((e) => e.phoneNo == element.withUser)]);
        }
      }
    }
  }

  void setParticipantAndGroup(List<Object> data) {
    participantAndGroups.clear();
    participantAndGroups.addAll(data);
  }

  User getUserDetails(String phone) {
    log("list of user ${userWhoKnowCurrentUser.length}");
    userWhoKnowCurrentUser.forEach((e) {
      log("user ${e.toJson()}");
    });
    log(" $phone");
    return userWhoKnowCurrentUser.firstWhere((e) => e.phoneNo == phone,
        orElse: () =>
            User(phoneNo: phone, userName: "$phone", profilePhotoUrl: ""));
  }

  void participantAndGropSeparator(List<Object> participantsAndGroups) async {
    for (var element in participantsAndGroups) {
      if (element is app_group.Group) {
        _groupesOfCurrentUser.add(element);
      }

      if (element is Participant) {
        _participantOfCurrentUser.add(element);
      }
    }
  }

  Future<void> setNewGroupDetails(
    String name,
    String profileDownloadUrl,
    List<User> selectedMembers,
  ) async {
    List<app_group.GroupMember> members = createGroupMemebers(selectedMembers);
    log("member list ${members.length}");
    String chatId = nanoid();
    app_group.Group newGroup = app_group.Group(
        name: name,
        member: members,
        chatId: chatId,
        profilePhotoUrl: profileDownloadUrl);
    await manageNewUserUseCase.exeAddNewGroup(newGroup);
  }

  Future<String> uploadImage(File profilePic) async {
    String downloadUrl = await fileHandler.uploadFileToRemote(
        profilePic, "userGeneratedContent");

    return downloadUrl;
  }

  Stream<List<Object>> getParticipantAndGroup() {
    return manageNewUserUseCase.fetchParticipantAndGroupe();
  }

  Object? getUserOrGroupDetail(String chatId) {
    for (var element in participantAndGroups) {
      if (element is Participant) {
        if (element.chatId == chatId) {
          return userWhoKnowCurrentUser
              .where((e) => e.phoneNo == element.withUser);
        } else {}
      } else if (element is Group) {
        if (element.id == chatId) {
          return element;
        }
      }
    }
  }

  Stream<List<User>> setUserWhoKnowCurrentUserRealTime() {
    log("getting user detail");
    return manageNewUserUseCase.fetchUserWhoKnowCurrentUserRealTime(
        CurrentUser.instance.currentUserContacts ?? []);
  }

  void filterData(String query, bool filterBoth) {
    if (filterBoth) {
      addFilteredGroup(groupQuerySearch(query));
      addFilteredUser(userQuerySearch(query));
    } else {
      addFilteredUser(userQuerySearch(query));
    }
  }

  List<app_group.Group> groupQuerySearch(String query) {
    return groupesOfCurrentUser.where((group) {
      if (group.name.contains(query)) {
        log("searched group found");
        return true;
      } else {
        return false;
      }
    }).toList();
  }

  List<User> userQuerySearch(String query) {
    return userWhoKnowCurrentUser.where((user) {
      if (participantOfCurrentUser
              .indexWhere((e) => e.withUser == user.phoneNo) !=
          -1) {
        if (user.phoneNo!.contains(query)) {
          log("searched user found");
          return true;
        } else if (user.userName!.contains(query)) {
          log("searched user found");
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }).toList();
  }

  List<User> getMemberToAdd(List<app_group.GroupMember> currentMember) {
    List<User> availableUser = List.empty(growable: true);
    for (var element in userWhoKnowCurrentUser) {
      if (currentMember.indexWhere((e) => e.memberId == element.phoneNo) ==
          -1) {
        availableUser.add(element);
      }
    }
    return availableUser;
  }

  Future<void> addMember(List<app_group.GroupMember> member, String id) async {
    groupInfoInView!.member.addAll(member);
    await manageNewUserUseCase.addMember(member, id);
    notifyListeners();
  }

  Future<void> updateGroupName(String name, String chatId) async {
    await manageNewUserUseCase.updateGroupNameUseCase(name, chatId);
    groupInfoInView!.name = name;
    notifyListeners();
  }

  Future<void> updateGroupProfilePicture(File file, String chatId) async {
    final url = await manageNewUserUseCase.uploadUserProfileImage(
        file, "userGeneratedMedia");
    await manageNewUserUseCase.updateGroupUpdateProfilePic(url, chatId);
    log("old url ${groupInfoInView!.profilePhotoUrl} new url ${url}");
    groupInfoInView!.profilePhotoUrl = url;
    notifyListeners();
  }

  void modifySelectedGroup(String id) {
    if (selectedGroupMember.contains(id)) {
      selectedGroupMember.remove(id);
      notifyListeners();
    } else {
      selectedGroupMember.add(id);
      notifyListeners();
    }
  }

  void makeNewAdmin(List<app_group.GroupMember> member, String id) async {
    await manageNewUserUseCase.makeAdmin(member, id);
    for (var element in member) {
      groupInfoInView!.member
          .removeWhere((e) => e.memberId == element.memberId);
      element.isAdmin = true;
      groupInfoInView!.member.add(element);
    }
    notifyListeners();
  }

  void removeMember(List<app_group.GroupMember> member, String id) async {
    await manageNewUserUseCase.removeGroupMember(member, id);
    for (var element in member) {
      groupInfoInView!.member
          .removeWhere((e) => e.memberId == element.memberId);
    }
    notifyListeners();
  }

  Future<void> forwardMessage(List<Message> message, List<String> ids,
      Map<String, List<String>> receivers) async {
    final messageToForward = makeMessageToForward(message, receivers);
    await manageNewUserUseCase.forwardMessage(messageToForward, ids);
  }

  Map<String, List<Message>> makeMessageToForward(
      List<Message> message, Map<String, List<String>> receiverList) {
    Map<String, List<Message>> withUpdatedMsg = {};

    for (var receiverKey in receiverList.keys) {
      List<Message> msgForCurrentReceiver = List.empty(growable: true);
      for (var msg in message) {
        String messageId = nanoid();
        msg.sender = CurrentUser.instance.currentUser!.phoneNo;
        msg.senderName = CurrentUser.instance.currentUser!.userName;
        msg.receiver = receiverList[receiverKey];
        msg.messageId = messageId;
        msg.timeStamp = DateTime.now().toIso8601String();
        log("message prepared for receiver $receiverKey ${msg.receiver}  ${msg.sender}");

        msgForCurrentReceiver.add(msg);
      }
      withUpdatedMsg[receiverKey] = msgForCurrentReceiver;
      log("message prepared for receiver $receiverKey ${msgForCurrentReceiver.length} ");
    }

    return withUpdatedMsg;
  }

  Future<User?> searchUser(String query) async {
    return await manageNewUserUseCase.searchUser(query);
  }

  Future<void> deleteUser(String number) async {
    return await manageNewUserUseCase.deleteUser(number);
  }

  Future<void> muteNotificationToggle(String number, bool newValue) async {
    await manageNewUserUseCase.muteUser(number, newValue);
  }

  Future<bool> checkIfUserIsMute(String number) async {
    return await manageNewUserUseCase.checkMuteNotification(number);
  }

  Future<void> contectSync() async {
    List<Contact> reFetchedContact =
        await UserDetailsHelper.intance.getContact();
    for (var element in reFetchedContact) {
      if (element.phones.isNotEmpty) {
        if (userWhoKnowCurrentUser.indexWhere(
                (e) => e.phoneNo == element.phones.first.normalizedNumber) ==
            -1) {
          if (element.phones.first.normalizedNumber.length == 13) {
            User? newUser = await manageNewUserUseCase
                .searchUser(element.phones.first.normalizedNumber);

            if (newUser != null) {
              userWhoKnowCurrentUser.add(newUser);
              if (CurrentUser.instance.currentUserContacts != null) {
                CurrentUser.instance.currentUserContacts!.add(element);
              }
              notifyListeners();
            }
          }
        }
      }
    }
  }
}
