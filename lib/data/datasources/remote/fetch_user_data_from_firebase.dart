import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:rxdart/rxdart.dart';
import 'package:samvaad/core/utils/current_user_setting.dart';
import 'package:samvaad/core/utils/current_user_singleton.dart';
import 'package:samvaad/core/utils/user_records.dart';
import 'package:samvaad/domain/entities/message.dart';
import 'package:samvaad/domain/entities/participant.dart';
import 'package:samvaad/domain/entities/user.dart' as my_app;
import 'package:samvaad/domain/entities/group.dart' as app_group;

class FetchUserDataFromFirebase {
  //intance of firestore
  FirebaseFirestore firebaseFirestore;
  final currentUser = FirebaseAuth.instance.currentUser;
  FetchUserDataFromFirebase({required this.firebaseFirestore});

  //method to get a list of user from firebase firestore
  Future<List<my_app.User>> getUsers(List<Contact> userContactList) async {
    final usersRef = firebaseFirestore.collection("users");
    List<my_app.User> userPhoneNumberList = List.empty(growable: true);

    log("fetching user who knows current user");

    for (var e in userContactList) {
      String phoneNumber =
          e.phones.isNotEmpty ? e.phones.first.normalizedNumber : '';
      log("current number $phoneNumber");
      if (phoneNumber.isNotEmpty) {
        final data =
            await usersRef.where("phoneNo", isEqualTo: phoneNumber).get();
        for (var userData in data.docs) {
          log("user found");
          userPhoneNumberList.add(my_app.User.fromJson(userData.data()));
        }
      } else {
        log("number is empty");
      }
    }
    log("operation done");
    return userPhoneNumberList;
  }

  //method to add new participant to participant list of current user
  Future<void> addParticipant(Participant newParticipant) async {
    try {
      log("New participant name ${newParticipant.chatId}");

      log("current user phone number ${currentUser!.phoneNumber}");

      //getting firebase referece to current user's doc on firestore
      final currentUserRef =
          firebaseFirestore.collection('users').doc(currentUser!.phoneNumber);
      //referece to new participant user
      final participantUserRef =
          firebaseFirestore.collection('users').doc(newParticipant.withUser);
      //adding participant to current user list
      await currentUserRef
          .collection("participant")
          .doc(newParticipant.chatId)
          .set(newParticipant.toJson());
      //adding
      //particiant object for user 2
      Participant participantOfUserTwo = Participant(
          withUser: currentUser!.phoneNumber,
          chatId: newParticipant.chatId,
          lastMessage: newParticipant.lastMessage,
          isLastMessageRead: newParticipant.isLastMessageRead,
          lastMessageType: newParticipant.lastMessageType,
          lastMessageTimeStamp: newParticipant.lastMessageType,
          newMessageCount: newParticipant.newMessageCount);
      await participantUserRef
          .collection("participant")
          .doc(participantOfUserTwo.chatId)
          .set(participantOfUserTwo.toJson());
      log("participant added succesfullay... ");
    } on Exception catch (ex) {
      log("Error ${ex.toString()}");
    }
  }

  Future<Participant?> checkIfParticipantExit(String withUser) async {
    final currentUserRef =
        firebaseFirestore.collection('users').doc(currentUser!.phoneNumber);
    Participant? participant;
    //referece to new participant user
    final participantUserRef =
        firebaseFirestore.collection('users').doc(withUser);

    final currentUserParticipant = await currentUserRef
        .collection("participant")
        .where("withUser", isEqualTo: withUser)
        .get();

    final otherUserParticipant = await participantUserRef
        .collection("participant")
        .where("withUser",
            isEqualTo: FirebaseAuth.instance.currentUser!.phoneNumber)
        .get();

    if (currentUserParticipant.docs.isNotEmpty) {
      for (var element in currentUserParticipant.docs) {
        participant = Participant.fromJson(element.data());
        log("participant found");
      }
    }

    if (otherUserParticipant.docs.isNotEmpty && participant == null) {
      for (var element in currentUserParticipant.docs) {
        participant = Participant.fromJson(element.data());
        participant.withUser = withUser;

        log("participant found");
      }
    }

    if (participant != null) {
      currentUserRef
          .collection("participant")
          .doc(participant!.chatId)
          .set(participant.toJson());
    }

    return participant;
  }

  //function to update user online status and last seen  on used for current user
  Future<void> setOnline() async {
    try {
      log("updating user status to online");
      final currentUserRef =
          firebaseFirestore.collection('users').doc(currentUser!.phoneNumber);

      my_app.UserStatus userStatus = my_app.UserStatus(
          isOnline: true,
          lastSeenTimeStamp: DateTime.now().toString(),
          isTyping: false);
      log("new user status ${userStatus.isOnline}");
      await currentUserRef.update({'userStatus': userStatus.toJson()});
    } on Exception catch (ex) {
      log("Error ${ex.toString()}");
    }
  }

  //method to set user offline
  Future<void> setOffline() async {
    try {
      log("updating user status to offline");
      final currentUserRef =
          firebaseFirestore.collection('users').doc(currentUser!.phoneNumber);

      await currentUserRef.update({
        'userStatus': my_app.UserStatus(
                isOnline: false,
                lastSeenTimeStamp: DateTime.now().toString(),
                isTyping: false)
            .toJson()
      });
    } on Exception catch (ex) {
      log("Error ${ex.toString()}");
    }
  }

  Future<void> setTyping() async {
    try {
      log("updating user status to typing");
      final currentUserRef =
          firebaseFirestore.collection('users').doc(currentUser!.phoneNumber);

      await currentUserRef.update({
        'userStatus': my_app.UserStatus(
                isOnline: true,
                lastSeenTimeStamp: DateTime.now().toString(),
                isTyping: true)
            .toJson()
      });
    } on Exception catch (ex) {
      log("Error ${ex.toString()}");
    }
  }

  //method to listening current user
  Stream<Message> fetchMessage(String chatId) async* {
    try {
      var currentChatReference = firebaseFirestore
          .collection('chats_central')
          .doc(chatId)
          .collection("chat")
          .orderBy('timeStamp');
      final messageStreamController = StreamController<Message>();

      if (UserRecord.instance.deletedRecords.containsKey(chatId)) {
        currentChatReference = currentChatReference.where('timeStamp',
            isGreaterThan: UserRecord.instance.deletedRecords[chatId]);
      }

      currentChatReference.snapshots().listen((event) {
        try {
          for (var message in event.docChanges) {
            final messageToAdd = Message.fromJson(message.doc.data()!);
            if (message.type == DocumentChangeType.added) {
              if (messageToAdd.messageNotVisible != null &&
                  !messageToAdd.messageNotVisible!.contains(
                      FirebaseAuth.instance.currentUser!.phoneNumber!)) {
                messageStreamController.add(messageToAdd);
              }
              log("adding document ${message.doc.data()}");
            } else if (message.type == DocumentChangeType.modified) {
              if (messageToAdd.messageNotVisible != null &&
                  !messageToAdd.messageNotVisible!.contains(
                      FirebaseAuth.instance.currentUser!.phoneNumber!)) {
                messageStreamController.add(messageToAdd);
              }
              log("message updated");
            } else if (message.type == DocumentChangeType.removed) {
              log("Message deleted ${message.doc.id}");
              Message deletedMessage = Message(
                  sender: "",
                  receiver: [],
                  messageId: message.doc.id,
                  timeStamp: "",
                  contentType: "",
                  content: "",
                  readBy: {},
                  messageStatus: "deleted",
                  messageNotVisible: [],
                  extraInfo: null);
              messageStreamController.add(deletedMessage);
            }
          }
        } catch (e) {
          log("error in fetching data");
        }
      });

      yield* messageStreamController.stream;
    } catch (e) {
      log("error in fetching message $e");
    }
  }

  //method to send message to user
  Future<void> sendMessage(Message message, String chatId) async {
    log("sending message...");
    log("message **${message.content} chaetId **$chatId currenlty looking good so code *-*-YELLOW-*-*");
    //reference to currently ongoing chat
    final currentChatReference = firebaseFirestore
        .collection('chats_central')
        .doc(chatId)
        .collection("chat");

    await currentChatReference.doc(message.messageId).set(message.toJson());
    log("message was sent successfullay... i think");
  }

  //fetching details of a particular participant from firebase
  Future<Participant?> fetchSingleParticipent(String phoneNo) async {
    log("fetching new participant...");
    //refernce to current user's participant list
    final currentUserParticipantRef = firebaseFirestore
        .collection("users")
        .doc(currentUser!.phoneNumber)
        .collection("participant");
    log("current user number ${currentUser!.phoneNumber}");

    //fetched participant details
    final result = await currentUserParticipantRef
        .where("withUser", isEqualTo: phoneNo.trim())
        .get();

    if (result.docs.isNotEmpty) {
      Participant? participant;
      for (var element in result.docs) {
        participant = Participant.fromJson(element.data());
      }

      if (participant != null) {
        return participant;
      }
    }
    return null;
  }

  Stream<List<Participant>> fetchParticipants() {
    try {
      //refenrece to participant
      final currentUserParticipantRef = firebaseFirestore
          .collection("users")
          .doc(currentUser!.phoneNumber)
          .collection("participant");

      //a list to store participant details fetched from firestore
      List<Participant> participants = List.empty(growable: true);

      StreamController<List<Participant>> participantStream =
          StreamController();
      currentUserParticipantRef.snapshots().listen((event) {
        log("message doc size *_*_${event.size}_*_*");

        for (var docChange in event.docChanges) {
          if (docChange.type == DocumentChangeType.added) {
            // log("doc added ${docChange.doc.id}");
            participants.add(Participant.fromJson(docChange.doc.data()!));
          } else if (docChange.type == DocumentChangeType.modified) {
            Participant updatedParticipant =
                Participant.fromJson(docChange.doc.data()!);
            // log("doc upadeted  ${docChange.doc.id}");
            participants[participants.indexWhere(
                    (element) => element.chatId == updatedParticipant.chatId)] =
                updatedParticipant;
          } else if (docChange.type == DocumentChangeType.removed) {
            String docId = docChange.doc.id;

            //log("doc removed $docId");
            participants.removeWhere((element) => element.chatId == docId);
          }
        }
        log("data participant list size ${participants.length}");
        participantStream.add(List<Participant>.from(participants));
      });
      return participantStream.stream;
    } on Exception catch (ex) {
      log("Error $ex");
      log("Always go too far, because that's where you'll find the truth - Ablert camus");
      return const Stream.empty();
    }
  }

  Future<List<my_app.User>> fetchParticipantUsers(
      List<Participant> participants) async {
    try {
      final userRef = firebaseFirestore.collection("users");

      List<my_app.User> users = List.empty(growable: true);

      for (var participant in participants) {
        my_app.User user = await getSingleUser(participant.withUser!);
        users.add(user);
      }

      return users;
    } on Exception catch (ex) {
      log("Error $ex");
      log("What is a rebel? A man who says no. - Albert camus");
      return [];
    }
  }

  Future<void> batchReadUpdate(
      List<Message> messageList, String chatId, String userId) async {
    Map<String, dynamic> updates = {};

    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var message in messageList) {
      final messageRef = firebaseFirestore
          .collection("chats_central")
          .doc(chatId)
          .collection("chat")
          .doc(message.messageId);
      log("doc added to update list ${messageRef.toString()}");
      //await messageRef.update({'readBy.$userId': true});
      log("userid $userId");
      batch.update(messageRef, {'readBy.$userId': true});
    }

    try {
      await batch.commit();
      log(" from batchReadUpdate read update successful (^_^)");
    } on Exception catch (ex) {
      log("From batchReadUpadate unable to update read status");
      log("Error $ex");
    }
  }

  //method to fetch single user from firebase
  Future<my_app.User> getSingleUser(String phoneNo) async {
    //reference to user doc
    final userReference = firebaseFirestore.collection('users').doc(phoneNo);

    final fetchedResult = await userReference.get(); //fetching user document

    my_app.User fetchedUser =
        my_app.User.fromJson(fetchedResult.data()!); //parsing result

    return fetchedUser; //user returned
  }

  //listener on user on check status i.e online ,offline
  Future<void> checkStatus(
      String userPhoneNo, void Function(my_app.User userDetails) result) async {
    try {
      final userRef = firebaseFirestore.collection("users").doc(userPhoneNo);

      userRef.snapshots().listen((event) {
        if (event.exists) {
          my_app.User userData = my_app.User.fromJson(event.data()!);
          result(
              userData); //callbacke will be called on receiveing new information
        }
      });
    } on Exception catch (e) {
      log("Error (*_*)");
      log("Fiction is the lie through which we tell the truth. ― Albert Camus");
    }
  }

  Future<void> addGroup(app_group.Group group) async {
    try {
      log("Creating group");
      final databaseRef = firebaseFirestore.collection("group");

      await databaseRef.doc(group.chatId).set(group.toJson());
      log("gruop creation complete");
    } on Exception catch (e) {
      log("error in group creation $e");
    }
  }

  Stream<List<app_group.Group>> fetchGroup() {
    try {
      log("${currentUser!.phoneNumber}");
      final groupRef = firebaseFirestore
          .collection("group")
          .where("activeMember", arrayContains: currentUser!.phoneNumber!);
      List<app_group.Group> groups = List.empty(growable: true);
      StreamController<List<app_group.Group>> groupStream =
          StreamController<List<app_group.Group>>();

      groupRef.snapshots().listen((groupData) {
        for (var element in groupData.docChanges) {
          if (element.type == DocumentChangeType.added) {
            app_group.Group group =
                app_group.Group.fromJson(element.doc.data()!);

            groups.add(group);
          } else if (element.type == DocumentChangeType.modified) {
            log("groupe  modified in list");
            app_group.Group group =
                app_group.Group.fromJson(element.doc.data()!);
            log("group  with id ${group.chatId} and name ${group.name} modified in list");
            if (groups.indexWhere((e) => e.chatId == group.chatId) != -1) {
              groups[groups.indexWhere((e) => e.chatId == group.chatId)] =
                  group;
            }
          } else if (element.type == DocumentChangeType.removed) {
            app_group.Group group =
                app_group.Group.fromJson(element.doc.data()!);
            log("group  with id ${group.chatId} and name ${group.name} removed in list");
            groups.removeWhere((e) => e.chatId == group.chatId);
          }
        }
        groupStream.add(List<app_group.Group>.from(groups));
      });

      return groupStream.stream;
    } on Exception catch (e) {
      log("error in fetching group details $e");
      return Stream.empty();
    }
  }

  Stream<List<Object>> getGroupAndParticipant() {
    log("get groupe and participant called");
    return Rx.combineLatest2<List<Participant>, List<app_group.Group>,
            List<Object>>(fetchParticipants(), fetchGroup(),
        (participants, groups) {
      return [...participants, ...groups];
    });
  }

  Future<void> saveUserFcmToken() async {
    log("saving fcm tokken");
    final currentUserRef = firebaseFirestore
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser?.phoneNumber);
    String? fcmTokkenOfCurrentUser =
        await FirebaseMessaging.instance.getToken();
    log("fcm tokken of current user $fcmTokkenOfCurrentUser");
    if (fcmTokkenOfCurrentUser != null) {
      await currentUserRef
          .set({'fcmToken': fcmTokkenOfCurrentUser}, SetOptions(merge: true));
      log("user fcm tokken saved");
    }
  }

  Stream<List<my_app.User>> getUsersWhoKnowCurrentUser(
      List<Contact> userContact) {
    try {
      StreamController<List<my_app.User>> fetchedUser = StreamController();
      List<my_app.User> tempUserStorage = List.empty(growable: true);

      final userCollectionRef = firebaseFirestore.collection("users");

      userCollectionRef.snapshots().listen((data) {
        log("adding user detail");
        for (var element in data.docChanges) {
          if (element.type == DocumentChangeType.added) {
            my_app.User newUser = my_app.User.fromJson(element.doc.data()!);
            if (userContact.indexWhere((e) {
                  if (e.phones.isNotEmpty) {
                    return e.phones.first.normalizedNumber == newUser.phoneNo;
                  } else {
                    return false;
                  }
                }) !=
                -1) {
              tempUserStorage.add(newUser);
            }
          } else if (element.type == DocumentChangeType.removed) {
          } else if (element.type == DocumentChangeType.modified) {
            log("user details modifyed");

            my_app.User modifiedUserDetaile =
                my_app.User.fromJson(element.doc.data()!);
            int index = tempUserStorage
                .indexWhere((e) => e.phoneNo == modifiedUserDetaile.phoneNo);
            log("index of modifyed user $index");
            if (index != -1) {
              log("added detail to user list");
              tempUserStorage[index] = modifiedUserDetaile;
            }
          }

          fetchedUser.add(List<my_app.User>.from(tempUserStorage));
          log("fetch user list modifyed");
        }
      });
      log("fetch user list modifyed");
      return fetchedUser.stream;
    } on Exception catch (e) {
      log("Error in fetching user detail using user detaile stream $e");
      return Stream.empty();
    }
  }

  Stream<my_app.User> singleUserChangeListener(String userId) {
    final userDocRef = firebaseFirestore.collection("users").doc(userId);

    return userDocRef.snapshots().map((value) {
      if (value.exists) {
        return my_app.User.fromJson(value.data()!);
      } else {
        throw Exception("User not found");
      }
    });
  }

  Future<void> deleteMessage(
      bool isSoftDelete, List<String> messageId, String chatId) async {
    final messageRef = firebaseFirestore
        .collection("chats_central")
        .doc(chatId)
        .collection("chat");

    if (isSoftDelete) {
      for (var element in messageId) {
        messageRef.doc(element).update({
          "messageNotVisible": FieldValue.arrayUnion(
              [FirebaseAuth.instance.currentUser!.phoneNumber])
        });
      }
    } else {
      for (var element in messageId) {
        messageRef.doc(element).delete();
      }
    }
  }

  Future<void> deleteChat(String id, String type) async {
    log("removeing member");
    if (type == "participant") {
      final chatRef = firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .collection("participant")
          .doc(id)
          .delete();
    } else if (type == "group") {
      log("removeing member from group");
      await firebaseFirestore.collection("group").doc(id).update({
        'activeMember':
            FieldValue.arrayRemove([CurrentUser.instance.currentUser!.phoneNo])
      });
    }
  }

  Future<void> exitGroup(String id) async {
    try {
      final groupRef = firebaseFirestore.collection("group").doc(id);
      final data = await groupRef.get();
      app_group.Group groupDetail = app_group.Group.fromJson(data.data()!);
      groupRef.update({
        "member": FieldValue.arrayRemove([
          groupDetail.member.firstWhere((e) =>
              e.memberId == FirebaseAuth.instance.currentUser!.phoneNumber!)
            ..toJson()
        ]),
        'activeMember': FieldValue.arrayRemove(
            [FirebaseAuth.instance.currentUser!.phoneNumber!])
      });
    } on Exception catch (e) {
      log("error in exitGroup $e");
    }
  }

  Future<void> addToBlock(String id) async {
    try {
      final blockRef = firebaseFirestore
          .collection("block_central")
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .set({
        "blockedUser": FieldValue.arrayUnion([id])
      }, SetOptions(merge: true));
    } on Exception catch (e) {
      log("error in exitGroup $e");
    }
  }

  Future<void> removeFromBlock(String id) async {
    try {
      final blockRef = firebaseFirestore
          .collection("block_central")
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .update({
        "blockedUser": FieldValue.arrayRemove([id])
      });
    } on Exception catch (e) {
      log("error in removing blocked user $e");
    }
  }

  Future<void> clearChat(
    String id,
  ) async {
    try {
      firebaseFirestore.collection("deletedChat").doc(id).delete();
    } on Exception catch (e) {
      log("error on trying to clear chat of $id $e");
    }
  }

  Future<void> updateMobileNumber(String newNumber, String oldNumber) async {
    log("updating user detail");
    log("new number $newNumber old number $oldNumber");
    deleteUser(newNumber);
    final userRef = firebaseFirestore.collection("users");
    final participant = userRef.doc(oldNumber).collection("participant");
    my_app.User userDataWithOldNumber = await getSingleUser(oldNumber);
    List<Participant> oldUserParticipant = List.empty(growable: true);
    final participantData = await participant.get();
    log("user detail ${userDataWithOldNumber.toJson()}");
    userDataWithOldNumber.phoneNo = newNumber;
    await userRef.doc(newNumber).set(userDataWithOldNumber.toJson());
    log("user detail ${userDataWithOldNumber.toJson()}");

    if (participantData.docs.isNotEmpty) {
      for (var element in participantData.docs) {
        Participant participant = Participant.fromJson(element.data());
        await addParticipant(participant);
      }
    }
    QuerySnapshot<Map<String, dynamic>>? participantToUpdate;
    for (var element in oldUserParticipant) {
      log("participant added to update list ${element.toJson()}");
      participantToUpdate = await userRef
          .doc(element.withUser)
          .collection("participant")
          .where("withUser", isEqualTo: oldNumber)
          .get();
    }

    if (participantToUpdate != null && participantToUpdate.docs.isNotEmpty) {
      for (var element in participantToUpdate.docs) {
        log("participant updated ${element.data()}");
        await element.reference.update(
          {"withUser": newNumber},
        );
      }
    } else {
      log("no participant to update");
    }
    final groupRef = firebaseFirestore.collection("group");

    final groupdDetail =
        await groupRef.where("activeMember", arrayContains: oldNumber).get();

    if (groupdDetail.docs.isNotEmpty) {
      log("updating group detail");
      for (var element in groupdDetail.docs) {
        app_group.Group group = app_group.Group.fromJson(element.data());
        log("group name ${group.name}");

        app_group.GroupMember groupMember =
            group.member.firstWhere((e) => e.memberId == oldNumber);
        log("old group memeber ${groupMember.memberId}");
        groupMember.memberId = newNumber;

        log("updating group");
        await groupRef.doc(element.reference.id).set(group.toJson());
      }
    }
  }

  Future<void> updateNotification() async {
    final notificationDataSetRef = firebaseFirestore
        .collection("notification")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber!);

    notificationDataSetRef.set({
      "group_chat":
          CurrentUserSetting.instance.userSetting.isPrivateChatNotificationOn,
      "private_chat":
          CurrentUserSetting.instance.userSetting.isGroupChatNotificationON
    });
  }

  Future<void> toggelMuteNoitifcation(String number, bool newValue) async {
    final notificationDataRef = firebaseFirestore
        .collection("notification")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber!);

    await notificationDataRef.update({number: newValue});
  }

  Future<void> addGroupMemeber(
      List<app_group.GroupMember> groupMember, String id) async {
    for (var element in groupMember) {
      firebaseFirestore.collection("group").doc(id).update({
        'activeMember': FieldValue.arrayUnion([element.memberId]),
        'member': FieldValue.arrayUnion([element.toJson()])
      });
    }
  }

  Future<void> updateGroupName(String newName, String id) async {
    firebaseFirestore.collection("group").doc(id).update({'name': newName});
  }

  Future<void> updateGroupProfileUrl(String newProfileUrl, String id) async {
    firebaseFirestore
        .collection("group")
        .doc(id)
        .update({'profilePhotoUrl': newProfileUrl});
  }

  Future<void> removeMemberFromGroup(
      List<app_group.GroupMember> member, String id) async {
    for (var element in member) {
      firebaseFirestore.collection("group").doc(id).update({
        'activeMember': FieldValue.arrayRemove([element.memberId]),
        'member': FieldValue.arrayRemove([element.toJson()])
      });
    }
  }

  Future<void> makeNewAdmin(
      List<app_group.GroupMember> member, String id) async {
    log("group member ${member.length}");
    await removeMemberFromGroup(member, id);
    List<app_group.GroupMember> modifyedMember = member
        .map((e) => app_group.GroupMember(memberId: e.memberId, isAdmin: true))
        .toList();

    await addGroupMemeber(modifyedMember, id);
  }

  Future<void> updateLastMessage(
      String messageData, bool isGroup, String id, String timeStamp) async {
    log("updating last message");
    if (isGroup) {
      firebaseFirestore.collection("group").doc(id).update(
          {"lastMessage": messageData, "lastMessageTimeStamp": timeStamp});
    } else {
      firebaseFirestore
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.phoneNumber)
          .collection("participant")
          .doc(id)
          .update(
              {"lastMessage": messageData, "lastMessageTimeStamp": timeStamp});
    }
  }

  Future<my_app.User?> deepSearch(String number) async {
    try {
      final data = await firebaseFirestore
          .collection("users")
          .where("phoneNo", isEqualTo: number)
          .get();
      if (data.docs.isNotEmpty) {
        log("user found");
        if (data.docs.first.exists) {
          return my_app.User.fromJson(data.docs.first.data());
        }
      }
      return null;
    } catch (e) {
      log("Error in deep search");
      return null;
    }
  }

  Future<void> forwardMessage(Map<String, List<Message>> messageToForward,
      List<String> toChatIds) async {
    try {
      log("forwarding message");
      for (var chatId in messageToForward.keys) {
        final messageToSend = messageToForward[chatId];
        log("forwarding message to id $chatId");
        int count = messageToSend!.length;
        for (Message msg in messageToSend) {
          await sendMessage(msg, chatId);

          log("message ${msg.toJson()}");
          count--;
          if (count == 0) {
            if (msg.contentType == "text") {
              updateLastMessage(msg.content!, msg.receiver!.length > 1, chatId,
                  msg.timeStamp!);
            } else {
              updateLastMessage(msg.contentType!, msg.receiver!.length > 1,
                  chatId, msg.timeStamp!);
            }
          }
        }
      }
    } catch (e) {
      log("Error forwarding message $e");
    }
  }

  Future<void> deleteUser(String number) async {
    try {
      await firebaseFirestore.collection("users").doc(number).delete();
    } catch (e) {
      log("error in deleting data");
    }
  }

  Future<bool> checkIfUserIsMute(String number) async {
    final notificationDataRef = firebaseFirestore
        .collection("notification")
        .doc(FirebaseAuth.instance.currentUser!.phoneNumber!);

    final result = await notificationDataRef.get();
    if (result.exists) {
      if (result.data() != null) {
        log("notification data exits");
        if (result.data()!.containsKey(number) && result.data()![number]) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}
